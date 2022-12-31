LinkLuaModifier("modifier_creature_frenzy", "creatures/abilities/regular/creature_frenzy", LUA_MODIFIER_MOTION_NONE)

creature_frenzy = class({})

function creature_frenzy:GetIntrinsicModifierName()
	return "modifier_creature_frenzy"
end

function creature_frenzy:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_creature_frenzy")
		if modifier then
			caster:EmitSound("CreatureFrenzy.Cast")
			modifier:IncrementStackCount()
		end
	end
end



modifier_creature_frenzy = class({})

function modifier_creature_frenzy:IsHidden() return false end
function modifier_creature_frenzy:IsDebuff() return false end
function modifier_creature_frenzy:IsPurgable() return false end
function modifier_creature_frenzy:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_frenzy:GetEffectName()
	return "particles/creature/frenzy_2.vpcf"
end

function modifier_creature_frenzy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_frenzy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_creature_frenzy:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") * self:GetStackCount()
end
