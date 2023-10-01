item_moon_shard_lua = class({})

LinkLuaModifier("modifier_item_moon_shard_lua_passive", 'items/custom_items/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive_aura_positive", 'items/custom_items/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_moon_shard_lua_passive_aura_positive_effect", 'items/custom_items/item_moon_shard.lua', LUA_MODIFIER_MOTION_NONE)

function item_moon_shard_lua:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_lua_passive"
end

modifier_item_moon_shard_lua_passive = class({})
function modifier_item_moon_shard_lua_passive:IsHidden()		return true end
function modifier_item_moon_shard_lua_passive:IsPurgable()		return false end
function modifier_item_moon_shard_lua_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_moon_shard_lua_passive:OnCreated()
	self.parent = self:GetParent()
	self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_as")
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive_aura_positive") then
		if not IsServer() then return end
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_moon_shard_lua_passive_aura_positive", {})
	end
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_moon_shard_lua_passive:OnDestroy()
	if not IsServer() then 
		return 
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
	if not self:GetCaster():HasModifier("modifier_item_moon_shard_lua_passive") then
		self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive")
		self:GetCaster():RemoveModifierByName("modifier_item_moon_shard_lua_passive_aura_positive_effect")
	end
end


function modifier_item_moon_shard_lua_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_item_moon_shard_lua_passive:GetModifierAttackSpeedBonus_Constant()

		return self.bonus_as

end
--end

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
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_moon_shard_lua_passive_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end