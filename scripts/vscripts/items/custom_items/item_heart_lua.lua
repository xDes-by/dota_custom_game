item_heart_lua1 = item_heart_lua1 or class({})
item_heart_lua2 = item_heart_lua1 or class({})
item_heart_lua3 = item_heart_lua1 or class({})
item_heart_lua4 = item_heart_lua1 or class({})
item_heart_lua5 = item_heart_lua1 or class({})
item_heart_lua6 = item_heart_lua1 or class({})
item_heart_lua7 = item_heart_lua1 or class({})
item_heart_lua8 = item_heart_lua1 or class({})


LinkLuaModifier("modifier_item_heart_lua", 'items/custom_items/item_heart_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_item_heart_lua = class({})

function item_heart_lua1:GetIntrinsicModifierName()
	return "modifier_item_heart_lua"
end

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
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
	self.hp_regen_amp = self:GetAbility():GetSpecialValueFor("hp_regen_amp")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	if IsServer() then
		for _,modifier in pairs( self:GetParent():FindAllModifiers() ) do
		if modifier:GetName() == "modifier_item_heart_lua1" or
		modifier:GetName() == "modifier_item_heart_lua2" or
		modifier:GetName() == "modifier_item_heart_lua3" or
		modifier:GetName() == "modifier_item_heart_lua4" or
		modifier:GetName() == "modifier_item_heart_lua5" then
		self:GetParent():RemoveModifierByName(modifier:GetName())
		end
		end
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