item_crimson_guard_lua1_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua2_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua3_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua4_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua5_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua6_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua7_gem1 = item_crimson_guard_lua1_gem1 or class({})
item_crimson_guard_lua8_gem1 = item_crimson_guard_lua1_gem1 or class({})

item_crimson_guard_lua1_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua2_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua3_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua4_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua5_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua6_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua7_gem2 = item_crimson_guard_lua1_gem2 or class({})
item_crimson_guard_lua8_gem2 = item_crimson_guard_lua1_gem2 or class({})

item_crimson_guard_lua1_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua2_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua3_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua4_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua5_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua6_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua7_gem3 = item_crimson_guard_lua1_gem3 or class({})
item_crimson_guard_lua8_gem3 = item_crimson_guard_lua1_gem3 or class({})

item_crimson_guard_lua1_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua2_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua3_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua4_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua5_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua6_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua7_gem4 = item_crimson_guard_lua1_gem4 or class({})
item_crimson_guard_lua8_gem4 = item_crimson_guard_lua1_gem4 or class({})

item_crimson_guard_lua1_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua2_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua3_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua4_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua5_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua6_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua7_gem5 = item_crimson_guard_lua1_gem5 or class({})
item_crimson_guard_lua8_gem5 = item_crimson_guard_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_crimson_guard_lua1", 'items/items_gems/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_lua2", 'items/items_gems/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_lua3", 'items/items_gems/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_lua4", 'items/items_gems/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_lua5", 'items/items_gems/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_active_lua", 'items/items_gems/item_crimson_guard_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_crimson_guard_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_crimson_guard_lua1"
end

function item_crimson_guard_lua1_gem1:OnSpellStart()
	self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
		local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_active_lua", {duration = 12})
	end
end
--item_crimson_guard_lua1_gem2
function item_crimson_guard_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_crimson_guard_lua2"
end

function item_crimson_guard_lua1_gem2:OnSpellStart()
	self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
		local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_active_lua", {duration = 12})
	end
end
--item_crimson_guard_lua1_gem3
function item_crimson_guard_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_crimson_guard_lua3"
end

function item_crimson_guard_lua1_gem3:OnSpellStart()
	self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
		local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_active_lua", {duration = 12})
	end
end
--item_crimson_guard_lua1_gem4
function item_crimson_guard_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_crimson_guard_lua4"
end

function item_crimson_guard_lua1_gem4:OnSpellStart()
	self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
		local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_active_lua", {duration = 12})
	end
end
--item_crimson_guard_lua1_gem5
function item_crimson_guard_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_crimson_guard_lua5"
end

function item_crimson_guard_lua1_gem5:OnSpellStart()
	self:GetParent():EmitSound("Item.CrimsonGuard.Cast")
		local allys = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,units in pairs(allys) do
		units:AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_active_lua", {duration = 12})
	end
end
-------------------------------------------------------------------------------------

modifier_item_crimson_guard_active_lua = class({})

function modifier_item_crimson_guard_active_lua:OnCreated()
	EmitSoundOn("sounds/items/crimson_guard.vsnd", caster)

	self.particle = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)

	if self:GetParent():IsRangedAttacker() then
		self.block_damage_active = self:GetAbility():GetSpecialValueFor("block_damablock_damage_ranged_activege_ranged")
	else
		self.block_damage_active = self:GetAbility():GetSpecialValueFor("block_damage_melee_active")
	end
end

function modifier_item_crimson_guard_active_lua:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_active_lua:GetModifierPhysical_ConstantBlock()
	return self.block_damage_active
end

--------------------------------------------------------------------------

modifier_item_crimson_guard_lua1 = class({})

function modifier_item_crimson_guard_lua1:IsHidden()		
	return true 
end
function modifier_item_crimson_guard_lua1:IsPurgable()		
	return false 
end

function modifier_item_crimson_guard_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_crimson_guard_lua1:OnCreated()
	
	
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_crimson_guard_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_crimson_guard_lua1:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_lua1:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_crimson_guard_lua1:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crimson_guard_lua1:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crimson_guard_lua1:GetModifierPhysical_ConstantBlock(data)
	if RandomInt(1, 2) == 1 then
		return self.block_damage + data.damage * 0.01 * self:GetAbility():GetLevel()
	else
		return 0
	end
end 
--------------------------------------------------------------------------

modifier_item_crimson_guard_lua2 = class({})

function modifier_item_crimson_guard_lua2:IsHidden()		
	return true 
end
function modifier_item_crimson_guard_lua2:IsPurgable()		
	return false 
end

function modifier_item_crimson_guard_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_crimson_guard_lua2:OnCreated()
	
	
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_crimson_guard_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_crimson_guard_lua2:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_lua2:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_crimson_guard_lua2:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crimson_guard_lua2:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crimson_guard_lua2:GetModifierPhysical_ConstantBlock(data)
	if RandomInt(1, 2) == 1 then
		return self.block_damage + data.damage * 0.01 * self:GetAbility():GetLevel()
	else
		return 0
	end
end 

--------------------------------------------------------------------------

modifier_item_crimson_guard_lua3 = class({})

function modifier_item_crimson_guard_lua3:IsHidden()		
	return true 
end
function modifier_item_crimson_guard_lua3:IsPurgable()		
	return false 
end

function modifier_item_crimson_guard_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_crimson_guard_lua3:OnCreated()
	
	
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_crimson_guard_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_crimson_guard_lua3:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_lua3:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_crimson_guard_lua3:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crimson_guard_lua3:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crimson_guard_lua3:GetModifierPhysical_ConstantBlock(data)
	if RandomInt(1, 2) == 1 then
		return self.block_damage + data.damage * 0.01 * self:GetAbility():GetLevel()
	else
		return 0
	end
end 
--------------------------------------------------------------------------

modifier_item_crimson_guard_lua4 = class({})

function modifier_item_crimson_guard_lua4:IsHidden()		
	return true 
end
function modifier_item_crimson_guard_lua4:IsPurgable()		
	return false 
end

function modifier_item_crimson_guard_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_crimson_guard_lua4:OnCreated()
	
	
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_crimson_guard_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_crimson_guard_lua4:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_lua4:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_crimson_guard_lua4:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crimson_guard_lua4:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crimson_guard_lua4:GetModifierPhysical_ConstantBlock(data)
	if RandomInt(1, 2) == 1 then
		return self.block_damage + data.damage * 0.01 * self:GetAbility():GetLevel()
	else
		return 0
	end
end 
--------------------------------------------------------------------------

modifier_item_crimson_guard_lua5 = class({})

function modifier_item_crimson_guard_lua5:IsHidden()		
	return true 
end
function modifier_item_crimson_guard_lua5:IsPurgable()		
	return false 
end

function modifier_item_crimson_guard_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_crimson_guard_lua5:OnCreated()
	
	
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

	if self:GetParent():IsRangedAttacker() then
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	else
		self.block_damage = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	end
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_crimson_guard_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_crimson_guard_lua5:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_crimson_guard_lua5:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_crimson_guard_lua5:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_crimson_guard_lua5:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_crimson_guard_lua5:GetModifierPhysical_ConstantBlock(data)
	if RandomInt(1, 2) == 1 then
		return self.block_damage + data.damage * 0.01 * self:GetAbility():GetLevel()
	else
		return 0
	end
end 