sven_armor = class({})
LinkLuaModifier( "modifier_sven_armor", "heroes/hero_sven/sven_armor/sven_armor.lua", LUA_MODIFIER_MOTION_NONE )

function sven_armor:GetIntrinsicModifierName()
	return "modifier_sven_armor"
end

------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_sven_armor = class({})

--------------------------------------------------------------------------------
function modifier_sven_armor:IsHidden()
	return self:GetStackCount()==0
end

function modifier_sven_armor:IsPurgable()
	return false
end

function modifier_sven_armor:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_sven_armor:RemoveOnDeath()
	return false
end

function modifier_sven_armor:DestroyOnExpire()
	return false
end

function modifier_sven_armor:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.creep_bonus = self:GetAbility():GetSpecialValueFor( "bonus_armor_per_hero" )
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_speed_per_hero" )

	if not IsServer() then return end
	
	local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	self:SetStackCount( #hEnemies )
	
	self:StartIntervalThink(0.1)
end

function modifier_sven_armor:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.creep_bonus = self:GetAbility():GetSpecialValueFor( "bonus_armor_per_hero" )
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_speed_per_hero" )

	if not IsServer() then return end
	
	local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	self:SetStackCount( #hEnemies )
end


function modifier_sven_armor:OnIntervalThink()
	self:OnRefresh()
end

function modifier_sven_armor:OnRemoved()
end

function modifier_sven_armor:OnDestroy()
end

function modifier_sven_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end


function modifier_sven_armor:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str11")
	if abil ~= nil then 
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_armor_per_hero") * 2
	end
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_armor_per_hero")
end

function modifier_sven_armor:GetModifierMoveSpeedBonus_Constant()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str11")
	if abil ~= nil then 
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_speed_per_hero") * 2
	end
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_speed_per_hero")
end

function modifier_sven_armor:GetModifierAttackSpeedBonus_Constant()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_agi11")
	if abil ~= nil then 
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_armor_per_hero") * 10
	end
	return 0
end

function modifier_sven_armor:GetModifierConstantHealthRegen()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str6")
	if abil ~= nil then 
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_speed_per_hero") * 5
	end
	return 0
end

function modifier_sven_armor:GetModifierMagicalResistanceBonus()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str9")
	if abil ~= nil then 
	return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("bonus_armor_per_hero")
	end
	return 0
end