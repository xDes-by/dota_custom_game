item_moon_shard_lua1_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua2_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua3_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua4_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua5_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua6_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua7_gem1 = item_moon_shard_lua1_gem1 or class({})
item_moon_shard_lua8_gem1 = item_moon_shard_lua1_gem1 or class({})

item_moon_shard_lua1_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua2_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua3_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua4_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua5_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua6_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua7_gem2 = item_moon_shard_lua1_gem2 or class({})
item_moon_shard_lua8_gem2 = item_moon_shard_lua1_gem2 or class({})

item_moon_shard_lua1_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua2_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua3_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua4_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua5_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua6_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua7_gem3 = item_moon_shard_lua1_gem3 or class({})
item_moon_shard_lua8_gem3 = item_moon_shard_lua1_gem3 or class({})

item_moon_shard_lua1_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua2_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua3_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua4_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua5_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua6_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua7_gem4 = item_moon_shard_lua1_gem4 or class({})
item_moon_shard_lua8_gem4 = item_moon_shard_lua1_gem4 or class({})

item_moon_shard_lua1_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua2_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua3_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua4_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua5_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua6_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua7_gem5 = item_moon_shard_lua1_gem5 or class({})
item_moon_shard_lua8_gem5 = item_moon_shard_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_moon_shard_lua_passive1", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive2", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive3", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive4", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive5", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_moon_shard_lua_passive_aura_positive", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive_aura_positive_effect", 'items/items_gems/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)

function item_moon_shard_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_lua_passive1"
end
function item_moon_shard_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_lua_passive2"
end
function item_moon_shard_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_lua_passive3"
end
function item_moon_shard_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_lua_passive4"
end
function item_moon_shard_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_lua_passive5"
end

modifier_item_moon_shard_lua_passive1 = class({})

function modifier_item_moon_shard_lua_passive1:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive1:IsPurgable()		return false end

function modifier_item_moon_shard_lua_passive1:OnCreated()

	
	
	local caster = self:GetCaster()
	
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive_aura_positive") then
		if not IsServer() then return end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_moon_shard_lua_passive_aura_positive", {})
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


function modifier_item_moon_shard_lua_passive1:OnDestroy()
		if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive1") then
			if not IsServer() then return end
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive_effect")
		end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_moon_shard_lua_passive1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive1:GetModifierAttackSpeedBonus_Constant()

		return self.bonus_as

end

modifier_item_moon_shard_lua_passive2 = class({})

function modifier_item_moon_shard_lua_passive2:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive2:IsPurgable()		return false end

function modifier_item_moon_shard_lua_passive2:OnCreated()

	
	
	local caster = self:GetCaster()
	
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive_aura_positive") then
		if not IsServer() then return end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_moon_shard_lua_passive_aura_positive", {})
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


function modifier_item_moon_shard_lua_passive2:OnDestroy()
		if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive2") then
			if not IsServer() then return end
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive_effect")
		end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_moon_shard_lua_passive2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive2:GetModifierAttackSpeedBonus_Constant()

		return self.bonus_as

end

modifier_item_moon_shard_lua_passive3 = class({})

function modifier_item_moon_shard_lua_passive3:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive3:IsPurgable()		return false end

function modifier_item_moon_shard_lua_passive3:OnCreated()

	
	
	local caster = self:GetCaster()
	
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive_aura_positive") then
		if not IsServer() then return end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_moon_shard_lua_passive_aura_positive", {})
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


function modifier_item_moon_shard_lua_passive3:OnDestroy()
		if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive3") then
			if not IsServer() then return end
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive_effect")
		end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_moon_shard_lua_passive3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive3:GetModifierAttackSpeedBonus_Constant()

		return self.bonus_as

end

modifier_item_moon_shard_lua_passive4 = class({})

function modifier_item_moon_shard_lua_passive4:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive4:IsPurgable()		return false end

function modifier_item_moon_shard_lua_passive4:OnCreated()

	
	
	local caster = self:GetCaster()
	
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive_aura_positive") then
		if not IsServer() then return end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_moon_shard_lua_passive_aura_positive", {})
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


function modifier_item_moon_shard_lua_passive4:OnDestroy()
		if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive4") then
			if not IsServer() then return end
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive_effect")
		end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_moon_shard_lua_passive4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive4:GetModifierAttackSpeedBonus_Constant()

		return self.bonus_as

end

modifier_item_moon_shard_lua_passive5 = class({})

function modifier_item_moon_shard_lua_passive5:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive5:IsPurgable()		return false end

function modifier_item_moon_shard_lua_passive5:OnCreated()

	
	
	local caster = self:GetCaster()
	
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive_aura_positive") then
		if not IsServer() then return end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_moon_shard_lua_passive_aura_positive", {})
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


function modifier_item_moon_shard_lua_passive5:OnDestroy()
		if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive5") then
			if not IsServer() then return end
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive_effect")
		end
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


function modifier_item_moon_shard_lua_passive5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive5:GetModifierAttackSpeedBonus_Constant()

		return self.bonus_as

end

modifier_item_moon_shard_lua_passive_aura_positive = class({})
function modifier_item_moon_shard_lua_passive_aura_positive:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive_aura_positive:IsPurgable() return false end

function modifier_item_moon_shard_lua_passive_aura_positive:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end


function modifier_item_moon_shard_lua_passive_aura_positive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_moon_shard_lua_passive_aura_positive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_moon_shard_lua_passive_aura_positive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_moon_shard_lua_passive_aura_positive:GetModifierAura()
	return "modifier_item_moon_shard_lua_passive_aura_positive_effect"
end

function modifier_item_moon_shard_lua_passive_aura_positive:IsAura()
	return true
end

modifier_item_moon_shard_lua_passive_aura_positive_effect = class({})

function modifier_item_moon_shard_lua_passive_aura_positive_effect:OnCreated()
	self.aura_as_ally = self:GetAbility():GetSpecialValueFor("aura_as_ally")
end

function modifier_item_moon_shard_lua_passive_aura_positive_effect:IsHidden() return true end
function modifier_item_moon_shard_lua_passive_aura_positive_effect:IsPurgable() return false end

function modifier_item_moon_shard_lua_passive_aura_positive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end