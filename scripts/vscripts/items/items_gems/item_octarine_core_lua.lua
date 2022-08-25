item_octarine_core_lua1_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua2_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua3_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua4_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua5_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua6_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua7_gem1 = item_octarine_core_lua1_gem1 or class({})
item_octarine_core_lua8_gem1 = item_octarine_core_lua1_gem1 or class({})

item_octarine_core_lua1_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua2_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua3_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua4_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua5_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua6_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua7_gem2 = item_octarine_core_lua1_gem2 or class({})
item_octarine_core_lua8_gem2 = item_octarine_core_lua1_gem2 or class({})

item_octarine_core_lua1_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua2_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua3_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua4_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua5_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua6_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua7_gem3 = item_octarine_core_lua1_gem3 or class({})
item_octarine_core_lua8_gem3 = item_octarine_core_lua1_gem3 or class({})

item_octarine_core_lua1_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua2_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua3_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua4_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua5_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua6_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua7_gem4 = item_octarine_core_lua1_gem4 or class({})
item_octarine_core_lua8_gem4 = item_octarine_core_lua1_gem4 or class({})

item_octarine_core_lua1_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua2_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua3_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua4_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua5_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua6_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua7_gem5 = item_octarine_core_lua1_gem5 or class({})
item_octarine_core_lua8_gem5 = item_octarine_core_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_octarine_core_lua1", 'items/items_gems/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_octarine_core_lua2", 'items/items_gems/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_octarine_core_lua3", 'items/items_gems/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_octarine_core_lua4", 'items/items_gems/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_octarine_core_lua5", 'items/items_gems/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_octarine_core_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua1"
end
function item_octarine_core_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua2"
end
function item_octarine_core_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua3"
end
function item_octarine_core_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua4"
end
function item_octarine_core_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua5"
end

modifier_item_octarine_core_lua1 = class({})

function modifier_item_octarine_core_lua1:IsHidden()
	return true
end

function modifier_item_octarine_core_lua1:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua1:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua1:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
	
	if not IsServer() then return end
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
			if modifier:GetName() == "modifier_item_octarine_core_lua" or
			modifier:GetName() == "modifier_item_octarine_core_lua2" or
			modifier:GetName() == "modifier_item_octarine_core_lua3" or
			modifier:GetName() == "modifier_item_octarine_core_lua4" or
			modifier:GetName() == "modifier_item_octarine_core_lua5" then
			self:GetParent():RemoveModifierByName(modifier:GetName())
		end
	end
end

function modifier_item_octarine_core_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_octarine_core_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua1:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua1:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua1:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua1:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua1:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end
------------------------------------------------------------------------------------------------------------------------------
modifier_item_octarine_core_lua2 = class({})

function modifier_item_octarine_core_lua2:IsHidden()
	return true
end

function modifier_item_octarine_core_lua2:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua2:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua2:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
	
		if not IsServer() then return end
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
			if modifier:GetName() == "modifier_item_octarine_core_lua" or
			modifier:GetName() == "modifier_item_octarine_core_lua1" or
			modifier:GetName() == "modifier_item_octarine_core_lua3" or
			modifier:GetName() == "modifier_item_octarine_core_lua4" or
			modifier:GetName() == "modifier_item_octarine_core_lua5" then
			self:GetParent():RemoveModifierByName(modifier:GetName())
		end
	end
end
function modifier_item_octarine_core_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_octarine_core_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua2:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua2:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua2:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua2:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua2:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end


modifier_item_octarine_core_lua3 = class({})

function modifier_item_octarine_core_lua3:IsHidden()
	return true
end

function modifier_item_octarine_core_lua3:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua3:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua3:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
	
		if not IsServer() then return end
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
			if modifier:GetName() == "modifier_item_octarine_core_lua" or
			modifier:GetName() == "modifier_item_octarine_core_lua2" or
			modifier:GetName() == "modifier_item_octarine_core_lua1" or
			modifier:GetName() == "modifier_item_octarine_core_lua4" or
			modifier:GetName() == "modifier_item_octarine_core_lua5" then
			self:GetParent():RemoveModifierByName(modifier:GetName())
		end
	end
end
function modifier_item_octarine_core_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_octarine_core_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua3:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua3:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua3:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua3:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua3:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end


modifier_item_octarine_core_lua4 = class({})

function modifier_item_octarine_core_lua4:IsHidden()
	return true
end

function modifier_item_octarine_core_lua4:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua4:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua4:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
		if not IsServer() then return end
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
			if modifier:GetName() == "modifier_item_octarine_core_lua" or
			modifier:GetName() == "modifier_item_octarine_core_lua2" or
			modifier:GetName() == "modifier_item_octarine_core_lua3" or
			modifier:GetName() == "modifier_item_octarine_core_lua1" or
			modifier:GetName() == "modifier_item_octarine_core_lua5" then
			self:GetParent():RemoveModifierByName(modifier:GetName())
		end
	end
end
function modifier_item_octarine_core_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_octarine_core_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua4:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua4:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua4:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua4:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua4:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end


modifier_item_octarine_core_lua5 = class({})

function modifier_item_octarine_core_lua5:IsHidden()
	return true
end

function modifier_item_octarine_core_lua5:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua5:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua5:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
		if not IsServer() then return end
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
			if modifier:GetName() == "modifier_item_octarine_core_lua" or
			modifier:GetName() == "modifier_item_octarine_core_lua2" or
			modifier:GetName() == "modifier_item_octarine_core_lua3" or
			modifier:GetName() == "modifier_item_octarine_core_lua4" or
			modifier:GetName() == "modifier_item_octarine_core_lua1" then
			self:GetParent():RemoveModifierByName(modifier:GetName())
		end
	end
end
function modifier_item_octarine_core_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_octarine_core_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua5:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua5:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua5:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua5:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua5:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end
