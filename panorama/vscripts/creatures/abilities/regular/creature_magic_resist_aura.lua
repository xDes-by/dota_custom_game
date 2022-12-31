LinkLuaModifier("modifier_creature_magic_resist_aura", "creatures/abilities/regular/creature_magic_resist_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_magic_resist_aura_buff", "creatures/abilities/regular/creature_magic_resist_aura", LUA_MODIFIER_MOTION_NONE)

creature_magic_resist_aura = class({})

function creature_magic_resist_aura:GetIntrinsicModifierName()
	return "modifier_creature_magic_resist_aura"
end



modifier_creature_magic_resist_aura = class({})

function modifier_creature_magic_resist_aura:IsHidden() return true end
function modifier_creature_magic_resist_aura:IsDebuff() return false end
function modifier_creature_magic_resist_aura:IsPurgable() return false end
function modifier_creature_magic_resist_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_magic_resist_aura:IsAura() return true end
function modifier_creature_magic_resist_aura:GetAuraRadius() return 1200 end
function modifier_creature_magic_resist_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_magic_resist_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_magic_resist_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_magic_resist_aura:GetModifierAura() return "modifier_creature_magic_resist_aura_buff" end

function modifier_creature_magic_resist_aura:GetEffectName()
	return "particles/creature/magic_resist_aura.vpcf"
end

function modifier_creature_magic_resist_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_magic_resist_aura_buff = class({})

function modifier_creature_magic_resist_aura_buff:IsHidden() return false end
function modifier_creature_magic_resist_aura_buff:IsDebuff() return false end
function modifier_creature_magic_resist_aura_buff:IsPurgable() return false end

function modifier_creature_magic_resist_aura_buff:OnCreated()
	self.bonus_mr = self:GetAbility():GetSpecialValueFor("bonus_mr")
end

function modifier_creature_magic_resist_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_creature_magic_resist_aura_buff:GetModifierMagicalResistanceBonus()
	return self.bonus_mr
end
