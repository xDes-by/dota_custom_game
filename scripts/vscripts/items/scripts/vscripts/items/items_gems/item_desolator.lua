LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua1 = item_desolator_lua1 or class({})

item_desolator_lua1_gem1 = item_desolator_lua1 or class({})
item_desolator_lua1_gem2 = item_desolator_lua1 or class({})
item_desolator_lua1_gem3 = item_desolator_lua1 or class({})
item_desolator_lua1_gem4 = item_desolator_lua1 or class({})
item_desolator_lua1_gem5 = item_desolator_lua1 or class({})

LinkLuaModifier( "modifier_item_desolator_lua", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua1:GetIntrinsicModifierName()
return "modifier_item_desolator_lua" end

if modifier_item_desolator_lua == nil then modifier_item_desolator_lua = class({}) end

function modifier_item_desolator_lua:IsHidden()		return true end
function modifier_item_desolator_lua:IsPurgable()		return false end
function modifier_item_desolator_lua:RemoveOnDeath()	return false end

function modifier_item_desolator_lua:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if target:HasModifier("modifier_item_desolator_lua_2_debuff") or
			target:HasModifier("modifier_item_desolator_lua_3_debuff") or
			target:HasModifier("modifier_item_desolator_lua_4_debuff") or
			target:HasModifier("modifier_item_desolator_lua_5_debuff") or
			target:HasModifier("modifier_item_desolator_lua_6_debuff") or
			target:HasModifier("modifier_item_desolator_lua_7_debuff")
		then return end

		target:RemoveModifierByName("modifier_item_blight_stone_lua_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_debuff == nil then modifier_item_desolator_lua_debuff = class({}) end
function modifier_item_desolator_lua_debuff:IsHidden() return false end
function modifier_item_desolator_lua_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua2 = item_desolator_lua2 or class({})

item_desolator_lua2_gem1 = item_desolator_lua2 or class({})
item_desolator_lua2_gem2 = item_desolator_lua2 or class({})
item_desolator_lua2_gem3 = item_desolator_lua2 or class({})
item_desolator_lua2_gem4 = item_desolator_lua2 or class({})
item_desolator_lua2_gem5 = item_desolator_lua2 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_2", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_2_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua2:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_2" end

if modifier_item_desolator_lua_2 == nil then modifier_item_desolator_lua_2 = class({}) end

function modifier_item_desolator_lua_2:IsHidden()		return true end
function modifier_item_desolator_lua_2:IsPurgable()		return false end
function modifier_item_desolator_lua_2:RemoveOnDeath()	return false end

function modifier_item_desolator_lua_2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua_2:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua_2:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_2:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if	target:HasModifier("modifier_item_desolator_lua_3_debuff") or
			target:HasModifier("modifier_item_desolator_lua_4_debuff") or
			target:HasModifier("modifier_item_desolator_lua_5_debuff") or
			target:HasModifier("modifier_item_desolator_lua_6_debuff") or
			target:HasModifier("modifier_item_desolator_lua_7_debuff")
		then return end

		target:RemoveModifierByName("modifier_item_blight_stone_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_2_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_2_debuff == nil then modifier_item_desolator_lua_2_debuff = class({}) end
function modifier_item_desolator_lua_2_debuff:IsHidden() return false end
function modifier_item_desolator_lua_2_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_2_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_2_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_2_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua3 = item_desolator_lua3 or class({})

item_desolator_lua3_gem1 = item_desolator_lua3 or class({})
item_desolator_lua3_gem2 = item_desolator_lua3 or class({})
item_desolator_lua3_gem3 = item_desolator_lua3 or class({})
item_desolator_lua3_gem4 = item_desolator_lua3 or class({})
item_desolator_lua3_gem5 = item_desolator_lua3 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_3", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_3_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua3:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_3" end

if modifier_item_desolator_lua_3 == nil then modifier_item_desolator_lua_3 = class({}) end

function modifier_item_desolator_lua_3:IsHidden()		return true end
function modifier_item_desolator_lua_3:IsPurgable()		return false end
function modifier_item_desolator_lua_3:RemoveOnDeath()	return false end

function modifier_item_desolator_lua_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua_3:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua_3:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_3:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if	target:HasModifier("modifier_item_desolator_lua_4_debuff") or
			target:HasModifier("modifier_item_desolator_lua_5_debuff") or
			target:HasModifier("modifier_item_desolator_lua_6_debuff") or
			target:HasModifier("modifier_item_desolator_lua_7_debuff")
		then return end

		target:RemoveModifierByName("modifier_item_blight_stone_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_2_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_3_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_3_debuff == nil then modifier_item_desolator_lua_3_debuff = class({}) end
function modifier_item_desolator_lua_3_debuff:IsHidden() return false end
function modifier_item_desolator_lua_3_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_3_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_3_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_3_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua4= item_desolator_lua4 or class({})

item_desolator_lua4_gem1 = item_desolator_lua4 or class({})
item_desolator_lua4_gem2 = item_desolator_lua4 or class({})
item_desolator_lua4_gem3 = item_desolator_lua4 or class({})
item_desolator_lua4_gem4 = item_desolator_lua4 or class({})
item_desolator_lua4_gem5 = item_desolator_lua4 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_4", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_4_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua4:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_4" end

if modifier_item_desolator_lua_4 == nil then modifier_item_desolator_lua_4 = class({}) end

function modifier_item_desolator_lua_4:IsHidden()		return true end
function modifier_item_desolator_lua_4:IsPurgable()		return false end
function modifier_item_desolator_lua_4:RemoveOnDeath()	return false end

function modifier_item_desolator_lua_4:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua_4:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua_4:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_4:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if	target:HasModifier("modifier_item_desolator_lua_5_debuff") or
			target:HasModifier("modifier_item_desolator_lua_6_debuff") or
			target:HasModifier("modifier_item_desolator_lua_7_debuff")
		then return end

		target:RemoveModifierByName("modifier_item_blight_stone_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_2_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_3_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_4_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_4_debuff == nil then modifier_item_desolator_lua_4_debuff = class({}) end
function modifier_item_desolator_lua_4_debuff:IsHidden() return false end
function modifier_item_desolator_lua_4_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_4_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_4_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_4_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua5 = item_desolator_lua5 or class({})

item_desolator_lua5_gem1 = item_desolator_lua5 or class({})
item_desolator_lua5_gem2 = item_desolator_lua5 or class({})
item_desolator_lua5_gem3 = item_desolator_lua5 or class({})
item_desolator_lua5_gem4 = item_desolator_lua5 or class({})
item_desolator_lua5_gem5 = item_desolator_lua5 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_5", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_5_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua5:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_5" end

if modifier_item_desolator_lua_5 == nil then modifier_item_desolator_lua_5 = class({}) end

function modifier_item_desolator_lua_5:IsHidden()		return true end
function modifier_item_desolator_lua_5:IsPurgable()		return false end
function modifier_item_desolator_lua_5:RemoveOnDeath()	return false end

function modifier_item_desolator_lua_5:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua_5:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua_5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua_5:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_5:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if	target:HasModifier("modifier_item_desolator_lua_6_debuff") or
			target:HasModifier("modifier_item_desolator_lua_7_debuff")
		then return end

		target:RemoveModifierByName("modifier_item_blight_stone_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_2_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_3_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_4_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_5_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_5_debuff == nil then modifier_item_desolator_lua_5_debuff = class({}) end
function modifier_item_desolator_lua_5_debuff:IsHidden() return false end
function modifier_item_desolator_lua_5_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_5_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_5_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_5_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_5_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua6 = item_desolator_lua6 or class({})

item_desolator_lua6_gem1 = item_desolator_lua6 or class({})
item_desolator_lua6_gem2 = item_desolator_lua6 or class({})
item_desolator_lua6_gem3 = item_desolator_lua6 or class({})
item_desolator_lua6_gem4 = item_desolator_lua6 or class({})
item_desolator_lua6_gem5 = item_desolator_lua6 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_6", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_6_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua6:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_6" end

if modifier_item_desolator_lua_6 == nil then modifier_item_desolator_lua_6 = class({}) end

function modifier_item_desolator_lua_6:IsHidden()		return true end
function modifier_item_desolator_lua_6:IsPurgable()		return false end
function modifier_item_desolator_lua_6:RemoveOnDeath()	return false end

function modifier_item_desolator_lua_6:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua_6:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua_6:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua_6:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_6:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if	target:HasModifier("modifier_item_desolator_lua_7_debuff")
		then return end

		target:RemoveModifierByName("modifier_item_blight_stone_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_2_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_3_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_4_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_5_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_6_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_6_debuff == nil then modifier_item_desolator_lua_6_debuff = class({}) end
function modifier_item_desolator_lua_6_debuff:IsHidden() return false end
function modifier_item_desolator_lua_6_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_6_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_6_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_6_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_6_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua7 = item_desolator_lua7 or class({})

item_desolator_lua7_gem1 = item_desolator_lua7 or class({})
item_desolator_lua7_gem2 = item_desolator_lua7 or class({})
item_desolator_lua7_gem3 = item_desolator_lua7 or class({})
item_desolator_lua7_gem4 = item_desolator_lua7 or class({})
item_desolator_lua7_gem5 = item_desolator_lua7 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_7", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_7_debuff", "items/items_gems/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua7:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_7" end

if modifier_item_desolator_lua_7 == nil then modifier_item_desolator_lua_7 = class({}) end

function modifier_item_desolator_lua_7:IsHidden()		return true end
function modifier_item_desolator_lua_7:IsPurgable()		return false end
function modifier_item_desolator_lua_7:RemoveOnDeath()	return false end

function modifier_item_desolator_lua_7:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_desolator_lua_7:OnDestroy()
	if not IsServer() then return end 
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
	ChangeAttackProjectileImba(self:GetParent())
end

function modifier_item_desolator_lua_7:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_item_desolator_lua_7:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_7:OnAttackLanded( keys )
	if self:GetAbility() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		target:RemoveModifierByName("modifier_item_desolator_lua_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_2_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_3_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_4_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_5_debuff")
		target:RemoveModifierByName("modifier_item_desolator_lua_6_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_7_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_7_debuff == nil then modifier_item_desolator_lua_7_debuff = class({}) end
function modifier_item_desolator_lua_7_debuff:IsHidden() return false end
function modifier_item_desolator_lua_7_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_7_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_7_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_7_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_7_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Desolate(attacker, target, ability, modifier_name, duration)
	if not target:HasModifier(modifier_name) then
		target:EmitSound("Item_Desolator.Target")
	end
	target:AddNewModifier(attacker, ability, modifier_name, {duration = duration * (1 - target:GetStatusResistance())})
end

function ChangeAttackProjectileImba(unit)
		local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
		unit:SetRangedProjectileName(particle_deso)
end