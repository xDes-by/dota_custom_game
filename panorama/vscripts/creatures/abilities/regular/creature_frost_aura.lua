LinkLuaModifier("modifier_creature_frost_aura", "creatures/abilities/regular/creature_frost_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_frost_aura_debuff", "creatures/abilities/regular/creature_frost_aura", LUA_MODIFIER_MOTION_NONE)

creature_frost_aura = class({})

function creature_frost_aura:GetIntrinsicModifierName()
	return "modifier_creature_frost_aura"
end



modifier_creature_frost_aura = class({})

function modifier_creature_frost_aura:IsHidden() return true end
function modifier_creature_frost_aura:IsDebuff() return false end
function modifier_creature_frost_aura:IsPurgable() return false end
function modifier_creature_frost_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_frost_aura:IsAura() return true end
function modifier_creature_frost_aura:GetAuraRadius() return 1200 end
function modifier_creature_frost_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_frost_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_frost_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_frost_aura:GetModifierAura() return "modifier_creature_frost_aura_debuff" end

function modifier_creature_frost_aura:GetEffectName()
	return "particles/creature/frost_aura.vpcf"
end

function modifier_creature_frost_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_frost_aura_debuff = class({})

function modifier_creature_frost_aura_debuff:IsHidden() return false end
function modifier_creature_frost_aura_debuff:IsDebuff() return true end
function modifier_creature_frost_aura_debuff:IsPurgable() return false end

function modifier_creature_frost_aura_debuff:GetEffectName()
	return "particles/creature/frost_aura_debuff.vpcf"
end

function modifier_creature_frost_aura_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_frost_aura_debuff:OnCreated()
	self.as_slow = self:GetAbility():GetSpecialValueFor("as_slow")
end

function modifier_creature_frost_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creature_frost_aura_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end
