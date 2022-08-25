LinkLuaModifier("modifier_modifier_infinite_agi_collector", "abilities/heroes/infinite_agi", LUA_MODIFIER_MOTION_NONE)

modifier_modifier_infinite_agi_collector = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end,
})

function modifier_modifier_infinite_agi_collector:GetModifierBonusStats_Agility()
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function StackCountIncrease( keys )
	caster = keys.caster
	ability = keys.ability
	local killed_unit = keys.unit
	local zombie1 = "npc_dota_unit_undying_zombie"
	local zombie2 = "npc_dota_unit_undying_zombie_torso"

	if caster:IsIllusion() then return
	elseif killed_unit:IsRealHero() then return 
   	elseif killed_unit:GetUnitName() == zombie1  then return 
	elseif killed_unit:GetUnitName() == zombie2  then return 
	else
	stackone()
end
end


function stackone()
    local fleshHeapStackModifier = "modifier_modifier_infinite_agi_collector"
    local currentStacks = caster:GetModifierStackCount(fleshHeapStackModifier, ability)
	
 	local modifier = caster:AddNewModifier(caster, ability, fleshHeapStackModifier, nil)
    caster:SetModifierStackCount(fleshHeapStackModifier, caster, (currentStacks + 1))
	end

function nostack(  )
    local fleshHeapStackModifier = "modifier_modifier_infinite_agi_collector"
    local currentStacks = caster:GetModifierStackCount(fleshHeapStackModifier, ability)
 	local modifier = caster:AddNewModifier(caster, ability, fleshHeapStackModifier, nil)
    caster:SetModifierStackCount(fleshHeapStackModifier, caster, (currentStacks + 0))
end