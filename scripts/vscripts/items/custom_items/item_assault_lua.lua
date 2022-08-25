item_assault_lua1 = item_assault_lua1 or class({})
item_assault_lua2 = item_assault_lua1 or class({})
item_assault_lua3 = item_assault_lua1 or class({})
item_assault_lua4 = item_assault_lua1 or class({})
item_assault_lua5 = item_assault_lua1 or class({})
item_assault_lua6 = item_assault_lua1 or class({})
item_assault_lua7 = item_assault_lua1 or class({})
item_assault_lua8 = item_assault_lua1 or class({})

LinkLuaModifier("modifier_assault_lua", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_positive", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_positive_effect", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_negative", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assault_lua_aura_negative_effect", "items/custom_items/item_assault_lua", LUA_MODIFIER_MOTION_NONE)

function item_assault_lua1:GetIntrinsicModifierName()
	return "modifier_assault_lua"
end

------------------------------------------------

modifier_assault_lua = class({})

function modifier_assault_lua:IsHidden()		return true end
function modifier_assault_lua:IsPurgable()		return false end
function modifier_assault_lua:RemoveOnDeath()	return false end

function modifier_assault_lua:OnCreated()
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() end

	if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") and not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
	end
end

function modifier_assault_lua:OnRefresh()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_positive", {})
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_assault_lua_aura_negative", {})
end


function modifier_assault_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_assault_lua:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_assault_lua:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

function modifier_assault_lua:OnDestroy()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua") then
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_assault_lua_aura_negative")
		end
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
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua_aura_positive") then
			self:Destroy()
		end
	end
	self.speed = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
	self.armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
end

function modifier_assault_lua_aura_positive_effect:OnRefresh()
	self:OnCreated()
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
	return self.speed
end

function modifier_assault_lua_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.armor
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
function modifier_assault_lua_aura_negative:AllowIllusionDuplicate() return true end
function modifier_assault_lua_aura_negative:IsHidden() return true end
function modifier_assault_lua_aura_negative:IsPurgable() return false end

function modifier_assault_lua_aura_negative:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
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
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_assault_lua_aura_negative") then
			self:Destroy()
		end
	end
	self.armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
end

function modifier_assault_lua_aura_negative_effect:IsHidden() return false end
function modifier_assault_lua_aura_negative_effect:IsPurgable() return false end
function modifier_assault_lua_aura_negative_effect:IsDebuff() return true end

function modifier_assault_lua_aura_negative_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_assault_lua_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.armor * (-1)
end
