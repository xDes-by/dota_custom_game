function _DateWeight(date)
	local dateInNumber = date:gsub("[-|:| ]", "")
	return tonumber(dateInNumber)
end

function _DateSorting(a, b)
	if _DateWeight(a["date"]) > _DateWeight(b["date"]) then
		return true
	end
	return false
end

function GameMode:GetPatchNotesInfo(data)
	local player_id = data.PlayerID
	local language = _G.tPlayersLanguages[player_id]

	if not language then
		Timers:CreateTimer(1, function() GameMode:GetPatchNotesInfo(data) end)
		return 
	end

	if language == "schinese" or  language == "tchinese" then
		language = "chinese"
	elseif language ~= "russian"then
		language = "english"
	end

	if not WebApi.patch_notes then
		Timers:CreateTimer(1, function() GameMode:GetPatchNotesInfo(data) end)
		return
	end
	
	local sortedPatchNotes = {}
	for date, patchData in pairs(WebApi.patch_notes) do
		table.insert(sortedPatchNotes, {
			date = date,
			data = patchData[language] or patchData["english"],
		})
	end
	table.sort(sortedPatchNotes, _DateSorting)

	local player = PlayerResource:GetPlayer(player_id)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "patch_notes:create_patch_notes", sortedPatchNotes)
	end
end
