LinkLuaModifier( "modifier_silencer_curse_of_the_silent_lua", "heroes/hero_silencer/curse_of_the_silent_lua/curse_of_the_silent_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_curse_of_the_silent_aura", "heroes/hero_silencer/curse_of_the_silent_lua/curse_of_the_silent_lua.lua", LUA_MODIFIER_MOTION_NONE )

silencer_curse_of_the_silent_lua = {}

function silencer_curse_of_the_silent_lua:GetIntrinsicModifierName()
    return "modifier_silencer_curse_of_the_silent_aura"
end

function silencer_curse_of_the_silent_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function silencer_curse_of_the_silent_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function silencer_curse_of_the_silent_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function silencer_curse_of_the_silent_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi11") then
		return 0
	end
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function silencer_curse_of_the_silent_lua:GetCastRange()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi11") then
		return 700
	end
end

function silencer_curse_of_the_silent_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi11") then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
end

function silencer_curse_of_the_silent_lua:GetCooldown()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi11") then
		return 0
	end
end

function silencer_curse_of_the_silent_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		EmitSoundOn( "Hero_Silencer.Curse.Cast", self:GetCaster() )
	end
	
end

function silencer_curse_of_the_silent_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster,
			self,
			"modifier_silencer_curse_of_the_silent_lua",
			{ duration = duration }
		)
	end

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_silencer/silencer_curse_cast.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetCaster()
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_Silencer.Curse.Cast", self:GetCaster() )

	local effect_aoe = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf",
		PATTACH_WORLDORIGIN,
		nil
	)
	ParticleManager:SetParticleControl( effect_aoe, 0, point )
	ParticleManager:SetParticleControl( effect_aoe, 1, Vector( radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_aoe )

	EmitSoundOnLocationWithCaster( point, "Hero_Silencer.Curse", self:GetCaster() )
end

modifier_silencer_curse_of_the_silent_lua = {}

function modifier_silencer_curse_of_the_silent_lua:IsHidden()
	return false
end

function modifier_silencer_curse_of_the_silent_lua:IsDebuff()
	return true
end

function modifier_silencer_curse_of_the_silent_lua:IsStunDebuff()
	return false
end

function modifier_silencer_curse_of_the_silent_lua:IsPurgable()
	return true
end

function modifier_silencer_curse_of_the_silent_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_silencer_curse_of_the_silent_lua:OnCreated( kv )
	self.penalty = self:GetAbility():GetSpecialValueFor( "penalty_duration" )
	self.slow = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_agi10") then
		self.damage = self.damage + self:GetCaster():GetIntellect() * 0.5
	end
	

	if not IsServer() then return end
	self.isProvidedByAura = kv.isProvidedByAura
	self.interval = 1

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	}
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_str10") then
		self.interval = 0.5
	end
	self:StartIntervalThink( self.interval )
	if not self.isProvidedByAura then
		EmitSoundOn( "Hero_Silencer.Curse.Impact", self:GetParent() )
	end
end

function modifier_silencer_curse_of_the_silent_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end
-- npc_dota_hero_silencer_str10
function modifier_silencer_curse_of_the_silent_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_silencer_curse_of_the_silent_lua:GetModifierDamageOutgoing_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_str9") then
		return -20
	end
end

function modifier_silencer_curse_of_the_silent_lua:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	self:SetDuration( self:GetRemainingTime() + self.penalty, true )
end

function modifier_silencer_curse_of_the_silent_lua:OnIntervalThink()
	if self:GetParent():IsSilenced() then
		self.damageTable.damage = self.damage * self:GetAbility():GetSpecialValueFor("silence_multi")
	else
		self.damageTable.damage = self.damage
	end
	ApplyDamage( self.damageTable )

	EmitSoundOn( "Hero_Silencer.Curse_Tick", self:GetParent() )
end

function modifier_silencer_curse_of_the_silent_lua:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_curse.vpcf"
end

function modifier_silencer_curse_of_the_silent_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


modifier_silencer_curse_of_the_silent_aura = class({})


function modifier_silencer_curse_of_the_silent_aura:IsDebuff()			
	return false 
end

function modifier_silencer_curse_of_the_silent_aura:IsHidden() 			
	return true 
end

function modifier_silencer_curse_of_the_silent_aura:IsPurgable() 			
	return false 
end

function modifier_silencer_curse_of_the_silent_aura:IsPurgeException() 	
	return false 
end

function modifier_silencer_curse_of_the_silent_aura:OnCreated()
	if not IsServer() then
		return
	end
end

function modifier_silencer_curse_of_the_silent_aura:IsAura() 
	if self:GetAbility():GetToggleState() then
		return true 
	end
	return false 
end

function modifier_silencer_curse_of_the_silent_aura:GetModifierAura() 
	return "modifier_silencer_curse_of_the_silent_lua" 
end

function modifier_silencer_curse_of_the_silent_aura:GetAuraRadius()
	return 700
end

function modifier_silencer_curse_of_the_silent_aura:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_silencer_curse_of_the_silent_aura:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_silencer_curse_of_the_silent_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end