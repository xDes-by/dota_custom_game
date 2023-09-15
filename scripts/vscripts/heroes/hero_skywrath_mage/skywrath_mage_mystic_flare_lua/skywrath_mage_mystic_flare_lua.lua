skywrath_mage_mystic_flare_lua = class({})
LinkLuaModifier( "modifier_skywrath_mage_mystic_flare_lua_thinker", "heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_lua/modifier_skywrath_mage_mystic_flare_lua_thinker", LUA_MODIFIER_MOTION_NONE )

function skywrath_mage_mystic_flare_lua:GetManaCost(iLevel)	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int10") ~= nil then 
		return 75 + math.min(65000, self:GetCaster():GetIntellect() / 60)
	end
	return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function skywrath_mage_mystic_flare_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function skywrath_mage_mystic_flare_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	if _G.mystictarget ~= nil then
		point = _G.mystictarget:GetAbsOrigin()
	else
	 	point = self:GetCursorPosition()
	end

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_skywrath_mage_mystic_flare_lua_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	-- play effects
	local sound_cast = "Hero_SkywrathMage.MysticFlare.Cast"
	EmitSoundOn( sound_cast, caster )

	-- scepter effect
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int11")	
	if abil ~= nil then 
		local scepter_radius = self:GetSpecialValueFor( "scepter_radius" )
		
		-- find nearby enemies
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			scepter_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for i =1, 3 do
		enemy = enemies[ RandomInt( 1, #enemies ) ]
			CreateModifierThinker(
				caster, -- player source
				self, -- ability source
				"modifier_skywrath_mage_mystic_flare_lua_thinker", -- modifier name
				{ duration = duration }, -- kv
				enemy:GetOrigin(),
				caster:GetTeamNumber(),
				false
			)
		end
	end
	_G.mystictarget = nil
end