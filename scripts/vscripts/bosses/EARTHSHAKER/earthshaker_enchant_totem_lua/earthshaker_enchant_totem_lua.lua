-- Created by Elfansoer
--------------------------------------------------------------------------------
earthshaker_enchant_totem_lua = class({})
LinkLuaModifier( "modifier_earthshaker_enchant_totem_lua", "bosses/EARTHSHAKER/earthshaker_enchant_totem_lua/modifier_earthshaker_enchant_totem_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_enchant_totem_debuff1_lua", "bosses/EARTHSHAKER/earthshaker_enchant_totem_lua/modifier_earthshaker_enchant_totem_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_enchant_totem_debuff2_lua", "bosses/EARTHSHAKER/earthshaker_enchant_totem_lua/modifier_earthshaker_enchant_totem_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Behavior
function earthshaker_enchant_totem_lua:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT
end
--------------------------------------------------------------------------------
-- Custom KV
function earthshaker_enchant_totem_lua:GetAOERadius()
	return self:GetSpecialValueFor( "aftershock_range" )
end

function earthshaker_enchant_totem_lua:GetCastRange( point, target )
	return self:GetSpecialValueFor( "distance_scepter" )
end

function earthshaker_enchant_totem_lua:GetCastPoint()
	self:GetSpecialValueFor( "scepter_leap_duration" )
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function earthshaker_enchant_totem_lua:CastFilterResultTarget( hTarget )
	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function earthshaker_enchant_totem_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()
	if target==caster then return true end
	-- load data
	local duration = self:GetSpecialValueFor( "scepter_leap_duration" )
	local height = self:GetSpecialValueFor( "scepter_height" )
	local distance = (point - caster:GetOrigin()):Length2D()

	-- add arc modifier
	local arc = caster:AddNewModifier(caster,self,"modifier_generic_arc_lua",
		{target_x = point.x,target_y = point.y,distance = distance,duration = duration,height = height,fix_end = false,isForward = true,})
	arc:SetEndCallback(function()
		if not self.interrupted then return end
		self.interrupted = nil

		-- do normal
		self:OnSpellStart()
		self:UseResources( true, false, false, true)
	end)

	return true
end
function earthshaker_enchant_totem_lua:OnAbilityPhaseInterrupted()
	self.interrupted = true
end
--------------------------------------------------------------------------------
-- Ability Start
function earthshaker_enchant_totem_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_earthshaker_enchant_totem_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- Effects
	local sound_cast = "Hero_EarthShaker.Totem"
	EmitSoundOn( sound_cast, caster )
end