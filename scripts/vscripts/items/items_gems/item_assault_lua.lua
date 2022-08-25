item_assault_lua1_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua2_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua3_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua4_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua5_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua6_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua7_gem1 = item_assault_lua1_gem1 or class({})
item_assault_lua8_gem1 = item_assault_lua1_gem1 or class({})

item_assault_lua1_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua2_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua3_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua4_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua5_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua6_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua7_gem2 = item_assault_lua1_gem2 or class({})
item_assault_lua8_gem2 = item_assault_lua1_gem2 or class({})

item_assault_lua1_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua2_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua3_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua4_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua5_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua6_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua7_gem3 = item_assault_lua1_gem3 or class({})
item_assault_lua8_gem3 = item_assault_lua1_gem3 or class({})

item_assault_lua1_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua2_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua3_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua4_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua5_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua6_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua7_gem4 = item_assault_lua1_gem4 or class({})
item_assault_lua8_gem4 = item_assault_lua1_gem4 or class({})

item_assault_lua1_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua2_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua3_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua4_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua5_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua6_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua7_gem5 = item_assault_lua1_gem5 or class({})
item_assault_lua8_gem5 = item_assault_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_assault_lua1", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua2", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua3", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua4", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua5", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_positive", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_positive_effect", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_negative", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_negative_effect", "items/items_gems/item_assault_lua", LUA_MODIFIER_MOTION_NONE)

function item_assault_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_assault_lua1"
end
function item_assault_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_assault_lua2"
end
function item_assault_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_assault_lua3"
end
function item_assault_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_assault_lua4"
end
function item_assault_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_assault_lua5"
end

modifier_assault_lua1 = class({})

function modifier_assault_lua1:IsHidden()		return true end
function modifier_assault_lua1:IsPurgable()		return false end
function modifier_assault_lua1:RemoveOnDeath()	return false end

function modifier_assault_lua1:OnCreated()
	if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") and not self:GetCaster():HasModifier("modifier_assault_lua1_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
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

function modifier_assault_lua1:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua1") then
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_negative")
		end
	end
	
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_assault_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua1:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_assault_lua1:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua2 = class({})

function modifier_assault_lua2:IsHidden()		return true end
function modifier_assault_lua2:IsPurgable()		return false end
function modifier_assault_lua2:RemoveOnDeath()	return false end

function modifier_assault_lua2:OnCreated()
	if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
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

function modifier_assault_lua2:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua2") then
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_negative")
		end
	end
	
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_assault_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua2:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_assault_lua2:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua3 = class({})

function modifier_assault_lua3:IsHidden()		return true end
function modifier_assault_lua3:IsPurgable()		return false end
function modifier_assault_lua3:RemoveOnDeath()	return false end

function modifier_assault_lua3:OnCreated()
	if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
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

function modifier_assault_lua3:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua3") then
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_negative")
		end
	end
	
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_assault_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua3:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_assault_lua3:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua4 = class({})

function modifier_assault_lua4:IsHidden()		return true end
function modifier_assault_lua4:IsPurgable()		return false end
function modifier_assault_lua4:RemoveOnDeath()	return false end

function modifier_assault_lua4:OnCreated()
	if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
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

function modifier_assault_lua4:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua4") then
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_negative")
		end
	end
	
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_assault_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua4:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_assault_lua4:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua5 = class({})

function modifier_assault_lua5:IsHidden()		return true end
function modifier_assault_lua5:IsPurgable()		return false end
function modifier_assault_lua5:RemoveOnDeath()	return false end

function modifier_assault_lua5:OnCreated()
	if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
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

function modifier_assault_lua5:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua5") then
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_negative")
		end
	end
	
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_assault_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua5:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_assault_lua5:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua_aura_positive = class({})

function modifier_assault_lua_aura_positive:IsDebuff() return false end
function modifier_assault_lua_aura_positive:AllowIllusionDuplicate() return true end
function modifier_assault_lua_aura_positive:IsHidden() return true end
function modifier_assault_lua_aura_positive:IsPurgable() return false end

function modifier_assault_lua_aura_positive:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_assault_lua_aura_positive:GetAuraEntityReject(target)
	return false
end

function modifier_assault_lua_aura_positive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_assault_lua_aura_positive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_assault_lua_aura_positive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_assault_lua_aura_positive:GetModifierAura()
	return "modifier_assault_lua_aura_positive_effect"
end

function modifier_assault_lua_aura_positive:IsAura()
	return true
end

---------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua_aura_positive_effect = class({})

function modifier_assault_lua_aura_positive_effect:OnCreated()
	if not self:GetAbility() then
		if IsServer() then
			self:Destroy()
		end

		return
	end

	self.aura_as_ally = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.aura_armor_ally = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
end

function modifier_assault_lua_aura_positive_effect:IsHidden() return false end
function modifier_assault_lua_aura_positive_effect:IsPurgable() return false end
function modifier_assault_lua_aura_positive_effect:IsDebuff() return false end

function modifier_assault_lua_aura_positive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_assault_lua_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end

function modifier_assault_lua_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_ally
end

function modifier_assault_lua_aura_positive_effect:GetEffectName()
	return "particles/items_fx/aura_assault.vpcf"
end

function modifier_assault_lua_aura_positive_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua_aura_negative = class({})

function modifier_assault_lua_aura_negative:IsDebuff() return false end
function modifier_assault_lua_aura_negative:IsHidden() return true end
function modifier_assault_lua_aura_negative:IsPurgable() return false end

function modifier_assault_lua_aura_negative:GetAuraRadius()
	if self:GetAbility() then
		return 800-- self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_assault_lua_aura_negative:GetAuraEntityReject(target)
	return false
end

function modifier_assault_lua_aura_negative:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_assault_lua_aura_negative:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_assault_lua_aura_negative:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_assault_lua_aura_negative:GetModifierAura()
	return "modifier_assault_lua_aura_negative_effect"
end

function modifier_assault_lua_aura_negative:IsAura()
	return true
end

------------------------------------------------------------------------------------------------------------------------------------------

modifier_assault_lua_aura_negative_effect = class({})

function modifier_assault_lua_aura_negative_effect:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.aura_armor_reduction_enemy = self:GetAbility():GetSpecialValueFor("aura_negative_armor") * (-1)
end

function modifier_assault_lua_aura_negative_effect:IsHidden() return false end
function modifier_assault_lua_aura_negative_effect:IsPurgable() return false end
function modifier_assault_lua_aura_negative_effect:IsDebuff() return true end

function modifier_assault_lua_aura_negative_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_assault_lua_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_reduction_enemy
end
