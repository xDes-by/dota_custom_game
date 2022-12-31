LinkLuaModifier("modifier_auto_attack",					"libraries/modifiers/modifier_auto_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_hidden_caster_dummy",			"libraries/modifiers/modifier_hidden_caster_dummy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_out_from_vision",				"libraries/modifiers/modifier_out_from_vision", LUA_MODIFIER_MOTION_VERTICAL )
LinkLuaModifier("modifier_silence_mute",				"libraries/modifiers/modifier_silence_mute", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invuln",						"libraries/modifiers/modifier_invuln", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_spell_amplify_controller",	"libraries/modifiers/modifier_spell_amplify_controller", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_damage_controller",			"libraries/modifiers/modifier_damage_controller", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_special_values_handler",		"libraries/modifiers/modifier_special_values_handler", LUA_MODIFIER_MOTION_NONE )

_G.DOTA_DAMAGE_FLAG_MASTERY_NUMB = 1073741824

-- game states
GAME_STATE_INITIALIZATION 	= 0
GAME_STATE_BEFORE_ROUND 	= 1
GAME_STATE_ROUND_STARTED 	= 2
GAME_STATE_ROUND_ENDED 		= 3

GAME_STATE_ENFOS_PVE 		= 11
GAME_STATE_ENFOS_PVP_SINGLE = 12
GAME_STATE_ENFOS_PVP_TEAM 	= 13

-- team states
TEAM_STATE_INACTIVE			= 0
TEAM_STATE_ON_BASE 			= 1
TEAM_STATE_FIGHTING_CREEPS 	= 2
TEAM_STATE_DUELING 			= 3
TEAM_STATE_DEFEATED 		= 4

-- player states
PLAYER_STATE_INACTIVE	 		= 0
PLAYER_STATE_NO_HERO	 		= 1
PLAYER_STATE_ON_BASE 			= 2
PLAYER_STATE_FIGHTING_CREEPS 	= 3
PLAYER_STATE_DUELING 			= 4
PLAYER_STATE_ENFOS_SINGLE_PVP	= 5
PLAYER_STATE_ENFOS_GROUP_PVP	= 6
--PLAYER_STATE_ABANDONED 			= 7

-- game startup options
GAME_OPTION_ACTIVATE_BOTS 			= false
GAME_OPTION_IMMORTAL_BOTS 			= false
GAME_OPTION_BENCHMARK_MODE 			= false
GAME_OPTION_EARLY_BENCHMARK_MODE 	= false
GAME_OPTION_LATE_BENCHMARK_MODE 	= false
GAME_OPTION_EXTENDED_PRINT_DEBUG 	= false

-- Max pause time in scored games
PAUSE_TIME_MAX = 60 * 10

-- gamemode state functions
function GameMode:GetModeState()
	return GameMode.state or GAME_STATE_INITIALIZATION
end

function GameMode:SetModeState(state)
	GameMode.state = state
end

function GameMode:HasGameStarted()
	return self:GetModeState() > GAME_STATE_INITIALIZATION
end

function GameMode:IsInPreparationPhase()
	return self:GetModeState() == GAME_STATE_BEFORE_ROUND
end



-- team state functions
function GameMode:GetTeamState(team_number)
	return GameMode.teams_states[team_number] or TEAM_STATE_INACTIVE
end

function GameMode:SetTeamState(team_number, state)
	GameMode.teams_states[team_number] = state
end

function GameMode:IsTeamActive(team_number)
	return self:GetTeamState(team_number) > TEAM_STATE_INACTIVE
end

function GameMode:IsTeamAlive(team_number)
	return (self:GetTeamState(team_number) > TEAM_STATE_INACTIVE and self:GetTeamState(team_number) < TEAM_STATE_DEFEATED) 
end

function GameMode:IsTeamInFountain(team_number)
	return self:GetTeamState(team_number) == TEAM_STATE_ON_BASE and not Enfos:IsEnfosMode()
end

function GameMode:IsTeamFightingCreeps(team_number)
	return self:GetTeamState(team_number) == TEAM_STATE_FIGHTING_CREEPS
end

function GameMode:IsTeamDueling(team_number)
	return self:GetTeamState(team_number) == TEAM_STATE_DUELING
end

function GameMode:IsTeamFighting(team_number)
	if Enfos:IsEnfosMode() then return true end
	return (self:GetTeamState(team_number) > TEAM_STATE_ON_BASE and self:GetTeamState(team_number) < TEAM_STATE_DEFEATED) 
end

function GameMode:IsTeamDefeated(team_number)
	return self:GetTeamState(team_number) >= TEAM_STATE_DEFEATED
end



-- Player state functions
function GameMode:GetPlayerState(player_id)
	return GameMode.players_states[player_id] or PLAYER_STATE_INACTIVE
end

function GameMode:SetPlayerState(player_id, state)
	GameMode.players_states[player_id] = state
end

function GameMode:IsPlayerActive(player_id)
	return self:GetPlayerState(player_id) > PLAYER_STATE_INACTIVE
end

function GameMode:HasPlayerSelectedHero(player_id)
	return self:GetPlayerState(player_id) > PLAYER_STATE_NO_HERO
end

function GameMode:IsPlayerInFountain(player_id)
	return self:GetPlayerState(player_id) == PLAYER_STATE_ON_BASE
end

function GameMode:IsPlayerFightingCreeps(player_id)
	return self:GetPlayerState(player_id) == PLAYER_STATE_FIGHTING_CREEPS
end

function GameMode:IsPlayerDueling(player_id)
	local state = GameMode:GetPlayerState(player_id)
	return state == PLAYER_STATE_DUELING or state == PLAYER_STATE_ENFOS_SINGLE_PVP or state == PLAYER_STATE_ENFOS_GROUP_PVP
end

function GameMode:SetPlayerAbandoned(player_id, state)
	self.players_abandoned[player_id] = state
end

function GameMode:HasPlayerAbandoned(player_id)
	return self.players_abandoned[player_id]
end

function GameMode:IsTournamentMode()
	return GameMode.is_tournament_mode_enabled
end
