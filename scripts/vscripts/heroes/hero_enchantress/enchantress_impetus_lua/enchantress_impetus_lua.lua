LinkLuaModifier("modifier_enchantress_impetus_lua", "heroes/hero_enchantress/enchantress_impetus_lua/enchantress_impetus_lua", LUA_MODIFIER_MOTION_NONE)

enchantress_impetus_lua = class({})

function enchantress_impetus_lua:GetManaCost(iLevel)    
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int8")  ~= nil then 
		return (100 + math.min(65000, self:GetCaster():GetIntellect() / 200)) / 2
	end
	return 100 + math.min(65000,self:GetCaster():GetIntellect() / 200)
end

function enchantress_impetus_lua:GetIntrinsicModifierName() 
	return "modifier_enchantress_impetus_lua"
end


function enchantress_impetus_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local particle_projectile = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
	local sound_cast = "Hero_Enchantress.Impetus"

	local projectile_speed = caster:GetProjectileSpeed()
	local vision_radius = 300

	EmitSoundOn(sound_cast, caster)    

	local searing_arrow_active
	searing_arrow_active = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		iMoveSpeed = projectile_speed,
		bDodgeable = true, 
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = true,        
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()      
		}

	ProjectileManager:CreateTrackingProjectile(searing_arrow_active)
	caster:PerformAttack(
		target, -- hTarget
		false, -- bUseCastAttackOrb
		true, -- bProcessProcs
		true, -- bSkipCooldown
		false, -- bIgnoreInvis
		true, -- bUseProjectile
		false, -- bFakeAttack
		false -- bNeverMiss
	)
end

function enchantress_impetus_lua:OnProjectileHit(target, location)
	if IsServer() then
		local caster = self:GetCaster()

		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		EmitSoundOn("Hero_Enchantress.ImpetusDamage", target)
	
		local distance_cap = self:GetSpecialValueFor("distance_cap")
		local distance_dmg = self:GetSpecialValueFor("distance_damage_pct")
		local distance = math.min( (caster:GetAbsOrigin()-target:GetAbsOrigin()):Length2D(), distance_cap )
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_agi11") ~= nil	then 
			distance_dmg = distance_dmg + 10 
		end
		
		local damage = distance_dmg / 100 * distance
		if caster:FindAbilityByName("npc_dota_hero_enchantress_int_last") ~= nil then
			damage = damage + self:GetCaster():GetIntellect() * 0.3
		end

		if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_enchantress_int50") ~= nil then
			damage = damage * 3
		end

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
	end
end

-------------------------------------------------------------

modifier_enchantress_impetus_lua = class({})

function modifier_enchantress_impetus_lua:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	self.impetus_orb	= false
	self.base_attack	= "particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf"
	self.impetus_attack	= "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
	self.attack_queue	= {}
	self.impetus_start	= "Hero_Enchantress.Impetus"
	self.impetus_damage	= "Hero_Enchantress.ImpetusDamage"
	
	self.distance_damage_pct = self.ability:GetSpecialValueFor("distance_damage_pct")
end

function modifier_enchantress_impetus_lua:OnRefresh()
	self.distance_damage_pct = self.ability:GetSpecialValueFor("distance_damage_pct")
end

function modifier_enchantress_impetus_lua:DeclareFunctions()
    local decFuncs = {
        MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ORDER
    }

    return decFuncs
end

function modifier_enchantress_impetus_lua:OnAttackStart( keys )
    if not IsServer() then return end
	if keys.attacker == self.caster and self.ability:IsFullyCastable() and not self.caster:IsSilenced() and not keys.target:IsBuilding() and not keys.target:IsOther() and (self.ability:GetAutoCastState() or self.impetus_orb) then
		self.parent:SetRangedProjectileName(self.impetus_attack)
	else
		self.parent:SetRangedProjectileName(self.base_attack)
	end
end

function modifier_enchantress_impetus_lua:OnAttack( keys )
    if not IsServer() then return end
	if keys.attacker == self.caster then
		if not self.caster:IsIllusion() and self.ability:IsFullyCastable() and not self.caster:IsSilenced() and not keys.target:IsBuilding() and not keys.target:IsOther() and (self.ability:GetAutoCastState() or self.impetus_orb) then
			table.insert(self.attack_queue, true)
			self.ability:UseResources(true, false, false, false)
			self.caster:EmitSound(self.impetus_start)
			self.impetus_orb = false
		else
			table.insert(self.attack_queue, false)
		end
	end
end

function modifier_enchantress_impetus_lua:OnAttackLanded( keys )
    if not IsServer() then return end
	if keys.attacker == self.caster and #self.attack_queue > 0 then
		if self.attack_queue[1] and not keys.target:IsBuilding() and keys.target:IsAlive() then
		
		
		local distance_cap = self:GetAbility():GetSpecialValueFor("distance_cap")
		local distance_dmg = self:GetAbility():GetSpecialValueFor("distance_damage_pct")
		local distance = math.min( (self.caster:GetAbsOrigin()-keys.target:GetAbsOrigin()):Length2D(), distance_cap )
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_agi11") ~= nil	then 
			distance_dmg = distance_dmg + 10 
		end
		
		local damage = distance_dmg / 100 * distance
		if self.caster:FindAbilityByName("npc_dota_hero_enchantress_int_last") ~= nil then
			damage = damage + self:GetCaster():GetIntellect() * 0.3
		end
		
		local damageTable = {
			victim = keys.target,
			attacker = self.caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, damage, nil)
		keys.target:EmitSound(self.impetus_damage)
		end	
		table.remove(self.attack_queue, 1)
	end
end

function modifier_enchantress_impetus_lua:OnAttackFail( keys )
    if not IsServer() then return end
	if keys.attacker == self.caster and #self.attack_queue > 0 then
		table.remove(self.attack_queue, 1)
	end
end

function modifier_enchantress_impetus_lua:OnOrder(keys)
	if keys.unit == self.caster then
		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET and keys.ability:GetName() == self.ability:GetName() then
			self.impetus_orb = true
		else
			self.impetus_orb = false
		end
	end
end