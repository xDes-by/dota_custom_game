Reorder = Reorder or class({})
REORDER_AFTER = 1
REORDER_BEFORE = 2

function Reorder:Init()
    RegisterCustomEventListener("reorder:complete", 		 function(event) Reorder:Complete(event) end)
    RegisterCustomEventListener("reorder:toggle_serverside", function(event) Reorder:ToggleServerside(event) end)
end

function Reorder:Complete(event)
	if not event.PlayerID then return end
	if not event.reorder_type then return end
	if not event.moved_ability then return end
	if not event.ref_ability then return end
	if event.moved_ability == event.ref_ability then return end

	Reorder:_Complete(event.PlayerID, event.reorder_entity, event.reorder_type, event.moved_ability, event.ref_ability)
end

function Reorder:_Complete(player_id, reorder_entity, reorder_type, moved_name, ref_name)
    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    if not hero or hero:IsNull() then return end

	local reorder_entity = EntIndexToHScript(reorder_entity)
	if reorder_entity:GetPlayerOwner() ~= hero:GetPlayerOwner() then return end

    local moved_ability = reorder_entity:FindAbilityByName(moved_name)
    local ref_ability = reorder_entity:FindAbilityByName(ref_name)
    if not moved_ability or not ref_ability then return end
    if moved_ability:IsHidden() then return end

    local start_index = moved_ability:GetAbilityIndex()
    local end_index = ref_ability:GetAbilityIndex()
    -- get increment value as signed 1
    local increment = (end_index - start_index) / math.abs(end_index - start_index)

    if reorder_type == REORDER_BEFORE then
        end_index = end_index - 1
    elseif reorder_type == REORDER_AFTER then
        end_index = end_index + 1
    else
        return
    end

    if not start_index or not end_index then return end

	local function GetNextAbility(start)
		for i = start, end_index, increment do
			local next_candidate = reorder_entity:GetAbilityByIndex(i)
			if next_candidate
			and not next_candidate:IsNull()
			and not next_candidate.placeholder
			and not next_candidate.isCosmeticAbility
			and not next_candidate:IsHidden()
			and not string.find(next_candidate:GetAbilityName(), "special_bonus") then
				return next_candidate
			end
		end
	end


    for i = start_index, end_index, increment do
        local next_ability = GetNextAbility(i+increment)
        if next_ability and not next_ability:IsHidden() then
            local next_name = next_ability:GetAbilityName()
            --print("Swap iteration " .. i .. " next: ", next_ability:GetAbilityName())
            reorder_entity:SwapAbilities(moved_name, next_name, true, true)
            if next_name == ref_name then break end
        end
    end
    HeroBuilder:RefreshAbilityOrder(player_id)
end

function Reorder:ToggleServerside(event)
	if not event.PlayerID then return end
	if not event.state then return end
	
	Reorder:_ToggleServerside(event.PlayerID, event.state)
end

function Reorder:_ToggleServerside(player_id, state)
    HeroBuilder.toggled_reorder[player_id] = toboolean(state)
end


Reorder:Init()
