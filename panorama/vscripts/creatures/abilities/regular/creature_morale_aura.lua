LinkLuaModifier("modifier_creature_morale_aura", "creatures/abilities/regular/creature_morale_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_morale_aura_buff", "creatures/abilities/regular/creature_morale_aura", LUA_MODIFIER_MOTION_NONE)

creature_morale_aura = class({})

function creature_morale_aura:GetIntrinsicModifierName()
	return "modifier_creature_morale_aura"
end



modifier_creature_morale_aura = class({})

function modifier_creature_morale_aura:IsHidden() return true end
function modifier_creature_morale_aura:IsDebuff() return false end
function modifier_creature_morale_aura:IsPurgable() return false end
function modifier_creature_morale_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_morale_aura:IsAura() return true end
function modifier_creature_morale_aura:GetAuraRadius() return 900 end
function modifier_creature_morale_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_morale_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_morale_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_morale_aura:GetModifierAura() return "modifier_creature_morale_aura_buff" end



modifier_creature_morale_aura_buff = class({})

function modifier_creature_morale_aura_buff:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	
	self.bonus_mr = ability:GetSpecialValueFor("bonus_mr")
end

function modifier_creature_morale_aura_buff:IsHidden() return false end
function modifier_creature_morale_aura_buff:IsDebuff() return false end
function modifier_creature_morale_aura_buff:IsPurgable() return false end

function modifier_creature_morale_aura_buff:GetEffectName()
	return "particles/creature/morale_aura.vpcf"
end

function modifier_creature_morale_aura_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_creature_morale_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_creature_morale_aura_buff:GetModifierMagicalResistanceBonus()
	return self.bonus_mr
end
