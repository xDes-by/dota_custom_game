naga_siren_mirror_image_lua = class({})
LinkLuaModifier( "modifier_naga_siren_mirror_image_lua", "heroes/hero_naga/naga_siren_mirror_image_lua/modifier_naga_siren_mirror_image_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_summon_timer", "heroes/generic/modifier_generic_summon_timer", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
naga_siren_mirror_image_lua.illusions = {}
function naga_siren_mirror_image_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local delay = self:GetSpecialValueFor( "invuln_duration" )

	-- stop, dodge & dispel
	caster:Stop()
	ProjectileManager:ProjectileDodge( caster )
	caster:Purge( false, true, false, false, false )

	-- add delay modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_naga_siren_mirror_image_lua", -- modifier name
		{ duration = delay } -- kv
	)

	-- play effects
	local sound_cast = "Hero_NagaSiren.MirrorImage"
	EmitSoundOn( sound_cast, caster )
end