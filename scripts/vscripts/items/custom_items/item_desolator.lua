if item_blight_stone_lua == nil then item_blight_stone_lua = class({}) end
LinkLuaModifier( "modifier_item_blight_stone_lua", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_blight_stone_lua_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )	-- Armor/vision debuff

function item_blight_stone_lua:GetIntrinsicModifierName()
	return "modifier_item_blight_stone_lua"
end

if modifier_item_blight_stone_lua == nil then modifier_item_blight_stone_lua = class({}) end

function modifier_item_blight_stone_lua:IsHidden()		return true end
function modifier_item_blight_stone_lua:IsPurgable()		return false end
function modifier_item_blight_stone_lua:RemoveOnDeath()	return false end
function modifier_item_blight_stone_lua:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_blight_stone_lua:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
end

function modifier_item_blight_stone_lua:OnDestroy()

end

function modifier_item_blight_stone_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_blight_stone_lua:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target
		if owner:IsIllusion() then
			return end

		if target:HasModifier("modifier_item_desolator_lua_debuff") or
			target:HasModifier("modifier_item_desolator_lua_2_debuff") or
			target:HasModifier("modifier_item_desolator_lua_3_debuff") or
			target:HasModifier("modifier_item_desolator_lua_4_debuff") or
			target:HasModifier("modifier_item_desolator_lua_5_debuff") or
			target:HasModifier("modifier_item_desolator_lua_6_debuff") or
			target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
			then return end

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_blight_stone_lua_debuff", ability:GetSpecialValueFor("duration"))
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_item_blight_stone_lua_debuff == nil then modifier_item_blight_stone_lua_debuff = class({}) end
function modifier_item_blight_stone_lua_debuff:IsHidden() return false end
function modifier_item_blight_stone_lua_debuff:IsDebuff() return true end
function modifier_item_blight_stone_lua_debuff:IsPurgable() return true end

function modifier_item_blight_stone_lua_debuff:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	local ability = self:GetAbility()

	if not ability then
		self:Destroy()
		return nil
	end

	self.armor_reduction = (-1) * ability:GetSpecialValueFor("armor_reduction")
end

function modifier_item_blight_stone_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_blight_stone_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
item_desolator_lua1 = item_desolator_lua1 or class({})

