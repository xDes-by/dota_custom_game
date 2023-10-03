item_greater_crit_lua = class({})

LinkLuaModifier("modifier_item_greater_crit_lua", 'items/custom_items/item_greater_crit_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_greater_crit_lua:GetIntrinsicModifierName()
	return "modifier_item_greater_crit_lua"
end

----------------------------------------------------------

modifier_item_greater_crit_lua = class({})

function modifier_item_greater_crit_lua:IsHidden()
	return true
end

function modifier_item_greater_crit_lua:IsPurgable()
	return false
end

function modifier_item_greater_crit_lua:RemoveOnDeath()	
	return false 
end

function modifier_item_greater_crit_lua:OnCreated()	
	self.parent = self:GetParent()
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_greater_crit_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_greater_crit_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_item_greater_crit_lua:GetModifierPreAttack_CriticalStrike(keys)
	if (keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("crit_chance"), self) then
		return self.crit_multiplier
	end
end

function modifier_item_greater_crit_lua:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function RollPseudoRandom(base_chance, entity)
	local ran = RandomInt(1,100)
		if base_chance >= ran then return true
		else
		return false
	end
end