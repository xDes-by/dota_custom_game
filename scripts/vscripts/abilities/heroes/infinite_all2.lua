LinkLuaModifier("modifier_modifier_infinite_all2_collector", "abilities/heroes/infinite_all2", LUA_MODIFIER_MOTION_NONE)

modifier_modifier_infinite_all2_collector = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	} end,
})

function modifier_modifier_infinite_all2_collector:GetModifierBonusStats_Strength()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus")
end

function modifier_modifier_infinite_all2_collector:GetModifierBonusStats_Agility()
return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus")
end

function modifier_modifier_infinite_all2_collector:GetModifierBonusStats_Intellect()
return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus")
end

function StackCountIncrease( keys )
	caster = keys.caster
	ability = keys.ability
	local killed_unit = keys.unit
	local zombie1 = "npc_dota_unit_undying_zombie"
	local zombie2 = "npc_dota_unit_undying_zombie_torso"

	if killed_unit:IsRealHero() then return 
   	elseif killed_unit:GetUnitName() == zombie1  then return 
	elseif killed_unit:GetUnitName() == zombie2  then return 
	else
	stackone()
end
end



function StackCountIncrease2( keys )
	caster = keys.caster
	ability = keys.ability
	local killed_unit = keys.unit
	local zombie1 = "npc_dota_unit_undying_zombie"
	local zombie2 = "npc_dota_unit_undying_zombie_torso"

	if killed_unit:IsRealHero() then return 
   	elseif killed_unit:GetUnitName() == zombie1  then return 
	elseif killed_unit:GetUnitName() == zombie2  then return 
	else
	stackone()
end
end


function stackone()
    local fleshHeapStackModifier = "modifier_modifier_infinite_all2_collector"
	local hero = Entities:FindByName( nil, "npc_dota_hero_treant")
	local currentStacks = hero:GetModifierStackCount(fleshHeapStackModifier, ability)
	--print(currentStacks)
	local modifier = hero:AddNewModifier(hero, ability, fleshHeapStackModifier, nil)
    hero:SetModifierStackCount(fleshHeapStackModifier, hero, (currentStacks + 1))
end