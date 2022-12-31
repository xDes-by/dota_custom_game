LinkLuaModifier("modifier_creature_attack_speed_aura", "creatures/abilities/regular/creature_attack_speed_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_attack_speed_aura_buff", "creatures/abilities/regular/creature_attack_speed_aura", LUA_MODIFIER_MOTION_NONE)

creature_attack_speed_aura = class({})

function creature_attack_speed_aura:GetIntrinsicModifierName()
	return "modifier_creature_attack_speed_aura"
end



modifier_creature_attack_speed_aura = class({})

function modifier_creature_attack_speed_aura:IsHidden() return true end
function modifier_creature_attack_speed_aura:IsDebuff() return false end
function modifier_creature_attack_speed_aura:IsPurgable() return false end
function modifier_creature_attack_speed_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_attack_speed_aura:IsAura() return true end
function modifier_creature_attack_speed_aura:GetAuraRadius() return 1200 end
function modifier_creature_attack_speed_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_attack_speed_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_attack_speed_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_attack_speed_aura:GetModifierAura() return "modifier_creature_attack_speed_aura_buff" end

function modifier_creature_attack_speed_aura:GetEffectName()
	return "particles/creature/attack_speed_aura.vpcf"
end

function modifier_creature_attack_speed_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_attack_speed_aura_buff = class({})

function modifier_creature_attack_speed_aura_buff:IsHidden() return false end
function modifier_creature_attack_speed_aura_buff:IsDebuff() return false end
function modifier_creature_attack_speed_aura_buff:IsPurgable() return false end

function modifier_creature_attack_speed_aura_buff:OnCreated()
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_creature_attack_speed_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creature_attack_speed_aura_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end
