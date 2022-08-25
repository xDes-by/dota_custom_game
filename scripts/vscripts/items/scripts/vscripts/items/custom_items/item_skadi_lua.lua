item_skadi_lua1 = item_skadi_lua1 or class({})
item_skadi_lua2 = item_skadi_lua1 or class({})
item_skadi_lua3 = item_skadi_lua1 or class({})
item_skadi_lua4 = item_skadi_lua1 or class({})
item_skadi_lua5 = item_skadi_lua1 or class({})
item_skadi_lua6 = item_skadi_lua1 or class({})
item_skadi_lua7 = item_skadi_lua1 or class({})

LinkLuaModifier("modifier_item_skadi_lua", 'items/custom_items/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_slow_lua", 'items/custom_items/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_skadi_lua = class({})
modifier_item_skadi_slow_lua = class({})

function item_skadi_lua1:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua"
end

function modifier_item_skadi_lua:IsHidden()
	return true
end

function modifier_item_skadi_lua:IsPurgable()
	return false
end

function modifier_item_skadi_lua:DestroyOnExpire()
	return false
end

function modifier_item_skadi_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_skadi_lua:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

end

function modifier_item_skadi_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_skadi_lua:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua:GetModifierExtraHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua:GetModifierExtraManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua:OnAttackLanded(params)
		local attacker = self:GetParent()
		
		if attacker ~= params.attacker then
			return
		end

		if attacker:IsIllusion() then
			return
		end
		
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_skadi_slow_lua", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						attacker,
						self:GetAbility(),
						"modifier_item_skadi_slow_lua",
						{ duration = 3 }
					)
			end
	end
end

--------------------------------------------------------------------

function modifier_item_skadi_slow_lua:IsHidden()
	return false
end

function modifier_item_skadi_slow_lua:IsPurgable()
	return false
end

function modifier_item_skadi_slow_lua:OnCreated( kv )

	self.cold_slow_melee = self:GetAbility():GetSpecialValueFor("cold_slow_melee")
	self.cold_slow_melee = self:GetAbility():GetSpecialValueFor("cold_slow_melee")
	self.heal_reduction = self:GetAbility():GetSpecialValueFor("heal_reduction")
	self.cold_duration = self:GetAbility():GetSpecialValueFor("cold_duration")

end

function modifier_item_skadi_slow_lua:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_skadi_slow_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
end

function modifier_item_skadi_slow_lua:GetModifierAttackSpeedBonus_Constant()
	return self.cold_slow_melee
end

function modifier_item_skadi_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.cold_slow_melee
end

function modifier_item_skadi_slow_lua:GetModifierHPRegenAmplify_Percentage()
	return ( self.heal_reduction * (-1) )
end

function modifier_item_skadi_slow_lua:GetModifierLifestealAmplify()
	return ( self.heal_reduction * (-1) )
end