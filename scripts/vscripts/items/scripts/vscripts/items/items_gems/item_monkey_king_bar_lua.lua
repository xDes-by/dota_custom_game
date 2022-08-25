item_monkey_king_bar_lua1_gem1 = item_monkey_king_bar_lua1_gem1 or class({})
item_monkey_king_bar_lua2_gem1 = item_monkey_king_bar_lua1_gem1 or class({})
item_monkey_king_bar_lua3_gem1 = item_monkey_king_bar_lua1_gem1 or class({})
item_monkey_king_bar_lua4_gem1 = item_monkey_king_bar_lua1_gem1 or class({})
item_monkey_king_bar_lua5_gem1 = item_monkey_king_bar_lua1_gem1 or class({})
item_monkey_king_bar_lua6_gem1 = item_monkey_king_bar_lua1_gem1 or class({})
item_monkey_king_bar_lua7_gem1 = item_monkey_king_bar_lua1_gem1 or class({})

item_monkey_king_bar_lua1_gem2 = item_monkey_king_bar_lua1_gem2 or class({})
item_monkey_king_bar_lua2_gem2 = item_monkey_king_bar_lua1_gem2 or class({})
item_monkey_king_bar_lua3_gem2 = item_monkey_king_bar_lua1_gem2 or class({})
item_monkey_king_bar_lua4_gem2 = item_monkey_king_bar_lua1_gem2 or class({})
item_monkey_king_bar_lua5_gem2 = item_monkey_king_bar_lua1_gem2 or class({})
item_monkey_king_bar_lua6_gem2 = item_monkey_king_bar_lua1_gem2 or class({})
item_monkey_king_bar_lua7_gem2 = item_monkey_king_bar_lua1_gem2 or class({})

item_monkey_king_bar_lua1_gem3 = item_monkey_king_bar_lua1_gem3 or class({})
item_monkey_king_bar_lua2_gem3 = item_monkey_king_bar_lua1_gem3 or class({})
item_monkey_king_bar_lua3_gem3 = item_monkey_king_bar_lua1_gem3 or class({})
item_monkey_king_bar_lua4_gem3 = item_monkey_king_bar_lua1_gem3 or class({})
item_monkey_king_bar_lua5_gem3 = item_monkey_king_bar_lua1_gem3 or class({})
item_monkey_king_bar_lua6_gem3 = item_monkey_king_bar_lua1_gem3 or class({})
item_monkey_king_bar_lua7_gem3 = item_monkey_king_bar_lua1_gem3 or class({})

item_monkey_king_bar_lua1_gem4 = item_monkey_king_bar_lua1_gem4 or class({})
item_monkey_king_bar_lua2_gem4 = item_monkey_king_bar_lua1_gem4 or class({})
item_monkey_king_bar_lua3_gem4 = item_monkey_king_bar_lua1_gem4 or class({})
item_monkey_king_bar_lua4_gem4 = item_monkey_king_bar_lua1_gem4 or class({})
item_monkey_king_bar_lua5_gem4 = item_monkey_king_bar_lua1_gem4 or class({})
item_monkey_king_bar_lua6_gem4 = item_monkey_king_bar_lua1_gem4 or class({})
item_monkey_king_bar_lua7_gem4 = item_monkey_king_bar_lua1_gem4 or class({})

item_monkey_king_bar_lua1_gem5 = item_monkey_king_bar_lua1_gem5 or class({})
item_monkey_king_bar_lua2_gem5 = item_monkey_king_bar_lua1_gem5 or class({})
item_monkey_king_bar_lua3_gem5 = item_monkey_king_bar_lua1_gem5 or class({})
item_monkey_king_bar_lua4_gem5 = item_monkey_king_bar_lua1_gem5 or class({})
item_monkey_king_bar_lua5_gem5 = item_monkey_king_bar_lua1_gem5 or class({})
item_monkey_king_bar_lua6_gem5 = item_monkey_king_bar_lua1_gem5 or class({})
item_monkey_king_bar_lua7_gem5 = item_monkey_king_bar_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_monkey_king_bar_passive1", 'items/items_gems/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_monkey_king_bar_passive2", 'items/items_gems/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_monkey_king_bar_passive3", 'items/items_gems/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_monkey_king_bar_passive4", 'items/items_gems/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_monkey_king_bar_passive5", 'items/items_gems/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_monkey_king_bar_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive1"
end
function item_monkey_king_bar_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive2"
end
function item_monkey_king_bar_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive3"
end
function item_monkey_king_bar_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive4"
end
function item_monkey_king_bar_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive5"
end

