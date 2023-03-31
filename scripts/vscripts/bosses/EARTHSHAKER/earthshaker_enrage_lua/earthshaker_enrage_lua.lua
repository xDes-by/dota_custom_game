earthshaker_enrage_lua = class({})
LinkLuaModifier( "modifier_earthshaker_enrage_lua", "bosses/EARTHSHAKER/earthshaker_enrage_lua/modifier_earthshaker_enrage_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function earthshaker_enrage_lua:OnSpellStart()
	-- get references
	local bonus_duration = self:GetSpecialValueFor("duration")

	-- Purge
	self:GetCaster():Purge(false, true, false, true, false)

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_earthshaker_enrage_lua",
		{ duration = bonus_duration }
	)

	-- play effects
	self:PlayEffects()
end

function earthshaker_enrage_lua:PlayEffects()
	-- get resources
	local sound_cast = "Hero_Ursa.Enrage"

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
