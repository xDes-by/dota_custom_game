LinkLuaModifier("modifier_spell_as", "heroes/hero_zuus/spell_as", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_zuus_agi8 = class({})

function npc_dota_hero_zuus_agi8:GetIntrinsicModifierName()
	return "modifier_spell_as"
end


modifier_spell_as = class({})

function modifier_spell_as:IsHidden()
	return self:GetStackCount()==0
end

function modifier_spell_as:IsDebuff()
	return false
end

function modifier_spell_as:RemoveOnDeath()
    return false
end

function modifier_spell_as:IsPurgable()
	return false
end

function modifier_spell_as:DestroyOnExpire()
	return false
end

function modifier_spell_as:OnCreated( kv )
	self.as_bonus = 10
	self.duration = 5

	if not IsServer() then return end
	self:PlayEffects()
end

function modifier_spell_as:OnRefresh( kv )
	self.as_bonus = 10
	self.duration = 5
end

function modifier_spell_as:OnRemoved()
end

function modifier_spell_as:OnDestroy()
end

function modifier_spell_as:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_spell_as:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.as_bonus
end

function modifier_spell_as:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end

	--if self:GetStackCount()<self.max_stacks then
		self:IncrementStackCount()
	--end

	self:SetDuration( self.duration, true )
	self:StartIntervalThink( self.duration )

	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end

function modifier_spell_as:OnIntervalThink()
	self:StartIntervalThink( -1 )
	self:SetStackCount( 0 )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end


function modifier_spell_as:PlayEffects()
	local particle_cast = ""

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )

	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end