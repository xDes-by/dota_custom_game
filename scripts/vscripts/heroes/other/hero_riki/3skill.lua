--[[Jinada
	Author: Pizzalol
	Date: 1.1.2015.]]
function Jinada( keys )
	local caster = keys.caster
	local ability = keys.ability
	if ability == nil then 
	if caster:HasModifier("modifier_jinada_datadriven")
	then caster:RemoveModifierByName("modifier_jinada_datadriven")
	end
	end
	
	if ability ~= nil then
	local level = ability:GetLevel() - 1
	
	local cooldown = ability:GetCooldown(level)
	local caster = keys.caster	
	local modifierName = "modifier_jinada_datadriven"

	ability:StartCooldown(cooldown)

	caster:RemoveModifierByName(modifierName) 

	Timers:CreateTimer(cooldown+0.1, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
		end)	
end
end