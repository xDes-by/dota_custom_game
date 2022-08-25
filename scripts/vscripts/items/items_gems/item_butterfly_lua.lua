item_butterfly_lua1_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua2_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua3_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua4_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua5_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua6_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua7_gem1 = item_butterfly_lua1_gem1 or class({})
item_butterfly_lua8_gem1 = item_butterfly_lua1_gem1 or class({})

item_butterfly_lua1_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua2_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua3_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua4_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua5_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua6_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua7_gem2 = item_butterfly_lua1_gem2 or class({})
item_butterfly_lua8_gem2 = item_butterfly_lua1_gem2 or class({})

item_butterfly_lua1_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua2_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua3_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua4_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua5_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua6_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua7_gem3 = item_butterfly_lua1_gem3 or class({})
item_butterfly_lua8_gem3 = item_butterfly_lua1_gem3 or class({})

item_butterfly_lua1_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua2_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua3_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua4_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua5_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua6_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua7_gem4 = item_butterfly_lua1_gem4 or class({})
item_butterfly_lua8_gem4 = item_butterfly_lua1_gem4 or class({})

item_butterfly_lua1_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua2_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua3_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua4_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua5_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua6_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua7_gem5 = item_butterfly_lua1_gem5 or class({})
item_butterfly_lua8_gem5 = item_butterfly_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_butterfly_lua1", 'items/items_gems/item_butterfly_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_lua2", 'items/items_gems/item_butterfly_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_lua3", 'items/items_gems/item_butterfly_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_lua4", 'items/items_gems/item_butterfly_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_lua5", 'items/items_gems/item_butterfly_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_butterfly_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua1"
end

function item_butterfly_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua2"
end

function item_butterfly_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua3"
end

function item_butterfly_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua4"
end

function item_butterfly_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua5"
end
----------------------------------------------------------------------------------

modifier_item_butterfly_lua1 = class({})

function modifier_item_butterfly_lua1:IsHidden()
	return true
end

function modifier_item_butterfly_lua1:IsPurgable()
	return false
end

function modifier_item_butterfly_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_butterfly_lua1:OnCreated()
	
	

	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_butterfly_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_butterfly_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_butterfly_lua1:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_butterfly_lua1:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_butterfly_lua1:GetModifierEvasion_Constant()
	return self.bonus_evasion
end

function modifier_item_butterfly_lua1:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
----------------------------------------------------------------------------------

modifier_item_butterfly_lua2 = class({})

function modifier_item_butterfly_lua2:IsHidden()
	return true
end

function modifier_item_butterfly_lua2:IsPurgable()
	return false
end

function modifier_item_butterfly_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_butterfly_lua2:OnCreated()
	
	

	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_butterfly_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_butterfly_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_butterfly_lua2:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_butterfly_lua2:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_butterfly_lua2:GetModifierEvasion_Constant()
	return self.bonus_evasion
end

function modifier_item_butterfly_lua2:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
----------------------------------------------------------------------------------

modifier_item_butterfly_lua3 = class({})

function modifier_item_butterfly_lua3:IsHidden()
	return true
end

function modifier_item_butterfly_lua3:IsPurgable()
	return false
end

function modifier_item_butterfly_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_butterfly_lua3:OnCreated()
	
	

	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_butterfly_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_butterfly_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_butterfly_lua3:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_butterfly_lua3:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_butterfly_lua3:GetModifierEvasion_Constant()
	return self.bonus_evasion
end

function modifier_item_butterfly_lua3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
----------------------------------------------------------------------------------

modifier_item_butterfly_lua4 = class({})

function modifier_item_butterfly_lua4:IsHidden()
	return true
end

function modifier_item_butterfly_lua4:IsPurgable()
	return false
end

function modifier_item_butterfly_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_butterfly_lua4:OnCreated()
	
	

	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_butterfly_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_butterfly_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_butterfly_lua4:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_butterfly_lua4:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_butterfly_lua4:GetModifierEvasion_Constant()
	return self.bonus_evasion
end

function modifier_item_butterfly_lua4:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
----------------------------------------------------------------------------------

modifier_item_butterfly_lua5 = class({})

function modifier_item_butterfly_lua5:IsHidden()
	return true
end

function modifier_item_butterfly_lua5:IsPurgable()
	return false
end

function modifier_item_butterfly_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_butterfly_lua5:OnCreated()
	
	

	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_butterfly_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_butterfly_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_butterfly_lua5:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_butterfly_lua5:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_butterfly_lua5:GetModifierEvasion_Constant()
	return self.bonus_evasion
end

function modifier_item_butterfly_lua5:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end