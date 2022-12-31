LinkLuaModifier("modifier_creature_packleader", "creatures/abilities/regular/creature_packleader", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_packleader_buff", "creatures/abilities/regular/creature_packleader", LUA_MODIFIER_MOTION_NONE)

creature_packleader = class({})

function creature_packleader:GetIntrinsicModifierName()
	return "modifier_creature_packleader"
end



modifier_creature_packleader = class({})

function modifier_creature_packleader:IsHidden() return true end
function modifier_creature_packleader:IsDebuff() return false end
function modifier_creature_packleader:IsPurgable() return false end
function modifier_creature_packleader:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_packleader:GetEffectName()
	return "particles/creature/pack_mentality.vpcf"
end

function modifier_creature_packleader:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_packleader:IsAura() return true end
function modifier_creature_packleader:GetAuraRadius() return 1200 end
function modifier_creature_packleader:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_packleader:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_packleader:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_packleader:GetModifierAura() return "modifier_creature_packleader_buff" end



modifier_creature_packleader_buff = class({})

function modifier_creature_packleader_buff:IsHidden() return false end
function modifier_creature_packleader_buff:IsDebuff() return false end
function modifier_creature_packleader_buff:IsPurgable() return false end

function modifier_creature_packleader_buff:OnCreated() 
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then self.bonus_dmg = 0 return end
	self.bonus_dmg = ability:GetSpecialValueFor("bonus_dmg")
end

function modifier_creature_packleader_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_creature_packleader_buff:GetModifierDamageOutgoing_Percentage()
	return self.bonus_dmg
end
