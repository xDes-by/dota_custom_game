item_assault_lua = class({})

item_assault_lua1 = item_assault_lua
item_assault_lua2 = item_assault_lua
item_assault_lua3 = item_assault_lua
item_assault_lua4 = item_assault_lua
item_assault_lua5 = item_assault_lua
item_assault_lua6 = item_assault_lua
item_assault_lua7 = item_assault_lua
item_assault_lua8 = item_assault_lua

item_assault_lua1_gem1 = item_assault_lua
item_assault_lua2_gem1 = item_assault_lua
item_assault_lua3_gem1 = item_assault_lua
item_assault_lua4_gem1 = item_assault_lua
item_assault_lua5_gem1 = item_assault_lua
item_assault_lua6_gem1 = item_assault_lua
item_assault_lua7_gem1 = item_assault_lua
item_assault_lua8_gem1 = item_assault_lua

item_assault_lua1_gem2 = item_assault_lua
item_assault_lua2_gem2 = item_assault_lua
item_assault_lua3_gem2 = item_assault_lua
item_assault_lua4_gem2 = item_assault_lua
item_assault_lua5_gem2 = item_assault_lua
item_assault_lua6_gem2 = item_assault_lua
item_assault_lua7_gem2 = item_assault_lua
item_assault_lua8_gem2 = item_assault_lua

item_assault_lua1_gem3 = item_assault_lua
item_assault_lua2_gem3 = item_assault_lua
item_assault_lua3_gem3 = item_assault_lua
item_assault_lua4_gem3 = item_assault_lua
item_assault_lua5_gem3 = item_assault_lua
item_assault_lua6_gem3 = item_assault_lua
item_assault_lua7_gem3 = item_assault_lua
item_assault_lua8_gem3 = item_assault_lua

item_assault_lua1_gem4 = item_assault_lua
item_assault_lua2_gem4 = item_assault_lua
item_assault_lua3_gem4 = item_assault_lua
item_assault_lua4_gem4 = item_assault_lua
item_assault_lua5_gem4 = item_assault_lua
item_assault_lua6_gem4 = item_assault_lua
item_assault_lua7_gem4 = item_assault_lua
item_assault_lua8_gem4 = item_assault_lua

item_assault_lua1_gem5 = item_assault_lua
item_assault_lua2_gem5 = item_assault_lua
item_assault_lua3_gem5 = item_assault_lua
item_assault_lua4_gem5 = item_assault_lua
item_assault_lua5_gem5 = item_assault_lua
item_assault_lua6_gem5 = item_assault_lua
item_assault_lua7_gem5 = item_assault_lua
item_assault_lua8_gem5 = item_assault_lua

LinkLuaModifier("modifier_assault_lua", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_positive_effect", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_negative_effect", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)

function item_assault_lua1:GetIntrinsicModifierName()
	return "modifier_assault_lua"
end

------------------------------------------------

modifier_assault_lua = class({})

function modifier_assault_lua:IsHidden()		
	return true 
end

function modifier_assault_lua:IsPurgable()		
	return false 
end

function modifier_assault_lua:RemoveOnDeath()	
	return false 
end

function modifier_assault_lua:OnCreated()
	self.parent = self:GetParent()
	self.abi = self:GetAbility()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")

	self.aura_attack_speed = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.aura_positive_armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
	self.aura_negative_armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor") * -1
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.2)
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_assault_lua:OnIntervalThink()
	local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.aura_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _,unit in pairs(enemies) do
		unit:AddNewModifier(self.parent, self.abi, "modifier_assault_lua_aura_negative_effect", {aura_negative_armor = self.aura_negative_armor})
	end
end

function modifier_assault_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_assault_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_assault_lua:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_assault_lua:IsAura()
	return true
end

function modifier_assault_lua:GetModifierAura()
	return "modifier_assault_lua_aura_positive_effect"
end

function modifier_assault_lua:GetAuraRadius()
	return self.aura_radius
end
function modifier_assault_lua:GetAuraDuration()
	return 0.5
end

function modifier_assault_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_assault_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_assault_lua:GetAuraSearchFlags()
	return 0
end

modifier_assault_lua_aura_positive_effect = class({})
--Classifications template
function modifier_assault_lua_aura_positive_effect:IsHidden()
	return false
end

function modifier_assault_lua_aura_positive_effect:IsDebuff()
	return false
end

function modifier_assault_lua_aura_positive_effect:IsPurgable()
	return false
end

function modifier_assault_lua_aura_positive_effect:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_assault_lua_aura_positive_effect:IsStunDebuff()
	return false
end

function modifier_assault_lua_aura_positive_effect:RemoveOnDeath()
	return false
end

function modifier_assault_lua_aura_positive_effect:DestroyOnExpire()
	return true
end

function modifier_assault_lua_aura_positive_effect:OnCreated(data)
	self.aura_attack_speed = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.aura_positive_armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
	self:StartIntervalThink(1)
end

function modifier_assault_lua_aura_positive_effect:OnRefresh(data)
	local aura_attack_speed = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	local aura_positive_armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
	if aura_attack_speed > self.aura_attack_speed then
		self.aura_attack_speed = aura_attack_speed
	end
	if aura_positive_armor > self.aura_positive_armor then
		self.aura_positive_armor = aura_positive_armor
	end
end

function modifier_assault_lua_aura_positive_effect:OnIntervalThink()
	self:Destroy()
end

function modifier_assault_lua_aura_positive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_attack_speed
end

function modifier_assault_lua_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.aura_positive_armor
end

modifier_assault_lua_aura_negative_effect = class({})
--Classifications template
function modifier_assault_lua_aura_negative_effect:IsHidden()
	return false
end

function modifier_assault_lua_aura_negative_effect:IsDebuff()
	return true
end

function modifier_assault_lua_aura_negative_effect:IsPurgable()
	return false
end

function modifier_assault_lua_aura_negative_effect:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_assault_lua_aura_negative_effect:IsStunDebuff()
	return false
end

function modifier_assault_lua_aura_negative_effect:RemoveOnDeath()
	return false
end

function modifier_assault_lua_aura_negative_effect:DestroyOnExpire()
	return true
end

function modifier_assault_lua_aura_negative_effect:OnCreated()
	if not IsServer() then
		return
	end
	self.abi = self:GetAbility()
	self.aura_negative_armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor") * -1
	self:SetHasCustomTransmitterData( true )
end

function modifier_assault_lua_aura_negative_effect:OnRefresh()
	if not IsServer() then
		return
	end
	local aura_negative_armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor") * -1
	if aura_negative_armor < self.aura_negative_armor then
		self.aura_negative_armor = aura_negative_armor
		self.abi = self:GetAbility()
	end
	if aura_negative_armor == self.aura_negative_armor then
		self:StartIntervalThink(1)
	end
	self:SendBuffRefreshToClients()
end

function modifier_assault_lua_aura_negative_effect:OnIntervalThink()
	self:Destroy()
end

function modifier_assault_lua_aura_negative_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.aura_negative_armor
end

function modifier_assault_lua_aura_negative_effect:AddCustomTransmitterData()
	return {
		aura_negative_armor = self.aura_negative_armor,
	}
end

function modifier_assault_lua_aura_negative_effect:HandleCustomTransmitterData( data )
	self.aura_negative_armor = data.aura_negative_armor
end