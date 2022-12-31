LinkLuaModifier("modifier_creature_steroids", "creatures/abilities/regular/creature_steroids", LUA_MODIFIER_MOTION_NONE)

creature_steroids = class({})

function creature_steroids:GetIntrinsicModifierName()
	return "modifier_creature_steroids"
end



modifier_creature_steroids = class({})

function modifier_creature_steroids:IsHidden() return true end
function modifier_creature_steroids:IsDebuff() return false end
function modifier_creature_steroids:IsPurgable() return false end
function modifier_creature_steroids:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_steroids:GetEffectName()
	return "particles/creature/steroids.vpcf"
end

function modifier_creature_steroids:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_steroids:OnCreated()
	self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_creature_steroids:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creature_steroids:GetModifierDamageOutgoing_Percentage()
	return self.bonus_dmg
end

function modifier_creature_steroids:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end
