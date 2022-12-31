innate_blank_soul = class({})

LinkLuaModifier("modifier_innate_blank_soul", "heroes/innates/blank_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_blank_soul_aura", "heroes/innates/blank_soul", LUA_MODIFIER_MOTION_NONE)

function innate_blank_soul:GetIntrinsicModifierName()
	return "modifier_innate_blank_soul"
end

modifier_innate_blank_soul = class({})

function modifier_innate_blank_soul:IsHidden() return true end
function modifier_innate_blank_soul:IsDebuff() return false end
function modifier_innate_blank_soul:IsPurgable() return false end
function modifier_innate_blank_soul:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

-- Aura Properties
function modifier_innate_blank_soul:IsAura() return true end
function modifier_innate_blank_soul:GetAuraRadius() return 1200 end
function modifier_innate_blank_soul:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_innate_blank_soul:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_innate_blank_soul:GetModifierAura() return "modifier_innate_blank_soul_aura" end



modifier_innate_blank_soul_aura = class({})

function modifier_innate_blank_soul:IsDebuff() return false end
function modifier_innate_blank_soul:IsPurgable() return false end

function modifier_innate_blank_soul_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_innate_blank_soul_aura:OnCreated()
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.magic_resist = (-1) * ability:GetSpecialValueFor("magic_resist")
	self.status_resist = (-1) * ability:GetSpecialValueFor("status_resist")
end

function modifier_innate_blank_soul_aura:GetModifierMagicalResistanceBonus()
	return self.magic_resist or 0
end

function modifier_innate_blank_soul_aura:GetModifierStatusResistanceStacking()
	return self.status_resist or 0
end

function modifier_innate_blank_soul_aura:GetEffectName()
	return "particles/custom/innates/blank_soul_debuff.vpcf"
end

function modifier_innate_blank_soul_aura:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_innate_blank_soul_aura:ShouldUseOverheadOffset()
	return false
end