--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive1 = class({})

function modifier_item_monkey_king_bar_passive1:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive1:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive1:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive1:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive1:OnCreated()
	
	
	
	self.bonus_damage			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_chance			= self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
	
	self.pierce_proc 			= false
	self.pierce_records			= {}
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_monkey_king_bar_passive1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_monkey_king_bar_passive1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive1:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_monkey_king_bar_passive1:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_monkey_king_bar_passive1:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_monkey_king_bar_passive1:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_monkey_king_bar_passive1") and RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end


function modifier_item_monkey_king_bar_passive1:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end

--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive2 = class({})

function modifier_item_monkey_king_bar_passive2:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive2:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive2:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive2:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive2:OnCreated()
	
	
	
	self.bonus_damage			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_chance			= self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
	
	self.pierce_proc 			= false
	self.pierce_records			= {}
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_monkey_king_bar_passive2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_monkey_king_bar_passive2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive2:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_monkey_king_bar_passive2:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_monkey_king_bar_passive2:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_monkey_king_bar_passive2:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_monkey_king_bar_passive2") and RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end


function modifier_item_monkey_king_bar_passive2:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end
--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive3 = class({})

function modifier_item_monkey_king_bar_passive3:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive3:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive3:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive3:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive3:OnCreated()
	
	
	
	self.bonus_damage			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_chance			= self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
	
	self.pierce_proc 			= false
	self.pierce_records			= {}
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_monkey_king_bar_passive3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_monkey_king_bar_passive3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive3:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_monkey_king_bar_passive3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_monkey_king_bar_passive3:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_monkey_king_bar_passive3:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_monkey_king_bar_passive3") and RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end


function modifier_item_monkey_king_bar_passive3:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end
--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive4 = class({})

function modifier_item_monkey_king_bar_passive4:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive4:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive4:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive4:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive4:OnCreated()
	
	
	
	self.bonus_damage			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_chance			= self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
	
	self.pierce_proc 			= false
	self.pierce_records			= {}
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_monkey_king_bar_passive4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_monkey_king_bar_passive4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive4:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_monkey_king_bar_passive4:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_monkey_king_bar_passive4:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_monkey_king_bar_passive4:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_monkey_king_bar_passive4") and RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end


function modifier_item_monkey_king_bar_passive4:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end
--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive5 = class({})

function modifier_item_monkey_king_bar_passive5:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive5:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive5:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive5:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive5:OnCreated()
	
	
	
	self.bonus_damage			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_chance			= self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage	= self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
	
	self.pierce_proc 			= false
	self.pierce_records			= {}
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_monkey_king_bar_passive5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_monkey_king_bar_passive5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive5:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_monkey_king_bar_passive5:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_monkey_king_bar_passive5:GetModifierProcAttack_BonusDamage_Magical(keys)
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() then
				self:GetParent():EmitSound("DOTA_Item.MKB.proc")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
				
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_monkey_king_bar_passive5:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if (not keys.target:IsMagicImmune() or self:GetName() == "modifier_item_monkey_king_bar_passive5") and RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end


function modifier_item_monkey_king_bar_passive5:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end

 function RollPseudoRandom(base_chance, entity)
 local ran = RandomInt(1,100)
 if base_chance >= ran then return true
 else return false
 end
 end