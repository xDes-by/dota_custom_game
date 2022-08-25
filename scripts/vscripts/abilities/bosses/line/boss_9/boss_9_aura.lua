LinkLuaModifier("modifier_boss_9_aura", "abilities/bosses/line/boss_9/boss_9_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_9_aura_debuff", "abilities/bosses/line/boss_9/boss_9_aura", LUA_MODIFIER_MOTION_NONE)

boss_9_aura =  class({})

function boss_9_aura:GetIntrinsicModifierName()
	return "modifier_boss_9_aura"
end

modifier_boss_9_aura = class({})

function modifier_boss_9_aura:IsAura() return true end
function modifier_boss_9_aura:IsAuraActiveOnDeath() return false end
function modifier_boss_9_aura:IsDebuff() return false end
function modifier_boss_9_aura:IsHidden() return true end
function modifier_boss_9_aura:RemoveOnDeath() return false end
function modifier_boss_9_aura:IsPurgable() return false end

function modifier_boss_9_aura:OnCreated()
	self.natural_order_radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_boss_9_aura:GetAuraRadius()
	return self.natural_order_radius
end

function modifier_boss_9_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_boss_9_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_boss_9_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_boss_9_aura:GetModifierAura()
	return "modifier_boss_9_aura_debuff"
end

function modifier_boss_9_aura:GetAuraDuration()
	return 1
end

--------------------------------------------------------------------------

modifier_boss_9_aura_debuff = class({})

function modifier_boss_9_aura_debuff:IsHidden() return false end
function modifier_boss_9_aura_debuff:IsPurgable() return false end

function modifier_boss_9_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf"
end

function modifier_boss_9_aura_debuff:OnCreated()
	self.base_armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction_pct")
	self.magic_resist_reduction = self:GetAbility():GetSpecialValueFor("magic_resistance_pct")
end

function modifier_boss_9_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_boss_9_aura_debuff:GetModifierPhysicalArmorBonus()
	return self.base_armor_reduction * 0.01 * self:GetParent():GetPhysicalArmorBaseValue()
end

function modifier_boss_9_aura_debuff:GetModifierMagicalResistanceBonus()
	return self.magic_resist_reduction * 0.01 * self:GetParent():GetBaseMagicalResistanceValue()
end