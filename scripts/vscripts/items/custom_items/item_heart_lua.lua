item_heart_lua = class({})

item_heart_lua1 = item_heart_lua
item_heart_lua2 = item_heart_lua
item_heart_lua3 = item_heart_lua
item_heart_lua4 = item_heart_lua
item_heart_lua5 = item_heart_lua
item_heart_lua6 = item_heart_lua
item_heart_lua7 = item_heart_lua
item_heart_lua8 = item_heart_lua

item_heart_lua1_gem1 = item_heart_lua
item_heart_lua2_gem1 = item_heart_lua
item_heart_lua3_gem1 = item_heart_lua
item_heart_lua4_gem1 = item_heart_lua
item_heart_lua5_gem1 = item_heart_lua
item_heart_lua6_gem1 = item_heart_lua
item_heart_lua7_gem1 = item_heart_lua
item_heart_lua8_gem1 = item_heart_lua

item_heart_lua1_gem2 = item_heart_lua
item_heart_lua2_gem2 = item_heart_lua
item_heart_lua3_gem2 = item_heart_lua
item_heart_lua4_gem2 = item_heart_lua
item_heart_lua5_gem2 = item_heart_lua
item_heart_lua6_gem2 = item_heart_lua
item_heart_lua7_gem2 = item_heart_lua
item_heart_lua8_gem2 = item_heart_lua

item_heart_lua1_gem3 = item_heart_lua
item_heart_lua2_gem3 = item_heart_lua
item_heart_lua3_gem3 = item_heart_lua
item_heart_lua4_gem3 = item_heart_lua
item_heart_lua5_gem3 = item_heart_lua
item_heart_lua6_gem3 = item_heart_lua
item_heart_lua7_gem3 = item_heart_lua
item_heart_lua8_gem3 = item_heart_lua

item_heart_lua1_gem4 = item_heart_lua
item_heart_lua2_gem4 = item_heart_lua
item_heart_lua3_gem4 = item_heart_lua
item_heart_lua4_gem4 = item_heart_lua
item_heart_lua5_gem4 = item_heart_lua
item_heart_lua6_gem4 = item_heart_lua
item_heart_lua7_gem4 = item_heart_lua
item_heart_lua8_gem4 = item_heart_lua

item_heart_lua1_gem5 = item_heart_lua
item_heart_lua2_gem5 = item_heart_lua
item_heart_lua3_gem5 = item_heart_lua
item_heart_lua4_gem5 = item_heart_lua
item_heart_lua5_gem5 = item_heart_lua
item_heart_lua6_gem5 = item_heart_lua
item_heart_lua7_gem5 = item_heart_lua
item_heart_lua8_gem5 = item_heart_lua


LinkLuaModifier("modifier_item_heart_lua", 'items/custom_items/item_heart_lua.lua', LUA_MODIFIER_MOTION_NONE)

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
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_heart_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
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