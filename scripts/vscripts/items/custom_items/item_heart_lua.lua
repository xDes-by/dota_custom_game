item_heart_lua = class({})

LinkLuaModifier("modifier_item_heart_lua", 'items/custom_items/item_heart_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_heart_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if not self.GemType then
		return "all/heart_" .. level
	else
		return "gem" .. self.GemType .. "/item_heart_lua" .. level
	end
end

function item_heart_lua:GetIntrinsicModifierName()
	return "modifier_item_heart_lua"
end

modifier_item_heart_lua = class({})

function modifier_item_heart_lua:IsHidden()
	return true
end

function modifier_item_heart_lua:IsPurgable()
	return false
end

function modifier_item_heart_lua:DestroyOnExpire()
	return false
end

function modifier_item_heart_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_heart_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
	self.hp_regen_amp = self:GetAbility():GetSpecialValueFor("hp_regen_amp")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_heart_lua:OnRefresh()
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
	self.hp_regen_amp = self:GetAbility():GetSpecialValueFor("hp_regen_amp")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_item_heart_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end

function modifier_item_heart_lua:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_heart_lua:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end

function modifier_item_heart_lua:GetModifierHPRegenAmplify_Percentage()
	return self.hp_regen_amp
end

function modifier_item_heart_lua:GetModifierHealthBonus()
	return self.bonus_health
end