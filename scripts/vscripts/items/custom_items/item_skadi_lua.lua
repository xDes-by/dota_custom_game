item_skadi_lua = class({})

item_skadi_lua1 = item_skadi_lua
item_skadi_lua2 = item_skadi_lua
item_skadi_lua3 = item_skadi_lua
item_skadi_lua4 = item_skadi_lua
item_skadi_lua5 = item_skadi_lua
item_skadi_lua6 = item_skadi_lua
item_skadi_lua7 = item_skadi_lua
item_skadi_lua8 = item_skadi_lua

item_skadi_lua1_gem1 = item_skadi_lua
item_skadi_lua2_gem1 = item_skadi_lua
item_skadi_lua3_gem1 = item_skadi_lua
item_skadi_lua4_gem1 = item_skadi_lua
item_skadi_lua5_gem1 = item_skadi_lua
item_skadi_lua6_gem1 = item_skadi_lua
item_skadi_lua7_gem1 = item_skadi_lua
item_skadi_lua8_gem1 = item_skadi_lua

item_skadi_lua1_gem2 = item_skadi_lua
item_skadi_lua2_gem2 = item_skadi_lua
item_skadi_lua3_gem2 = item_skadi_lua
item_skadi_lua4_gem2 = item_skadi_lua
item_skadi_lua5_gem2 = item_skadi_lua
item_skadi_lua6_gem2 = item_skadi_lua
item_skadi_lua7_gem2 = item_skadi_lua
item_skadi_lua8_gem2 = item_skadi_lua

item_skadi_lua1_gem3 = item_skadi_lua
item_skadi_lua2_gem3 = item_skadi_lua
item_skadi_lua3_gem3 = item_skadi_lua
item_skadi_lua4_gem3 = item_skadi_lua
item_skadi_lua5_gem3 = item_skadi_lua
item_skadi_lua6_gem3 = item_skadi_lua
item_skadi_lua7_gem3 = item_skadi_lua
item_skadi_lua8_gem3 = item_skadi_lua

item_skadi_lua1_gem4 = item_skadi_lua
item_skadi_lua2_gem4 = item_skadi_lua
item_skadi_lua3_gem4 = item_skadi_lua
item_skadi_lua4_gem4 = item_skadi_lua
item_skadi_lua5_gem4 = item_skadi_lua
item_skadi_lua6_gem4 = item_skadi_lua
item_skadi_lua7_gem4 = item_skadi_lua
item_skadi_lua8_gem4 = item_skadi_lua

item_skadi_lua1_gem5 = item_skadi_lua
item_skadi_lua2_gem5 = item_skadi_lua
item_skadi_lua3_gem5 = item_skadi_lua
item_skadi_lua4_gem5 = item_skadi_lua
item_skadi_lua5_gem5 = item_skadi_lua
item_skadi_lua6_gem5 = item_skadi_lua
item_skadi_lua7_gem5 = item_skadi_lua
item_skadi_lua8_gem5 = item_skadi_lua

LinkLuaModifier("modifier_item_skadi_lua", 'items/custom_items/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_slow_lua", 'items/custom_items/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_skadi_lua = class({})

function item_skadi_lua:GetIntrinsicModifierName()
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
	self.parent = self:GetParent()
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value})
	end
end

function modifier_item_skadi_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value * -1})
	end
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