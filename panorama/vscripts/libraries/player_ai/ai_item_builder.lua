AI_ItemBuilder = AI_ItemBuilder or class({})

function AI_ItemBuilder:Init()
	self.builds_kv = LoadKeyValues("scripts/kv/ai_build_items.kv")

	for build_name, values in pairs(self.builds_kv) do
		for i, item_name in pairs(values["Items"]) do
			values["Items"][i] = nil
			values["Items"][tonumber(i)] = item_name
		end
	end
end


function AI_ItemBuilder:GetBuildQueue(hero, build_name)
	local build_queue = {}
	local item_build = table.shuffle(self.builds_kv[build_name]["Items"])

	for i, item_name in ipairs(item_build) do
		local enabled = true
		-- disable devastator for ranged and boomstick for melee
		if item_name == "item_devastator" and hero:IsRangedAttacker() then enabled = false end
		if item_name == "item_ranged_cleave_2" and not hero:IsRangedAttacker() then enabled = false end
		if item_name == "item_aghanims_shard" and hero:HasShard() then enabled = false end
		if item_name == "item_ultimate_scepter_2" and hero:HasScepter() then enabled = false end
		if hero:HasItemInInventory(item_name) then enabled = false end
		
		if enabled then
			build_queue[item_name] = self:GetItemComponents(item_name)
		end
	end
	return build_queue
end


function AI_ItemBuilder:GetItemComponents(item_name)
	local components = {}
	local recipe_name = string.gsub(item_name, "item_", "item_recipe_")
	local recipe_kv = GetItemKV(recipe_name)

	if not recipe_kv then
		local itemCost = tonumber(GetItemKV(item_name, "ItemCost"))
		if itemCost and itemCost > 0 then 
			return { item_name } 
		else
			return components
		end
	end

	local item_requirements = recipe_kv["ItemRequirements"]["01"]

	local item_components = string.split(item_requirements, ";")
	for i, component in pairs(item_components) do
		table.extend(components, self:GetItemComponents(string.gsub(component, "*", "")))
	end

	local recipe_cost = tonumber(recipe_kv["ItemCost"])
	if recipe_cost and recipe_cost > 0 then
		table.insert(components, recipe_name)
	end

	return components
end


function AI_ItemBuilder:GetNextBookName(build_name)
	local val, key = table.random(self.builds_kv[build_name]["Books"])
	return key
end


function AI_ItemBuilder:SelectInnate(build_name, selection)
	print("selecting innate for build", build_name)

	for i, innate_name in pairs(selection) do
		if self.builds_kv[build_name]["Innates"][innate_name] then return innate_name end
	end

	return table.random(selection)
end


function AI_ItemBuilder:GetNextMastery(build_name, used_masteries)
	local copy = table.shallowcopy(self.builds_kv[build_name]["Masteries"])
	table.exclude_keys(copy, used_masteries)
	local val, key = table.random(copy)
	return key
end


AI_ItemBuilder:Init()
