
LinkLuaModifier("modifier_other", "modifiers/modifier_other.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zuus_nimbus_intrinsic", "heroes/hero_zuus/zuus_nimbus/modifier_zuus_nimbus_intrinsic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zuus_nimbus", "heroes/hero_zuus/zuus_nimbus/modifier_zuus_nimbus.lua", LUA_MODIFIER_MOTION_NONE )

zuus_nimbus = zuus_nimbus or class({})

function zuus_nimbus:IsInnateAbility() return true end

function zuus_nimbus:GetAOERadius()
	return self:GetSpecialValueFor("cloud_radius")
end
function zuus_nimbus:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function zuus_nimbus:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("cast_range")
end

function zuus_nimbus:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end

function zuus_nimbus:IsInnateAbility() return true end

function zuus_nimbus:GetIntrinsicModifierName()
	return "modifier_zuus_nimbus_intrinsic"
end

function zuus_nimbus:OnSpellStart()
	local target_point 			= self:GetCursorPosition()
	local caster 				= self:GetCaster()
	
	local cloud_interval 	= self:GetSpecialValueFor("cloud_interval")
	local cloud_duration 	= self:GetSpecialValueFor("cloud_duration")
	local cloud_radius 		= self:GetSpecialValueFor("cloud_radius")
	local level				= self:GetLevel()
	self.interval = 1
	EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.Cloud.Cast", caster)
	
	local zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(target_point.x, target_point.y, 450), false, caster, nil, caster:GetTeam())
	zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_other", {})
	zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})
	CreateModifierThinker( caster, self, "modifier_zuus_nimbus", {
		duration = cloud_duration,
		radius = cloud_radius,
	}, target_point, caster:GetTeamNumber(), false )
	AddFOWViewer(caster:GetTeamNumber(), target_point, cloud_radius, duration, false)
end