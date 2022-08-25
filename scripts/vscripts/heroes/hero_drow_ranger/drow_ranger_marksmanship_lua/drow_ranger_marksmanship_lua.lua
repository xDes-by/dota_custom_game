drow_ranger_marksmanship_lua = class({})
LinkLuaModifier( "modifier_drow_ranger_marksmanship_lua", "heroes/hero_drow_ranger/drow_ranger_marksmanship_lua/modifier_drow_ranger_marksmanship_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_lua_debuff", "heroes/hero_drow_ranger/drow_ranger_marksmanship_lua/modifier_drow_ranger_marksmanship_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_lua_effect", "heroes/hero_drow_ranger/drow_ranger_marksmanship_lua/modifier_drow_ranger_marksmanship_lua_effect", LUA_MODIFIER_MOTION_NONE )

function drow_ranger_marksmanship_lua:GetIntrinsicModifierName()
	return "modifier_drow_ranger_marksmanship_lua"
end

function drow_ranger_marksmanship_lua:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end

	-- perform attack
	self.split = true
	self.split_procs = data.procs==1
	self:GetCaster():PerformAttack( target, true, true, true, false, false, false, false )
	self.split = false
end