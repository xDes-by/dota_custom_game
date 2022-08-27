mars_lil = class({})
LinkLuaModifier( "modifier_mars_lil", "heroes/hero_mars/mars_lil/modifier_mars_lil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_lil_debuff", "heroes/hero_mars/mars_lil/modifier_mars_lil_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_boost", "heroes/hero_mars/modifier_mars_boost", LUA_MODIFIER_MOTION_NONE )

function mars_lil:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect())
    end
end

function mars_lil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- addd buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_mars_lil", -- modifier name
		{ duration = duration } -- kv
	)
	
	local abil =  self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str7")
		if abil ~= nil then
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_mars_boost", -- modifier name
			{ duration = 3 } -- kv
		)
	end
	
	local abil =  self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int11")
		if abil ~= nil then
			local r2 = RandomInt(1,2)
			if r2 == 1 then
				local sound_cast = "DOTA_Item.Refresher.Activate"
				EmitSoundOn( sound_cast, caster )
				self:EndCooldown()
			end
	end	
end