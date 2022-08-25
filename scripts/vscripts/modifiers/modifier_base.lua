LinkLuaModifier( "modifier_base_passive", "modifiers/modifier_base", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_transformation", "modifiers/modifier_base", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hpstack", "modifiers/modifier_base", LUA_MODIFIER_MOTION_NONE )

modifier_base_passive = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
		CheckState = function(self) return 
		{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,

		} end,
})

function modifier_base_passive:OnCreated()
	self:StartIntervalThink(0.03)
end

function modifier_base_passive:OnIntervalThink()
if IsServer() then
	local caster = self:GetCaster()
	local hero = Entities:FindByName( nil, "npc_dota_hero_treant")
	caster:SetAbsOrigin(hero:GetAbsOrigin())
end
end

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
modifier_transformation = class({})

function modifier_transformation:IsHidden()
	return true
end

function modifier_transformation:IsPurgable()
	return false
end

function modifier_transformation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

function modifier_transformation:GetModifierMoveSpeedOverride()
	return 100
end

function modifier_transformation:GetModifierTurnRate_Percentage()
	return 10
end

function modifier_transformation:GetModifierHealthBonus()
	return 9300
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

modifier_hpstack = class({})

function modifier_hpstack:IsHidden()
	return true
end

function modifier_hpstack:IsPurgable()
	return false
end

function modifier_hpstack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

function modifier_hpstack:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_hpstack:OnIntervalThink()
if IsServer() then
	treant_hp_stack = self:GetStackCount()*4000
end
end

function modifier_hpstack:GetModifierHealthBonus()
	return treant_hp_stack
end
