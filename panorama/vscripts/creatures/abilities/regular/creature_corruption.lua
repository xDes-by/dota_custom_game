LinkLuaModifier("modifier_creature_corruption", "creatures/abilities/regular/creature_corruption", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_corruption_debuff", "creatures/abilities/regular/creature_corruption", LUA_MODIFIER_MOTION_NONE)

creature_corruption = class({})

function creature_corruption:GetIntrinsicModifierName()
	return "modifier_creature_corruption"
end



modifier_creature_corruption = class({})

function modifier_creature_corruption:IsHidden() return true end
function modifier_creature_corruption:IsDebuff() return false end
function modifier_creature_corruption:IsPurgable() return false end
function modifier_creature_corruption:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_corruption:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
	}
	return funcs
end

-- declare only on server
if IsServer() then

	function modifier_creature_corruption:GetModifierProcAttack_Feedback(keys)
		local ability = self:GetAbility()
		keys.target:AddNewModifier(keys.attacker, ability, "modifier_creature_corruption_debuff", {duration = ability:GetSpecialValueFor("duration") * (1 - keys.target:GetStatusResistance()) })

		local modifier = keys.target:FindModifierByName("modifier_creature_corruption_debuff")
		if modifier and modifier:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
			modifier:IncrementStackCount()
		end
	end

end

modifier_creature_corruption_debuff = class({})

function modifier_creature_corruption_debuff:IsHidden() return false end
function modifier_creature_corruption_debuff:IsDebuff() return true end
function modifier_creature_corruption_debuff:IsPurgable() return false end

function modifier_creature_corruption_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_creature_corruption_debuff:GetModifierPhysicalArmorBonus()
	return (-1) * self:GetStackCount()
end
