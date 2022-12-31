LinkLuaModifier("modifier_creature_mana_burn_aura", "creatures/abilities/regular/creature_mana_burn_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_mana_burn_aura_debuff", "creatures/abilities/regular/creature_mana_burn_aura", LUA_MODIFIER_MOTION_NONE)

creature_mana_burn_aura = class({})

function creature_mana_burn_aura:GetIntrinsicModifierName()
	return "modifier_creature_mana_burn_aura"
end



modifier_creature_mana_burn_aura = class({})

function modifier_creature_mana_burn_aura:IsHidden() return true end
function modifier_creature_mana_burn_aura:IsDebuff() return false end
function modifier_creature_mana_burn_aura:IsPurgable() return false end
function modifier_creature_mana_burn_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_mana_burn_aura:IsAura() return true end
function modifier_creature_mana_burn_aura:GetAuraRadius() return 1200 end
function modifier_creature_mana_burn_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_mana_burn_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_mana_burn_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_mana_burn_aura:GetModifierAura() return "modifier_creature_mana_burn_aura_debuff" end

function modifier_creature_mana_burn_aura:GetEffectName()
	return "particles/creature/mana_burn_aura.vpcf"
end

function modifier_creature_mana_burn_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_mana_burn_aura_debuff = class({})

function modifier_creature_mana_burn_aura_debuff:IsHidden() return false end
function modifier_creature_mana_burn_aura_debuff:IsDebuff() return true end
function modifier_creature_mana_burn_aura_debuff:IsPurgable() return false end

function modifier_creature_mana_burn_aura_debuff:OnCreated()
	self.mana_degen = self:GetAbility():GetSpecialValueFor("mana_degen")
end

function modifier_creature_mana_burn_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
end

function modifier_creature_mana_burn_aura_debuff:GetModifierTotalPercentageManaRegen()
	return self.mana_degen
end
