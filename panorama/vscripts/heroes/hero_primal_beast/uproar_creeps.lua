LinkLuaModifier("modifier_primal_beast_uproar_creeps", "heroes/hero_primal_beast/modifier_primal_beast_uproar_creeps", LUA_MODIFIER_MOTION_NONE)

EventDriver:Listen("HeroBuilder:ability_added", function(event) 
	if event.ability_name == "primal_beast_uproar" then
		event.hero:AddNewModifier(event.hero, event.ability, "modifier_primal_beast_uproar_creeps", nil)
	end
end)
