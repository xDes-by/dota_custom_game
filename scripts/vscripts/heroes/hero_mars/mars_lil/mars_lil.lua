mars_lil = class({})
LinkLuaModifier( "modifier_mars_lil", "heroes/hero_mars/mars_lil/modifier_mars_lil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_lil_debuff", "heroes/hero_mars/mars_lil/modifier_mars_lil_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_boost", "heroes/hero_mars/modifier_mars_boost", LUA_MODIFIER_MOTION_NONE )

function mars_lil:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function mars_lil:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetDuration()

	caster:AddNewModifier(caster, self, "modifier_mars_lil", { duration = duration } )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str7") ~= nil then
		caster:AddNewModifier(caster, self, "modifier_mars_boost", { duration = 3 })
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int11") ~= nil then
		if RandomInt(1,100) <= 50 then
			local sound_cast = "DOTA_Item.Refresher.Activate"
			EmitSoundOn( sound_cast, caster )
			self:EndCooldown()
		end
	end	
end