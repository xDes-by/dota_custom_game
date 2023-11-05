leshrac_diabolic_edict_lua = class({})
LinkLuaModifier( "modifier_leshrac_diabolic_edict_lua", "heroes/hero_leshrac/leshrac_diabolic_edict_lua/modifier_leshrac_diabolic_edict_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_permanent_lua", "heroes/hero_leshrac/leshrac_diabolic_edict_lua/modifier_leshrac_diabolic_edict_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_intrinsic_lua", "heroes/hero_leshrac/leshrac_diabolic_edict_lua/modifier_leshrac_diabolic_edict_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

function leshrac_diabolic_edict_lua:GetIntrinsicModifierName()
	return "modifier_leshrac_diabolic_edict_intrinsic_lua"
end
function leshrac_diabolic_edict_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function leshrac_diabolic_edict_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_leshrac_diabolic_edict_lua", -- modifier name
		{ duration = duration } -- kv
	)
	-- caster:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_permanent_lua", {})
end
