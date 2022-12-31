local special_keys = {
	var_type = false,
	LinkedSpecialBonus = true,
	LinkedSpecialBonusField = true,
	LinkedSpecialBonusOperation = true,
	DamageTypeTooltip = true,
	CalculateSpellDamageTooltip = true,
	RequiresScepter = true,
	RequiresShard = true,
	levelkey = true,
	ad_linked_abilities = true,
}

local networked_values = {
	AbilityUnitDamageType = true,
	AbilityValues = true,
	AbilityDraftUltScepterAbility = true,
	AbilityDraftUltShardAbility = true,
	MaxLevel = true,
	HasShardUpgrade = true,
	HasScepterUpgrade = true,
}

local convert_to_array = {
	value = true,
	special_bonus_shard = true,
	special_bonus_scepter = true,
}

local merge_into_ability_values = {
	AbilityDuration = true,
	AbilityCooldown = true,
	AbilityManaCost = true,
	AbilityCastRange = true,
	AbilityChannelTime = true,
	AbilityCastPoint = true,
	AbilityCharges = true,
	AbilityChargeRestoreTime = true,
}

local function ConvertAbilitySpecialToValues(specials)
	local values = {}

	for _, special in pairs(specials) do
		local value = {}
		local value_name
		local only_value = true

		for k,v in pairs(special) do
			if special_keys[k] ~= false then
				if special_keys[k] == true then
					value[k] = v
					only_value = false
				else
					value_name = k
					value["value"] = v
				end
			end 
		end

		if only_value then
			value = value.value
		end

		values[value_name] = value
	end

	return values
end

local function ValueToArray(value)
	if not value or value == "" then return nil end

	if type(value) == "number" then
		return { value }
	end

	local arr = string.split(value)

	if #arr == 0 then return nil end

	for k,v in ipairs(arr) do
		arr[k] = tonumber(v) or v
	end

	return arr
end

local function MakeAbilityList()
	local ability_list_kv = LoadKeyValues("scripts/npc/npc_abilities_list.txt")
	local ability_list = {}

	for hero, list in pairs(ability_list_kv) do
		for k,v in pairs(list) do
			if type(v) ~= "table" then
				ability_list[v] = true
			else
				for ability_name, _ in pairs(v) do
					ability_list[ability_name] = true
				end
			end
		end
	end

	local shard_scepter_ability_list = {}

	for ability_name, _ in pairs(ability_list) do
		local shard_ability = GetAbilityKV(ability_name, "AbilityDraftUltShardAbility")
		if shard_ability and shard_ability ~= "" then
			shard_scepter_ability_list[shard_ability] = true
		end

		local scepter_ability = GetAbilityKV(ability_name, "AbilityDraftUltScepterAbility")
		if scepter_ability and scepter_ability ~= "" then
			shard_scepter_ability_list[scepter_ability] = true
		end
	end

	table.merge(ability_list, shard_scepter_ability_list)
	return ability_list
end

function Init()
	local ability_list = MakeAbilityList()

	for ability, _ in pairs(ability_list) do
		local kv = GetAbilityKeyValuesByName(ability)

		if kv.AbilitySpecial then
			local converted_values = ConvertAbilitySpecialToValues(kv.AbilitySpecial)
			
			if kv.AbilityValues then
				table.deepmerge(converted_values, kv.AbilityValues)	
			end

			kv.AbilityValues = converted_values
			kv.AbilitySpecial = nil
		end

		if kv.AbilityValues then
			for value_name, _ in pairs(merge_into_ability_values) do
				if kv[value_name] and not kv.AbilityValues[value_name] then
					kv.AbilityValues[value_name] = kv[value_name]
				end
			end

			local lowercase_ability_values = {}
			for k,v in pairs(kv.AbilityValues) do
				lowercase_ability_values[type(k) == "string" and k:lower() or k] = v
			end
			kv.AbilityValues = lowercase_ability_values

			for k,v in pairs(kv.AbilityValues) do
				if type(v) == "table" then
					for field_name, field_value in pairs(v) do
						if convert_to_array[field_name] and type(field_value) == "string" then
							v[field_name] = ValueToArray(field_value)
						end
					end
				elseif type(v) == "string" then
					kv.AbilityValues[k] = ValueToArray(v)
				end
			end
		end

		kv = table.filter(kv, function(v,k) return networked_values[k] end)
		CustomNetTables:SetTableValue("ability_kv", ability, { json = json.encode(kv)})
	end
end

Init()
