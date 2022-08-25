LinkLuaModifier("modifier_boss_3_slow_aura", "abilities/bosses/line/boss_3/boss_3_slow",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_3_slow_aura_debuff", "abilities/bosses/line/boss_3/boss_3_slow",LUA_MODIFIER_MOTION_NONE)

boss_3_slow = class({})

function boss_3_slow:GetIntrinsicModifierName()
	return "modifier_boss_3_slow_aura"
end

------------------------------------------------------------------------------

modifier_boss_3_slow_aura = class({})

function modifier_boss_3_slow_aura:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.aura_radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_boss_3_slow_aura:GetEffectName()
	return "particles/auras/aura_degen.vpcf"
end

function modifier_boss_3_slow_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_3_slow_aura:GetAuraDuration()
	return 0.1
end

function modifier_boss_3_slow_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_boss_3_slow_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_boss_3_slow_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_boss_3_slow_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_boss_3_slow_aura:GetModifierAura()
	return "modifier_boss_3_slow_aura_debuff"
end

function modifier_boss_3_slow_aura:IsAura()
	if self.caster:PassivesDisabled() then
		return false
	end
	return true
end

function modifier_boss_3_slow_aura:IsHidden() return true end
function modifier_boss_3_slow_aura:IsPurgable() return false end
function modifier_boss_3_slow_aura:IsDebuff() return false end

function modifier_boss_3_slow_aura:OnRefresh()
	self:OnCreated()
end

----------------------------------------------------------------------------------

modifier_boss_3_slow_aura_debuff = class({})

function modifier_boss_3_slow_aura_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.ms_slow_pct = self.ability:GetSpecialValueFor("slow_movement_speed")
	self.as_slow = self.ability:GetSpecialValueFor("slow_attack_speed")
end

function modifier_boss_3_slow_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"    
end

function modifier_boss_3_slow_aura_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_boss_3_slow_aura_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_boss_3_slow_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct
end

function modifier_boss_3_slow_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_boss_3_slow_aura_debuff:GetTexture()
	return "omniknight_degen_aura"
end