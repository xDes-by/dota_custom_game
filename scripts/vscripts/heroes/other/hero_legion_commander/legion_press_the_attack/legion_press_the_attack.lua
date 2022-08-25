LinkLuaModifier("modifier_legion_press", "heroes/hero_legion_commander/legion_press_the_attack/legion_press_the_attack.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------
------------------------------------------------------------
modifier_legion_press = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,} end,
})

function modifier_legion_press:GetModifierConstantHealthRegen()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_hp")
end

function modifier_legion_press:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_speed")
end

function StackCountIncrease( keys )
	 caster = keys.caster
	 ability = keys.ability
	 local count = 1
	 
	local abil = caster:FindAbilityByName("special_bonus_unique_lega_custom2")
	if abil ~= nil and abil:IsTrained()	then 
	bonus = abil:GetSpecialValueFor( "value" )
	count = count * bonus
	end
	 
	radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	
	local fleshHeapStackModifier = "modifier_legion_press"
--	local currentStacks = caster:GetModifierStackCount(fleshHeapStackModifier, ability)
	local modifier = caster:AddNewModifier(caster, ability, fleshHeapStackModifier, nil)
	caster:SetModifierStackCount(fleshHeapStackModifier, caster, #hEnemies * count)
end
