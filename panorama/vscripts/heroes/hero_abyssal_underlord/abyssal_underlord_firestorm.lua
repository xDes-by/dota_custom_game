abyssal_underlord_firestorm_lua = class({})
LinkLuaModifier( "modifier_abyssal_underlord_firestorm_burn_lua", "heroes/hero_abyssal_underlord/abyssal_underlord_firestorm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abyssal_underlord_firestorm_thinker_lua", "heroes/hero_abyssal_underlord/abyssal_underlord_firestorm", LUA_MODIFIER_MOTION_NONE )

function abyssal_underlord_firestorm_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function abyssal_underlord_firestorm_lua:GetBehavior()
	if self:GetCaster():HasShard() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return self.BaseClass.GetBehavior(self)
end

function abyssal_underlord_firestorm_lua:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM
end

function abyssal_underlord_firestorm_lua:OnAbilityPhaseStart()
	local point = self:GetCursorPosition()
	self:PlayEffects( point )
	return true
end

function abyssal_underlord_firestorm_lua:OnAbilityPhaseInterrupted()
	self:StopEffects()
end

function abyssal_underlord_firestorm_lua:OnSpellStart()
	self:StopEffects()

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	local point = self:GetCursorPosition()
	local target = self:GetCursorTarget()
	local self_cast = false
	if target and not target:IsNull() and target == caster then
		self_cast = true
	end

	-- multicast
	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1
	local delay = 0.5

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	-- create thinker
	for i = 0, multicast - 1, 1 do
		Timers:CreateTimer(delay * i, function()
			if caster and self and IsValidEntity(caster) and IsValidEntity(self) then
				CreateModifierThinker(caster, self, "modifier_abyssal_underlord_firestorm_thinker_lua", {self_cast = self_cast}, point, caster:GetTeamNumber(), false)
				return
			end
		end)
	end
end

function abyssal_underlord_firestorm_lua:PlayEffects( point )
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 2, 2, 2 ) )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, "Hero_AbyssalUnderlord.Firestorm.Start", self:GetCaster() )
end

function abyssal_underlord_firestorm_lua:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end


----------------------------------------------------------------------------------------------------------------------------------------------


modifier_abyssal_underlord_firestorm_thinker_lua = class({})

function modifier_abyssal_underlord_firestorm_thinker_lua:IsHidden() return true end
function modifier_abyssal_underlord_firestorm_thinker_lua:IsPurgable() return false end

function modifier_abyssal_underlord_firestorm_thinker_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if not self.caster or self.caster:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	-- references
	local wave_damage = self.ability:GetSpecialValueFor( "wave_damage" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.wave_count = self.ability:GetSpecialValueFor( "wave_count" )
	self.wave_interval = self.ability:GetSpecialValueFor( "wave_interval" )
	self.burn_duration = self.ability:GetSpecialValueFor( "burn_duration" )
	self.self_cast = kv.self_cast

	if not IsServer() then return end

	-- init
	self.wave = 0
	self.damage_table = {
		-- victim = target,
		attacker = self.caster,
		damage = wave_damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability,
	}

	self:StartIntervalThink( self.wave_interval )
	self:OnIntervalThink()
end

function modifier_abyssal_underlord_firestorm_thinker_lua:OnRefresh( kv )
end

function modifier_abyssal_underlord_firestorm_thinker_lua:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove(self.parent)
end

function modifier_abyssal_underlord_firestorm_thinker_lua:OnIntervalThink()
	if self.self_cast == 1 then
		self.parent:SetAbsOrigin(self.caster:GetAbsOrigin())
	end

	-- find enemies
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	for _, enemy in pairs(enemies) do
		self.damage_table.victim = enemy
		ApplyDamage(self.damage_table)

		-- add debuff
		enemy:AddNewModifier(self.caster, self.ability, "modifier_abyssal_underlord_firestorm_burn_lua", {duration = self.burn_duration})
	end

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm", self.parent )

	-- wave counter
	self.wave = self.wave + 1
	if self.wave >= self.wave_count then
		self:Destroy()
		return
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------


modifier_abyssal_underlord_firestorm_burn_lua = class({})

function modifier_abyssal_underlord_firestorm_burn_lua:IsHidden() return false end
function modifier_abyssal_underlord_firestorm_burn_lua:IsDebuff() return true end
function modifier_abyssal_underlord_firestorm_burn_lua:IsStunDebuff() return false end
function modifier_abyssal_underlord_firestorm_burn_lua:IsPurgable() return true end

function modifier_abyssal_underlord_firestorm_burn_lua:OnCreated(kv)
	if not IsServer() then return end

	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if not self.caster or self.caster:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.burn_interval = self.ability:GetSpecialValueFor( "burn_interval" )
	self.burn_damage = self.ability:GetSpecialValueFor( "burn_damage" )

	-- precache damage
	self.damageTable = {
		victim = self.parent,
		attacker = self.caster,
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self.ability,
	}

	-- Start interval
	self:StartIntervalThink( self.burn_interval )
	self:OnIntervalThink()
end

function modifier_abyssal_underlord_firestorm_burn_lua:OnIntervalThink()
	self.damageTable.damage = self.parent:GetMaxHealth() * self.burn_damage * 0.01
	ApplyDamage( self.damageTable )
end

function modifier_abyssal_underlord_firestorm_burn_lua:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_abyssal_underlord_firestorm_burn_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end