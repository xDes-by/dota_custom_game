LinkLuaModifier("modifier_omniknight_purification_cooldown_fix", "heroes/hero_omniknight/modifier_omniknight_purification_cooldown_fix", LUA_MODIFIER_MOTION_NONE )

EventDriver:Listen("HeroBuilder:ability_added", function(event) 
	if event.ability_name == "frostivus2018_omniknight_purification" then
		event.hero:AddNewModifier(event.hero, nil, "modifier_omniknight_purification_cooldown_fix", nil)
	end
end)