LinkLuaModifier( "modifier_item_desolator_lua", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua1:GetIntrinsicModifierName()
return "modifier_item_desolator_lua" end

if modifier_item_desolator_lua == nil then modifier_item_desolator_lua = class({}) end

function modifier_item_desolator_lua:IsHidden()		return true end
function modifier_item_desolator_lua:IsPurgable()		return false end
function modifier_item_desolator_lua:RemoveOnDeath()	return false end
function modifier_item_desolator_lua:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua:OnDestroy()

end

function modifier_item_desolator_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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
			target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
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

LinkLuaModifier( "modifier_item_desolator_lua_2", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_2_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua2:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_2" end

if modifier_item_desolator_lua_2 == nil then modifier_item_desolator_lua_2 = class({}) end

function modifier_item_desolator_lua_2:IsHidden()		return true end
function modifier_item_desolator_lua_2:IsPurgable()		return false end
function modifier_item_desolator_lua_2:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua_2:OnDestroy()

end

function modifier_item_desolator_lua_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_2:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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
			target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
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

LinkLuaModifier( "modifier_item_desolator_lua_3", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_3_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua3:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_3" end

if modifier_item_desolator_lua_3 == nil then modifier_item_desolator_lua_3 = class({}) end

function modifier_item_desolator_lua_3:IsHidden()		return true end
function modifier_item_desolator_lua_3:IsPurgable()		return false end
function modifier_item_desolator_lua_3:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_3:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_3:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua_3:OnDestroy()

end

function modifier_item_desolator_lua_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_3:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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
			target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
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

LinkLuaModifier( "modifier_item_desolator_lua_4", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_4_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua4:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_4" end

if modifier_item_desolator_lua_4 == nil then modifier_item_desolator_lua_4 = class({}) end

function modifier_item_desolator_lua_4:IsHidden()		return true end
function modifier_item_desolator_lua_4:IsPurgable()		return false end
function modifier_item_desolator_lua_4:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_4:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_4:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua_4:OnDestroy()

end

function modifier_item_desolator_lua_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_4:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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
			target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
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

LinkLuaModifier( "modifier_item_desolator_lua_5", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_5_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua5:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_5" end

if modifier_item_desolator_lua_5 == nil then modifier_item_desolator_lua_5 = class({}) end

function modifier_item_desolator_lua_5:IsHidden()		return true end
function modifier_item_desolator_lua_5:IsPurgable()		return false end
function modifier_item_desolator_lua_5:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_5:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_5:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua_5:OnDestroy()

end

function modifier_item_desolator_lua_5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_5:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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
			target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
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

LinkLuaModifier( "modifier_item_desolator_lua_6", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_6_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua6:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_6" end

if modifier_item_desolator_lua_6 == nil then modifier_item_desolator_lua_6 = class({}) end

function modifier_item_desolator_lua_6:IsHidden()		return true end
function modifier_item_desolator_lua_6:IsPurgable()		return false end
function modifier_item_desolator_lua_6:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_6:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_6:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua_6:OnDestroy()

end

function modifier_item_desolator_lua_6:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_6:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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

		if	target:HasModifier("modifier_item_desolator_lua_7_debuff") or
			target:HasModifier("modifier_item_desolator_lua_8_debuff")
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

LinkLuaModifier( "modifier_item_desolator_lua_7", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_7_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua7:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_7" end

if modifier_item_desolator_lua_7 == nil then modifier_item_desolator_lua_7 = class({}) end

function modifier_item_desolator_lua_7:IsHidden()		return true end
function modifier_item_desolator_lua_7:IsPurgable()		return false end
function modifier_item_desolator_lua_7:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_7:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_7:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end


end

function modifier_item_desolator_lua_7:OnDestroy()

end

function modifier_item_desolator_lua_7:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_7:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
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

		if	target:HasModifier("modifier_item_desolator_lua_8_debuff")
		then return end
		
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

item_desolator_lua8 = item_desolator_lua8 or class({})

LinkLuaModifier( "modifier_item_desolator_lua_8", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_desolator_lua_8_debuff", "items/custom_items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_desolator_lua8:GetIntrinsicModifierName()
return "modifier_item_desolator_lua_8" end

if modifier_item_desolator_lua_8 == nil then modifier_item_desolator_lua_8 = class({}) end

function modifier_item_desolator_lua_8:IsHidden()		return true end
function modifier_item_desolator_lua_8:IsPurgable()		return false end
function modifier_item_desolator_lua_8:RemoveOnDeath()	return false end
function modifier_item_desolator_lua_8:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_desolator_lua_8:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
end

function modifier_item_desolator_lua_8:OnDestroy()

end

function modifier_item_desolator_lua_8:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_item_desolator_lua_8:GetModifierProjectileName()
	return "particles/items_fx/desolator_projectile.vpcf"
end

function modifier_item_desolator_lua_8:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_item_desolator_lua_8:OnAttackLanded( keys )
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
		target:RemoveModifierByName("modifier_item_desolator_lua_7_debuff")

		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_desolator_lua_8_debuff", ability:GetSpecialValueFor("corruption_duration"))
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if modifier_item_desolator_lua_8_debuff == nil then modifier_item_desolator_lua_8_debuff = class({}) end
function modifier_item_desolator_lua_8_debuff:IsHidden() return false end
function modifier_item_desolator_lua_8_debuff:IsDebuff() return true end
function modifier_item_desolator_lua_8_debuff:IsPurgable() return true end

function modifier_item_desolator_lua_8_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("corruption_armor")
end

function modifier_item_desolator_lua_8_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_desolator_lua_8_debuff:GetModifierPhysicalArmorBonus()
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