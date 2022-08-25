function add_split(kv)
		local tower = Entities:FindByName( nil, "npc_dota_custom_tower")
		if tower ~= nil then
		tower:AddAbility("wisp_split"):SetLevel(1)
		end
		
		local tower2 = Entities:FindByName( nil, "npc_dota_custom_tower2")
		if tower2 ~= nil then
		tower2:AddAbility("wisp_split"):SetLevel(1)
		end
		
		local tower3 = Entities:FindByName( nil, "npc_dota_custom_tower3")
		if tower3 ~= nil then
		tower3:AddAbility("wisp_split"):SetLevel(1)
		end
end