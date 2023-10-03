item_butterfly_lua = class({})

LinkLuaModifier("modifier_item_butterfly_lua", 'items/custom_items/item_butterfly_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_butterfly_lua:GetIntrinsicModifierName()
	return "modifier_item_butterfly_lua"
end

----------------------------------------------------------------------------------

modifier_item_butterfly_lua = class({})

function modifier_item_butterfly_lua:IsHidden()
	return true
end

function modifier_item_butterfly_lua:IsPurgable()
	return false
end

function modifier_item_butterfly_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_butterfly_lua:OnCreated()
	self.parent = self:GetParent()
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_butterfly_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_butterfly_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_butterfly_lua:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_butterfly_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_butterfly_lua:GetModifierEvasion_Constant()
	return self.bonus_evasion
end

function modifier_item_butterfly_lua:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end