function armor( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier

	if target.fervor_target then
			if target:HasModifier(modifier) then
				local stack_count = target:GetModifierStackCount(modifier, ability)		
					target:SetModifierStackCount(modifier, ability, stack_count + 1)
			else
				ability:ApplyDataDrivenModifier(target, target, modifier, {})
				target:SetModifierStackCount(modifier, ability, 1)
			end
	else
		target.fervor_target = caster
	end
end