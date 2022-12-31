LinkLuaModifier("modifier_creature_craggy_mass", "creatures/abilities/regular/creature_craggy_mass", LUA_MODIFIER_MOTION_NONE)

creature_craggy_mass = class({})

function creature_craggy_mass:GetIntrinsicModifierName()
	return "modifier_creature_craggy_mass"
end



modifier_creature_craggy_mass = class({})

function modifier_creature_craggy_mass:IsHidden() return true end
function modifier_creature_craggy_mass:IsDebuff() return false end
function modifier_creature_craggy_mass:IsPurgable() return false end
function modifier_creature_craggy_mass:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_craggy_mass:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_creature_craggy_mass:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			self:SetStackCount(math.floor(0.05 * (100 - keys.unit:GetHealthPercent())))
		end
	end
end

function modifier_creature_craggy_mass:GetModifierPhysicalArmorBonus()
	return (4 - self:GetStackCount()) * self:GetAbility():GetSpecialValueFor("layer_armor")
end

function modifier_creature_craggy_mass:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("layer_speed")
end

function modifier_creature_craggy_mass:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("layer_speed")
end

function modifier_creature_craggy_mass:GetModifierModelScale()
	return (-12.5) * self:GetStackCount()
end
