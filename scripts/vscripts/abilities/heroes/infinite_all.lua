LinkLuaModifier("modifier_modifier_infinite_all_collector", "abilities/heroes/infinite_all", LUA_MODIFIER_MOTION_NONE)

modifier_modifier_infinite_all_collector = class({
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

function modifier_modifier_infinite_all_collector:GetModifierBonusStats_Strength()
local hero = Entities:FindByName( nil, "npc_dota_hero_tinker")
local abil = hero:FindAbilityByName("infinite_all")
local bonus = abil:GetSpecialValueFor("bonus")
	return self:GetStackCount()*bonus
end

function modifier_modifier_infinite_all_collector:GetModifierBonusStats_Agility()
local hero = Entities:FindByName( nil, "npc_dota_hero_tinker")
local abil = hero:FindAbilityByName("infinite_all")
local bonus = abil:GetSpecialValueFor("bonus")
	return self:GetStackCount()*bonus
end

function modifier_modifier_infinite_all_collector:GetModifierBonusStats_Intellect()
local hero = Entities:FindByName( nil, "npc_dota_hero_tinker")
local abil = hero:FindAbilityByName("infinite_all")
local bonus = abil:GetSpecialValueFor("bonus")
	return self:GetStackCount()*bonus
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
    local fleshHeapStackModifier = "modifier_modifier_infinite_all_collector"
	local hero = Entities:FindByName( nil, "npc_dota_hero_tinker")
	local currentStacks = hero:GetModifierStackCount(fleshHeapStackModifier, ability)
	--print(currentStacks)
	local modifier = hero:AddNewModifier(hero, ability, fleshHeapStackModifier, nil)
    hero:SetModifierStackCount(fleshHeapStackModifier, hero, (currentStacks + 1))
end