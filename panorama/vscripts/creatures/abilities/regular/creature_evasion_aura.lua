LinkLuaModifier("modifier_creature_evasion_aura", "creatures/abilities/regular/creature_evasion_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_evasion_aura_buff", "creatures/abilities/regular/creature_evasion_aura", LUA_MODIFIER_MOTION_NONE)

creature_evasion_aura = class({})

function creature_evasion_aura:GetIntrinsicModifierName()
	return "modifier_creature_evasion_aura"
end



modifier_creature_evasion_aura = class({})

function modifier_creature_evasion_aura:IsHidden() return true end
function modifier_creature_evasion_aura:IsDebuff() return false end
function modifier_creature_evasion_aura:IsPurgable() return false end
function modifier_creature_evasion_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_evasion_aura:IsAura() return true end
function modifier_creature_evasion_aura:GetAuraRadius() return 1200 end
function modifier_creature_evasion_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_evasion_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_evasion_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_evasion_aura:GetModifierAura() return "modifier_creature_evasion_aura_buff" end

function modifier_creature_evasion_aura:GetEffectName()
	return "particles/creature/evasion_aura.vpcf"
end

function modifier_creature_evasion_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_evasion_aura_buff = class({})

function modifier_creature_evasion_aura_buff:IsHidden() return false end
function modifier_creature_evasion_aura_buff:IsDebuff() return false end
function modifier_creature_evasion_aura_buff:IsPurgable() return false end

function modifier_creature_evasion_aura_buff:OnCreated()
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_creature_evasion_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_creature_evasion_aura_buff:GetModifierEvasion_Constant()
	return self.bonus_evasion
end
