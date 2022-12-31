ErrorTracking = ErrorTracking or {}
ErrorTracking.collected_errors = ErrorTracking.collected_errors or {}

if not IsInToolsMode() then
	debug.oldTraceback = debug.oldTraceback or debug.traceback
	debug.traceback = function(...)
		local stack = debug.oldTraceback(...)
		ErrorTracking.Collect(stack)

		for player_id = 0, 23 do
			if PlayerResource:IsValidPlayerID(player_id) and Supporters:IsDeveloper(player_id) then
				local player = PlayerResource:GetPlayer(player_id)
				if player then
					CustomGameEventManager:Send_ServerToPlayer(player, "server_print", { message = stack })
				end
			end
		end

		return stack
	end
end

function ErrorTracking.Collect(stack)
	stack = stack:gsub(": at 0x%x+", ": at 0x")
	ErrorTracking.collected_errors[stack] = (ErrorTracking.collected_errors[stack] or 0) + 1
end

local function printTryError(...)
	local stack = debug.traceback(...)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("emitError"), function() error(stack, 0) end, 0)
	return stack
end

local handleTryError = IsInToolsMode() and printTryError or debug.traceback
function ErrorTracking.Try(callback, ...)
	return xpcall(callback, handleTryError, ...)
end

Timers:CreateTimer({
	useGameTime = false,
	callback = function()
		if next(ErrorTracking.collected_errors) ~= nil then
			WebApi:Send("match/script-errors", {
				matchId = tonumber(tostring(GameRules:Script_GetMatchID())),
				errors = ErrorTracking.collected_errors,
			})
			ErrorTracking.collected_errors = {}
		end
		return 60
	end
})
