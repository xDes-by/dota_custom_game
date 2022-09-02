treant_skill_2 = treant_skill_2 or class({})

function treant_skill_2:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect())
    end
end

function treant_skill_2:GetCooldown(level)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str_last") 
		if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - 15
	 else
		return self.BaseClass.GetCooldown(self, level)
	 end
end

function treant_skill_2:GetIntrinsicModifierName()
	return "modifier_treant_skill_2"
end

function treant_skill_2:OnSpellStart()
if IsServer() then 
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int9")	
	if abil ~= nil then 
		if RandomInt(1,100) < 10 then
			self:EndCooldown()
		end
	end
		
	local caster = self:GetCaster()
	local target_point = self:GetCaster():GetOrigin()
	
	a = GridNav:GetAllTreesAroundPoint(target_point, 300, true)

	local currentStacks_hp = caster:GetModifierStackCount("modifier_treant_skill_2", self)	
	caster:SetModifierStackCount("modifier_treant_skill_2", caster, currentStacks_hp + #a)
	
	-- GridNav:DestroyTreesAroundPoint(target_point, 1, false)
	GridNav:DestroyTreesAroundPoint( target_point, 300, true )

	caster:EmitSound("Tiny.Grow")
	end
end

-----------------------------------------------------------------------------

LinkLuaModifier("modifier_treant_skill_2", "heroes/hero_treant/treant_skill_2/treant_skill_2", LUA_MODIFIER_MOTION_NONE)

modifier_treant_skill_2 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED} end,
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
