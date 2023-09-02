item_greater_crit_lua = class({})

item_greater_crit_lua1 = item_greater_crit_lua
item_greater_crit_lua2 = item_greater_crit_lua
item_greater_crit_lua3 = item_greater_crit_lua
item_greater_crit_lua4 = item_greater_crit_lua
item_greater_crit_lua5 = item_greater_crit_lua
item_greater_crit_lua6 = item_greater_crit_lua
item_greater_crit_lua7 = item_greater_crit_lua
item_greater_crit_lua8 = item_greater_crit_lua

item_greater_crit_lua1_gem1 = item_greater_crit_lua
item_greater_crit_lua2_gem1 = item_greater_crit_lua
item_greater_crit_lua3_gem1 = item_greater_crit_lua
item_greater_crit_lua4_gem1 = item_greater_crit_lua
item_greater_crit_lua5_gem1 = item_greater_crit_lua
item_greater_crit_lua6_gem1 = item_greater_crit_lua
item_greater_crit_lua7_gem1 = item_greater_crit_lua
item_greater_crit_lua8_gem1 = item_greater_crit_lua

item_greater_crit_lua1_gem2 = item_greater_crit_lua
item_greater_crit_lua2_gem2 = item_greater_crit_lua
item_greater_crit_lua3_gem2 = item_greater_crit_lua
item_greater_crit_lua4_gem2 = item_greater_crit_lua
item_greater_crit_lua5_gem2 = item_greater_crit_lua
item_greater_crit_lua6_gem2 = item_greater_crit_lua
item_greater_crit_lua7_gem2 = item_greater_crit_lua
item_greater_crit_lua8_gem2 = item_greater_crit_lua

item_greater_crit_lua1_gem3 = item_greater_crit_lua
item_greater_crit_lua2_gem3 = item_greater_crit_lua
item_greater_crit_lua3_gem3 = item_greater_crit_lua
item_greater_crit_lua4_gem3 = item_greater_crit_lua
item_greater_crit_lua5_gem3 = item_greater_crit_lua
item_greater_crit_lua6_gem3 = item_greater_crit_lua
item_greater_crit_lua7_gem3 = item_greater_crit_lua
item_greater_crit_lua8_gem3 = item_greater_crit_lua

item_greater_crit_lua1_gem4 = item_greater_crit_lua
item_greater_crit_lua2_gem4 = item_greater_crit_lua
item_greater_crit_lua3_gem4 = item_greater_crit_lua
item_greater_crit_lua4_gem4 = item_greater_crit_lua
item_greater_crit_lua5_gem4 = item_greater_crit_lua
item_greater_crit_lua6_gem4 = item_greater_crit_lua
item_greater_crit_lua7_gem4 = item_greater_crit_lua
item_greater_crit_lua8_gem4 = item_greater_crit_lua

item_greater_crit_lua1_gem5 = item_greater_crit_lua
item_greater_crit_lua2_gem5 = item_greater_crit_lua
item_greater_crit_lua3_gem5 = item_greater_crit_lua
item_greater_crit_lua4_gem5 = item_greater_crit_lua
item_greater_crit_lua5_gem5 = item_greater_crit_lua
item_greater_crit_lua6_gem5 = item_greater_crit_lua
item_greater_crit_lua7_gem5 = item_greater_crit_lua
item_greater_crit_lua8_gem5 = item_greater_crit_lua

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
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value})
	end
end

function modifier_item_greater_crit_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value * -1})
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