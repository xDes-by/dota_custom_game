sand_king_sand_storm_lua = class({})
LinkLuaModifier( "modifier_sand_king_sand_storm_lua", "heroes/hero_sand/sand_storm/modifier_sand_king_sand_storm_lua", LUA_MODIFIER_MOTION_NONE )

function sand_king_sand_storm_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function sand_king_sand_storm_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
		local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sand_king_sand_storm_lua", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = "Ability.SandKing_SandStorm.start"
	EmitSoundOn( sound_cast, caster )
end
