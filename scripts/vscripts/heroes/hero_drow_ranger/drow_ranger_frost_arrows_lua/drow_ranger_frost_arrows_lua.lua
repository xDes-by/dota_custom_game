drow_ranger_frost_arrows_lua = class({})
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_lua", "heroes/hero_drow_ranger/drow_ranger_frost_arrows_lua/modifier_drow_ranger_frost_arrows_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )


function drow_ranger_frost_arrows_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function drow_ranger_frost_arrows_lua:GetManaCost(iLevel)
    return 40 + math.min(65000, self:GetCaster():GetIntellect() / 250)
end

function drow_ranger_frost_arrows_lua:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function drow_ranger_frost_arrows_lua:GetProjectileName()
	return "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
end

function drow_ranger_frost_arrows_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "Hero_DrowRanger.FrostArrows"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function drow_ranger_frost_arrows_lua:OnOrbImpact( params )
	local duration = self:GetSpecialValueFor("frost_arrows_duration_tooltip")

	params.target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_drow_ranger_frost_arrows_lua", -- modifier name
		{ duration = duration } -- kv
	)
end