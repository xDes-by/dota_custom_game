LinkLuaModifier("modifier_creature_damage_aura", "creatures/abilities/regular/creature_damage_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_damage_aura_buff", "creatures/abilities/regular/creature_damage_aura", LUA_MODIFIER_MOTION_NONE)

creature_damage_aura = class({})

function creature_damage_aura:GetIntrinsicModifierName()
	return "modifier_creature_damage_aura"
end



modifier_creature_damage_aura = class({})

function modifier_creature_damage_aura:IsHidden() return true end
function modifier_creature_damage_aura:IsDebuff() return false end
function modifier_creature_damage_aura:IsPurgable() return false end
function modifier_creature_damage_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_damage_aura:IsAura() return true end
function modifier_creature_damage_aura:GetAuraRadius() return 1200 end
function modifier_creature_damage_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_damage_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_damage_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_damage_aura:GetModifierAura() return "modifier_creature_damage_aura_buff" end

function modifier_creature_damage_aura:GetEffectName()
	return "particles/creature/damage_aura.vpcf"
end

function modifier_creature_damage_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_damage_aura_buff = class({})

function modifier_creature_damage_aura_buff:IsHidden() return false end
function modifier_creature_damage_aura_buff:IsDebuff() return false end
function modifier_creature_damage_aura_buff:IsPurgable() return false end

function modifier_creature_damage_aura_buff:OnCreated()
	self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_creature_damage_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_creature_damage_aura_buff:GetModifierDamageOutgoing_Percentage()
	return self.bonus_dmg
end
