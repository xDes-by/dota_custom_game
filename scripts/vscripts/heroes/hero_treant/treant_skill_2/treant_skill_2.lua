treant_skill_2 = treant_skill_2 or class({})

function treant_skill_2:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function treant_skill_2:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end

function treant_skill_2:GetCooldown(level)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str_last") 
		if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - 15
	 else
		return self.BaseClass.GetCooldown(self, level)
	 end
end

function treant_skill_2:GetBehavior()
	-- local abil = self:GetCaster():FindAbilityByName("special_bonus_base_npc_dota_hero_treant_str50") 
	-- if abil ~= nil then
	-- 	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
	-- else
	-- 	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	-- end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function treant_skill_2:GetIntrinsicModifierName()
	return "modifier_treant_skill_2"
end

function treant_skill_2:OnSpellStart()
	local target_point = self:GetCursorPosition()
	local caster = self:GetCaster()
	if target then
		local modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_treant_skill_2", {duration = 60})
		modifier:SetStackCount(caster:GetModifierStackCount("modifier_treant_skill_2", self) / 2)
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int9")	
	if abil ~= nil then 
		if RandomInt(1,100) < 10 then
			self:EndCooldown()
		end
	end
	local radius = self:GetSpecialValueFor( "radius" )

	a = GridNav:GetAllTreesAroundPoint(target_point, radius, true)

	local currentStacks_hp = caster:GetModifierStackCount("modifier_treant_skill_2", self)	
	caster:SetModifierStackCount("modifier_treant_skill_2", caster, currentStacks_hp + #a)
	
	-- GridNav:DestroyTreesAroundPoint(target_point, 1, false)
	GridNav:DestroyTreesAroundPoint( target_point, 300, true )

	caster:EmitSound("Tiny.Grow")
end

-----------------------------------------------------------------------------

LinkLuaModifier("modifier_treant_skill_2", "heroes/hero_treant/treant_skill_2/treant_skill_2", LUA_MODIFIER_MOTION_NONE)

modifier_treant_skill_2 = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
} end,
})

function modifier_treant_skill_2:OnAbilityExecuted(params)
	if params.unit == self:GetParent() then
	Timers:CreateTimer(0.5, function()
		local parent = self:GetParent()
			parent:CalculateStatBonus(true)
		end)
	end
end

function modifier_treant_skill_2:GetModifierExtraHealthBonus(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str8")	
	if abil ~= nil then 
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("hp") * 2
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("hp")
end

function modifier_treant_skill_2:GetModifierBaseAttack_BonusDamage(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_agi6")	
	if abil ~= nil then 
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage") * 2
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_treant_skill_2:GetModifierPhysicalArmorBonusUnique(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str9")	
	if abil ~= nil then 
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("arm") * 2
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("arm")
end

function modifier_treant_skill_2:GetModifierPreAttack_CriticalStrike()
	if self:GetCaster():FindAbilityByName("special_bonus_base_npc_dota_hero_treant_agi50") then
		if RollPercentage(10) then
			return 100 + self:GetStackCount() * 0.5
		end
	end
end