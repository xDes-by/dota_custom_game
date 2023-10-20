item_skadi_lua = class({})

LinkLuaModifier("modifier_item_skadi_lua", 'items/custom_items/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_slow_lua", 'items/custom_items/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_skadi_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if not self.GemType then
		return "all/skadix_" .. level
	else
		return "gem" .. self.GemType .. "/item_skadi_lua" .. level
	end
end

function item_skadi_lua:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua"
end

modifier_item_skadi_lua = class({})

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
	self.parent = self:GetParent()
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_skadi_lua:OnRefresh()
	self.parent = self:GetParent()
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
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
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

function modifier_item_skadi_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua:GetModifierProcAttack_Feedback(data)
	data.target:AddNewModifier(attacker,	self:GetAbility(), "modifier_item_skadi_slow_lua", { duration = 3 })
end

--------------------------------------------------------------------
modifier_item_skadi_slow_lua = class({})

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