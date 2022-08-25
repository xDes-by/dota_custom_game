item_octarine_core_lua1 = item_octarine_core_lua1 or class({})
item_octarine_core_lua2 = item_octarine_core_lua1 or class({})
item_octarine_core_lua3 = item_octarine_core_lua1 or class({})
item_octarine_core_lua4 = item_octarine_core_lua1 or class({})
item_octarine_core_lua5 = item_octarine_core_lua1 or class({})
item_octarine_core_lua6 = item_octarine_core_lua1 or class({})
item_octarine_core_lua7 = item_octarine_core_lua1 or class({})
item_octarine_core_lua8 = item_octarine_core_lua1 or class({})

LinkLuaModifier("modifier_item_octarine_core_lua", 'items/custom_items/item_octarine_core_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_octarine_core_lua = class({})

function item_octarine_core_lua1:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_lua"
end

function modifier_item_octarine_core_lua:IsHidden()
	return true
end

function modifier_item_octarine_core_lua:IsPurgable()
	return false
end

function modifier_item_octarine_core_lua:DestroyOnExpire()
	return false
end

function modifier_item_octarine_core_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_octarine_core_lua:OnCreated()
	
	
	
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.cast_range_bonus = self:GetAbility():GetSpecialValueFor("cast_range_bonus")
	-------------------------------------------
		if not IsServer() then return end
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
		if modifier:GetName() == "modifier_item_octarine_core_lua1" or
		modifier:GetName() == "modifier_item_octarine_core_lua2" or
		modifier:GetName() == "modifier_item_octarine_core_lua3" or
		modifier:GetName() == "modifier_item_octarine_core_lua4" or
		modifier:GetName() == "modifier_item_octarine_core_lua5" then
		self:GetParent():RemoveModifierByName(modifier:GetName())
		end
	end
end

function modifier_item_octarine_core_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_item_octarine_core_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_octarine_core_lua:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_octarine_core_lua:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_octarine_core_lua:GetModifierPercentageCooldown()
	return self.bonus_cooldown
end

function modifier_item_octarine_core_lua:GetModifierCastRangeBonus()
	return self.cast_range_bonus
end