LinkLuaModifier("modifier_creature_decay_aura", "creatures/abilities/regular/creature_decay_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_decay_aura_debuff", "creatures/abilities/regular/creature_decay_aura", LUA_MODIFIER_MOTION_NONE)

creature_decay_aura = class({})

function creature_decay_aura:GetIntrinsicModifierName()
	return "modifier_creature_decay_aura"
end



modifier_creature_decay_aura = class({})

function modifier_creature_decay_aura:IsHidden() return true end
function modifier_creature_decay_aura:IsDebuff() return false end
function modifier_creature_decay_aura:IsPurgable() return false end
function modifier_creature_decay_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_decay_aura:IsAura() return true end
function modifier_creature_decay_aura:GetAuraRadius() return 1200 end
function modifier_creature_decay_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_decay_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_decay_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_decay_aura:GetModifierAura() return "modifier_creature_decay_aura_debuff" end

function modifier_creature_decay_aura:GetEffectName()
	return "particles/creature/decay_aura.vpcf"
end

function modifier_creature_decay_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_decay_aura_debuff = class({})

function modifier_creature_decay_aura_debuff:IsHidden() return false end
function modifier_creature_decay_aura_debuff:IsDebuff() return true end
function modifier_creature_decay_aura_debuff:IsPurgable() return false end

function modifier_creature_decay_aura_debuff:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
	self.damage_amp = self:GetAbility():GetSpecialValueFor("damage_amp")
end

function modifier_creature_decay_aura_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_creature_decay_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_creature_decay_aura_debuff:GetModifierIncomingDamage_Percentage()
	return self.damage_amp
end
