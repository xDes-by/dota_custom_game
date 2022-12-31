broodmother_spawn_spiderlings_lua = class({})
LinkLuaModifier("modifier_broodmother_spawn_spiderlings_lua", "heroes/hero_broodmother/broodmother_spawn_spiderlings_lua.lua", LUA_MODIFIER_MOTION_NONE)

function broodmother_spawn_spiderlings_lua:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	if caster == target then return UF_SUCCESS end
	
	return UnitFilter(target, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		caster:GetTeamNumber()
	)
end

function broodmother_spawn_spiderlings_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	-- load data
	local buff_duration = self:GetSpecialValueFor("buff_duration")
	local damage = self:GetSpecialValueFor("damage")
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local projectile_name = "particles/units/heroes/hero_broodmother/broodmother_web_cast.vpcf"

	-- multicast
	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	local projectile = {
		Source = caster,
		Target = target,
		Ability = self,
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,
		ExtraData = {
			damage = damage,
			multicast = multicast,
			buff_duration = buff_duration,
		}
	}

	ProjectileManager:CreateTrackingProjectile( projectile )
	EmitSoundOn( "Hero_Broodmother.SpawnSpiderlingsCast", caster )
	
end

function broodmother_spawn_spiderlings_lua:OnProjectileHit_ExtraData( target, location, extraData )

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	-- Cancel if linken
	if target:TriggerSpellAbsorb(self) then
		return
	end

	-- Has a stack limit of 7
	local modifiers = target:FindAllModifiersByName("modifier_broodmother_spawn_spiderlings_lua")
	if #modifiers >= 7 then return end

	target:AddNewModifier(caster, self, "modifier_broodmother_spawn_spiderlings_lua", {duration = extraData.buff_duration, multicast = extraData.multicast})
	
	if caster == target then return end
		
	-- Apply damage
	local damage = {
		victim = target,
		attacker = self:GetCaster(),
		damage = extraData.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}
	ApplyDamage( damage )

	EmitSoundOn( "Hero_Broodmother.SpawnSpiderlingsImpact", target )
end


modifier_broodmother_spawn_spiderlings_lua = class({})

function modifier_broodmother_spawn_spiderlings_lua:IsHidden() return false end
function modifier_broodmother_spawn_spiderlings_lua:IsPurgable() return false end
function modifier_broodmother_spawn_spiderlings_lua:IsDebuff() return true end
function modifier_broodmother_spawn_spiderlings_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_broodmother_spawn_spiderlings_lua:GetEffectName()
    return "particles/units/heroes/hero_broodmother/broodmother_spiderlings_debuff.vpcf"
end

function modifier_broodmother_spawn_spiderlings_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_broodmother_spawn_spiderlings_lua:OnCreated(keys)
	if not IsServer() then return end

	local caster = self:GetCaster()
	local origin = caster:GetAbsOrigin()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not ability or ability:IsNull() then return end

	self.spiderling_duration = ability:GetSpecialValueFor("spiderling_duration")
	self.count = ability:GetSpecialValueFor("count")
	self.multicast = keys.multicast

	-- only spawn on impact if the caster is the one with the modifier
	if self:GetParent() ~= caster then return end

	self:SpawnSpiderlings(caster, origin, self.multicast)
	self:Destroy()
end

function modifier_broodmother_spawn_spiderlings_lua:OnRefresh()
	self:OnCreated()
end

function modifier_broodmother_spawn_spiderlings_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_broodmother_spawn_spiderlings_lua:OnDeath(keys)
	if keys.unit ~= self:GetParent() then return end
	local caster = self:GetCaster()
	local origin = keys.unit:GetAbsOrigin()
	if not caster or caster:IsNull() then return end

	self:SpawnSpiderlings(caster, origin, self.multicast)
	
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf", PATTACH_ABSORIGIN, keys.unit )
	ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_broodmother_spawn_spiderlings_lua:SpawnSpiderlings(caster, origin, multicast_factor)
	local unit = CreateUnitByName("npc_dota_broodmother_spiderling", origin, true, caster, caster, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:AddNewModifier(caster, self, "modifier_kill", {duration = self.spiderling_duration})

	local talent_health = self:GetAbility():GetSpecialValueFor("hp_bonus")		-- +350 spider health
	local talent_damage_pct = caster:FindTalentValue("special_bonus_custom_broodmother_4")	-- +50% spider damage

	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + talent_health)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() * (1 + talent_damage_pct * 0.01))
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() * (1 + talent_damage_pct * 0.01))

	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * multicast_factor * self.count)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() * multicast_factor * self.count)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() * multicast_factor * self.count)

	unit:FindAbilityByName("broodmother_poison_sting"):SetLevel(1)
	unit:FindAbilityByName("broodmother_spawn_spiderite"):SetLevel(1)
	unit:AddAbility("summon_buff")
	
	EmitSoundOn( "Hero_Broodmother.SpawnSpiderlings", unit )

	unit.multicast_multiplier = multicast_factor
	unit.spawn_count = self.count

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	if multicast_factor > 1 and multicast_modifier then
		multicast_modifier:PlaySummonFX(unit, multicast_factor)
	end

	Timers:CreateTimer(0.5, function()
		if not IsValidEntity(unit) or not unit:IsAlive() then return end

		unit.original_damage_min = unit.original_damage_min or unit:GetBaseDamageMin()
		unit.original_damage_max = unit.original_damage_max or unit:GetBaseDamageMax()

		--Set unit damage according to their health
		local round_to = 100 / unit.spawn_count
		local x = math.ceil(unit:GetHealthPercent() / round_to) * round_to / 100
		unit:SetBaseDamageMin(unit.original_damage_min * x)
		unit:SetBaseDamageMax(unit.original_damage_max * x)

		return 0.5
	end)
	
	ResolveNPCPositions(origin, 128)
end