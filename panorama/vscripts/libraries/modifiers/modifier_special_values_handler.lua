modifier_special_values_handler = class({})

function modifier_special_values_handler:IsHidden() return true end
function modifier_special_values_handler:IsPermanent() return true end
function modifier_special_values_handler:IsPurgable() return false end

function modifier_special_values_handler:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
end

function modifier_special_values_handler:GetModifierOverrideAbilitySpecial(params)
	local parent = self:GetParent()
	local modifiers = parent.special_values_modifiers

	if not modifiers then return end

	for i = #modifiers, 1, -1 do
		local modifier = modifiers[i]
		
		if modifier:IsNull() then
			table.remove(modifiers, i)
		elseif modifier.GetAbilitySpecialValueMultiplier then
			local mult = modifier:GetAbilitySpecialValueMultiplier(params)

			if mult ~= nil and mult > 0 then
				return 1
			end
		end
	end

	if #modifiers == 0 then
		self:Destroy()
	end
end

function modifier_special_values_handler:GetModifierOverrideAbilitySpecialValue(params)
	local parent = self:GetParent()
	local modifiers = parent.special_values_modifiers
	local mult = 1

	if not modifiers then return end

	for _, modifier in pairs(modifiers) do
		mult = mult + modifier:GetAbilitySpecialValueMultiplier(params)
	end

	if mult > 1 then
		local value = params.ability:GetLevelSpecialValueNoOverride(params.ability_special_value, params.ability_special_level)
		return value * mult
	end
end
