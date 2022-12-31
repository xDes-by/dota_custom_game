innate_overwhelming_presence = class({})

LinkLuaModifier("modifier_innate_overwhelming_presence", "heroes/innates/overwhelming_presence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_overwhelming_presence_aura", "heroes/innates/overwhelming_presence", LUA_MODIFIER_MOTION_NONE)

function innate_overwhelming_presence:GetIntrinsicModifierName()
	return "modifier_innate_overwhelming_presence"
end

modifier_innate_overwhelming_presence = class({})

function modifier_innate_overwhelming_presence:IsHidden() return true end
function modifier_innate_overwhelming_presence:IsDebuff() return false end
function modifier_innate_overwhelming_presence:IsPurgable() return false end
function modifier_innate_overwhelming_presence:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

-- Aura Properties
function modifier_innate_overwhelming_presence:IsAura() return true end
function modifier_innate_overwhelming_presence:GetAuraRadius() return 300 end
function modifier_innate_overwhelming_presence:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_innate_overwhelming_presence:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_innate_overwhelming_presence:GetModifierAura() return "modifier_innate_overwhelming_presence_aura" end



modifier_innate_overwhelming_presence_aura = class({})

function modifier_innate_overwhelming_presence:IsDebuff() return false end
function modifier_innate_overwhelming_presence:IsPurgable() return false end
function modifier_innate_overwhelming_presence:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_innate_overwhelming_presence_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_innate_overwhelming_presence_aura:OnCreated()
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.damage_amp = ability:GetSpecialValueFor("damage_amp")
end

function modifier_innate_overwhelming_presence_aura:GetModifierIncomingDamage_Percentage(params)
    return self.damage_amp
end

function modifier_innate_overwhelming_presence_aura:GetEffectName()
	return "particles/creature/overwhelming_presence_aura_debuff.vpcf"
end

function modifier_innate_overwhelming_presence_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
