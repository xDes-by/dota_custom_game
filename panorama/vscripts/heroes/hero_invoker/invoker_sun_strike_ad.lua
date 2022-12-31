---@class invoker_sun_strike_ad:CDOTA_Ability_Lua
invoker_sun_strike_ad = class({})

function invoker_sun_strike_ad:SunStrike(position)
	local params = {
		duration = self:GetSpecialValueFor("delay"),
		area_of_effect = self:GetSpecialValueFor("area_of_effect"),
		vision_distance = self:GetSpecialValueFor("vision_distance"),
	 	vision_duration = self:GetSpecialValueFor("vision_duration"),
		damage = self:GetSpecialValueFor("damage"),
	}

	CreateModifierThinker(self:GetCaster(), self, "modifier_invoker_sun_strike", params, position, self:GetTeam(), false)
end

function invoker_sun_strike_ad:CastFilterResultTarget(target)
	if target == self:GetCaster() then return UF_SUCCESS end
end

function invoker_sun_strike_ad:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end

	return self.BaseClass.GetBehavior(self)
end

function invoker_sun_strike_ad:GetCooldown(level)
	local is_cataclysm = IsServer() and self:GetCaster() == self:GetCursorTarget()

	if is_cataclysm then 
		return self:GetSpecialValueFor("cataclysm_cooldown")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function invoker_sun_strike_ad:OnSpellStart()
	local position = self:GetCursorPosition()

	local is_cataclysm = self:GetCaster() == self:GetCursorTarget()

	if is_cataclysm then
		local min_range = self:GetSpecialValueFor("cataclysm_min_range")
		local max_range = self:GetSpecialValueFor("cataclysm_max_range")

		local targets = FindUnitsInRadius(self:GetTeam(), 
			position, 
			nil, 
			self:GetCastRange(position, nil), 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false)

		for _, unit in pairs(targets) do
			local origin = unit:GetAbsOrigin()

			self:SunStrike(origin + RandomVector(RandomInt(min_range, max_range)))
			self:SunStrike(origin + RandomVector(RandomInt(min_range, max_range)))
		end
	else
		self:SunStrike(position)
	end

end
