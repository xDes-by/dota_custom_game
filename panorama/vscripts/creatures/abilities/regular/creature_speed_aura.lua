LinkLuaModifier("modifier_creature_speed_aura", "creatures/abilities/regular/creature_speed_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_speed_aura_buff", "creatures/abilities/regular/creature_speed_aura", LUA_MODIFIER_MOTION_NONE)

creature_speed_aura = class({})

function creature_speed_aura:GetIntrinsicModifierName()
	return "modifier_creature_speed_aura"
end



modifier_creature_speed_aura = class({})

function modifier_creature_speed_aura:IsHidden() return true end
function modifier_creature_speed_aura:IsDebuff() return false end
function modifier_creature_speed_aura:IsPurgable() return false end
function modifier_creature_speed_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_speed_aura:IsAura() return true end
function modifier_creature_speed_aura:GetAuraRadius() return 1200 end
function modifier_creature_speed_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_speed_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_speed_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_speed_aura:GetModifierAura() return "modifier_creature_speed_aura_buff" end

function modifier_creature_speed_aura:GetEffectName()
	return "particles/creature/speed_aura.vpcf"
end

function modifier_creature_speed_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_speed_aura_buff = class({})

function modifier_creature_speed_aura_buff:IsHidden() return false end
function modifier_creature_speed_aura_buff:IsDebuff() return false end
function modifier_creature_speed_aura_buff:IsPurgable() return false end

function modifier_creature_speed_aura_buff:OnCreated()
	self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_creature_speed_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
	return funcs
end

function modifier_creature_speed_aura_buff:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_creature_speed_aura_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end
