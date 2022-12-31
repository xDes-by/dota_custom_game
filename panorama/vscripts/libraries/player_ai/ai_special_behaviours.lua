AI_SpecialBehaviours = {}

-- following functins alter ability behaviours on per-ability basis
-- returning true means allowing cast/scan to include and process ability/item
-- returning false excludes ability from being processed by AI

-- special behaviour running on ability cast
-- allows cast interruption, changing target, etc
AI_SpecialBehaviours.on_cast = {
	mars_bulwark = function(hero, ...) return hero:HasScepter() end,
} 


-- special behaviour running on ability list scan
-- allows to blacklist abilities, change 
AI_SpecialBehaviours.on_scan = {
	bane_nightmare = false,
}



function AI_SpecialBehaviours:Scan(hero, ability, ability_name)
	local special_scan_behaviour = AI_SpecialBehaviours.on_scan[ability_name]
	if special_scan_behaviour == nil then return true end

	if type(special_scan_behaviour) == "boolean" then return special_scan_behaviour end
	
	return special_scan_behaviour(hero, ability, ability_name)
end


function AI_SpecialBehaviours:Cast(hero, ability, ability_name, ability_data, filter_result, unit_distance)
	local special_cast_behaviour = AI_SpecialBehaviours.on_cast[ability_name]
	if special_cast_behaviour == nil then return true end

	if type(special_cast_behaviour) == "boolean" then return special_cast_behaviour end
	
	return special_cast_behaviour(hero, ability, ability_name, ability_data, filter_result, unit_distance)
end
