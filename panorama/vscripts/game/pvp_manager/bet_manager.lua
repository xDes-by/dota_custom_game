-- Bet Manager
-- Manages betting, bet payouts, and betting history.
-- Works closely with the RoundManager, Round, and PvpManager classes.

if BetManager == nil then BetManager = class({}) end

function BetManager:Init()

	-- Enfos map has no bet manager
	if Enfos:IsEnfosMode() then return end

	-- Initialize vars
	self.is_betting_open = false

	---@class UnconfirmedBetInfo
	---@field value integer
	---@field wish_team_id integer

	---@type table<PlayerID, UnconfirmedBetInfo>
	self.unconfirmed_bets = {}

	self.confirmed_bet_particles = {}
	self.total_bet_gold = {}
	

	-- Set up listeners
	RegisterCustomEventListener("ConfirmBet", function(keys) BetManager:ConfirmBet(keys) end)
	RegisterCustomEventListener("BetManager:auto_bet_changed", function(keys) BetManager:BetUpdate(keys) end)

	EventDriver:Listen("PvpManager:new_pvp_match_decided", BetManager.OnNewPvpMatch, BetManager)
	EventDriver:Listen("PvpManager:pvp_ended", BetManager.OnPvpEnded, BetManager)
end

-- Fires when the pvp manager tells us there's a new pvp match coming, and sets up betting for it
function BetManager:OnNewPvpMatch(keys)
	local current_round = RoundManager:GetCurrentRound()
	if (not current_round:IsPvpRound()) then return end

	-- Reset vars
	self.confirmed_bet_particles = {}
	self.unconfirmed_bets = {}
	
	-- Calculate base pot for the round
	self.base_round_pot = BET_MANAGER_BASE_POT[GetMapName()] * math.pow(1.02, keys.round_number - 1)
	self.total_round_pot = self.base_round_pot

	-- Set up bet map as [team][player_id] = amount bet
	self.bet_map = {}

	for _, team in pairs(keys.teams) do
		self.bet_map[team] = {}
	end

	self.is_betting_open = true
end

function BetManager:BetUpdate(keys)
	local player_id = keys.PlayerID
	if not player_id then return end

	if type(keys.value) ~= "number" then
		return
	end

	---@type UnconfirmedBetInfo
	local bet_data = {}
	bet_data.value = math.floor(keys.value)
	bet_data.wish_team_id = keys.wish_team_id

	if keys.value > 0 then
		self.unconfirmed_bets[player_id] = bet_data
	else
		self.unconfirmed_bets[player_id] = nil
	end

	BetManager:SendBetToTeammate(player_id, bet_data.value, bet_data.wish_team_id, false)
end

function BetManager:SendBetToTeammate(player_id, bet, bet_team, is_confirmed, max_bet)
	if GetMapName() ~= "duos" then return end

	if not max_bet then
		max_bet = PlayerResource:GetGold(player_id) * 0.5
		max_bet = math.floor(math.max(1, max_bet))
	end

	local player_team = PlayerResource:GetTeam(player_id)
	
	local event = {
		player_id = player_id,
		value = bet,
		wish_team_id = bet_team,
		confirmed = is_confirmed,
		max_bet = max_bet
	}

	CustomGameEventManager:Send_ServerToTeam(player_team, "BetManager:teammate_bet", event)
end

-- Fires when the player tries to confirm a bet via UI
function BetManager:ConfirmBet(keys)
	local player_id = keys.PlayerID

	if (not player_id) then return end

	local player_team = PlayerResource:GetTeam(player_id)

	-- Invalid bet: betting is not open
	if (not self.is_betting_open) then return end

	-- Invalid bet: invalid amount
	if type(keys.value) ~= "number" or math.floor(keys.value) <= 0 then return end

	-- Invalid bet: bet on the wrong team
	if (not self.bet_map[keys.wish_team_id]) then return end

	-- Invalid bet: already bet this round
	if self:GetBet(player_id) then return end

	-- Invalid bet: player cant bet on yourself or duel opponent
	if PvpManager:IsPvpTeamThisRound(player_team) then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local player_gold = PlayerResource:GetGold(player_id)

	if (not hero) or hero:IsNull() then return end

	-- Cap the value to this player's maximum bet
	local max_player_bet = player_gold * 0.5
	max_player_bet = math.floor(math.max(1, max_player_bet))

	-- Make the bet and store it in bet history
	local bet_value = math.min(math.floor(keys.value), max_player_bet)
	hero:SpendGold(bet_value, DOTA_ModifyGold_Unspecified)
	
	local bet_data = {}
	bet_data.player_id = player_id
	bet_data.value = bet_value

	table.insert(self.bet_map[keys.wish_team_id], bet_data)
	self.total_round_pot = self.total_round_pot + bet_value

	self.total_bet_gold[player_id] = self.total_bet_gold[player_id] or 0
	self.total_bet_gold[player_id] = self.total_bet_gold[player_id] + bet_value

	-- Particles and sound
	hero:EmitSound("DOTA_Item.Hand_Of_Midas")
	
	local bet_pfx = ParticleManager:CreateParticle("particles/custom/bet_confirm.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(bet_pfx, 1, Vector(bet_value, 0, 0))
	ParticleManager:ReleaseParticleIndex(bet_pfx)

	-- Create bet target confirmation particle
	local player = PlayerResource:GetPlayer(player_id)

	if (not player) then return end

	for _, target_player_id in pairs(GameMode.team_player_id_map[keys.wish_team_id]) do
		local target_hero = PlayerResource:GetSelectedHeroEntity(target_player_id)

		if target_hero then
			local target_pfx = ParticleManager:CreateParticleForPlayer("particles/bets/confirm_bet_gold.vpcf", PATTACH_OVERHEAD_FOLLOW, target_hero, player)
			table.insert(self.confirmed_bet_particles, target_pfx)
		end
	end

	EventDriver:Dispatch("BetManager:confirmed_bet", {
		original_gold = player_gold,
		bet_value = bet_value,
		target_team = keys.wish_team_id,
		bet_hero = hero,
		bet_player_id = player_id
	})

	self.unconfirmed_bets[player_id] = nil

	BetManager:SendBetToTeammate(player_id, bet_value, keys.wish_team_id, true, max_player_bet)
end

-- Returns the value of the passed player's bet on this round, *only* if they have already confirmed their bet.
function BetManager:GetBet(player_id)
	for _, team in pairs(self.bet_map) do
		for _, bet in pairs(team) do
			if bet.player_id == player_id then
				return bet.value
			end
		end
	end

	return nil
end

-- Stop accepting bets, order them, and calculate payout fractions for each
function BetManager:EvaluateBets()
	if not self.bet_map then return end
	
	for player_id, unconfirmed_bet in pairs(self.unconfirmed_bets) do
		if PLAYER_OPTIONS_AUTO_CONFIRM_BET_ENABLED[player_id] then
			BetManager:ConfirmBet({
				PlayerID = player_id,
				value = unconfirmed_bet.value,
				wish_team_id = unconfirmed_bet.wish_team_id
			})
		end
	end

	self.is_betting_open = false

	for team, bets in pairs(self.bet_map) do
		table.sort(bets, function(a, b) return a.value > b.value end)

		local total_bet_on_team = 0  

		for _, bet_data in pairs(bets) do
			total_bet_on_team = total_bet_on_team + bet_data.value
		end

		for _, bet_data in pairs(bets) do
			bet_data.team_bet_ratio = bet_data.value / total_bet_on_team
		end
	end
end

-- Fires when a pvp match is decided
function BetManager:OnPvpEnded(keys)

	for _, pfx in pairs(self.confirmed_bet_particles) do
		if pfx then
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end

	self.confirmed_bet_particles = {}

	self:PayBets(keys)
end

-- Calculates and pays out bet results after a duel
function BetManager:PayBets(keys)
	local winner_team = keys.winner_team
	local loser_team = keys.loser_team

	-- Build result tables for panorama & calculations
	local pvp_players = {}
	pvp_players[1] = {}
	pvp_players[2] = {}

	local winner_players = {}
	local loser_players = {}

	for _, player_id in pairs(GameMode.team_player_id_map[winner_team]) do
		table.insert(winner_players, player_id)
		table.insert(pvp_players[1], player_id)
	end

	for _, player_id in pairs(GameMode.team_player_id_map[loser_team]) do
		table.insert(loser_players, player_id)
		table.insert(pvp_players[2], player_id)
	end

	-- Calculate results
	local total_bet_on_winner = 0
	local total_bet_on_loser = 0

	if self.bet_map[winner_team] then
		for _, data in ipairs(self.bet_map[winner_team]) do
			total_bet_on_winner = total_bet_on_winner + data.value
		end
	end

	if self.bet_map[loser_team] then
		for _, data in ipairs(self.bet_map[loser_team]) do
			total_bet_on_loser = total_bet_on_loser + data.value
		end
	end

	local winner_bet_fraction = total_bet_on_winner / self.total_round_pot



	-- Calculate and grant pvp winner rewards
	local pvp_winner_reward = math.min(self.total_round_pot * math.max(0.5, 1 - winner_bet_fraction * 2.5), 2.05 * self.base_round_pot + total_bet_on_loser)
	pvp_winner_reward = pvp_winner_reward * (GameMode:IsSoloMap() and 1 or 0.5)
	pvp_winner_reward = math.floor(pvp_winner_reward)

	-- Send barrage with pvp winner data
	local barrage_data = {}
	barrage_data.gold_value = 0

	for _, player_id in pairs(winner_players) do
		local actual_reward = self:RewardWinnerBonus(player_id, pvp_winner_reward, false)
		barrage_data.gold_value = barrage_data.gold_value + actual_reward

		History:AddDuelLine(player_id, {
			teams = pvp_players,
			prize = actual_reward,
		})
	end

	for _, player_id in pairs(loser_players) do
		History:AddDuelLine(player_id, {
			teams = pvp_players,
			prize = 0,
		})
	end

	-- Jackpot! Winner takes all
	if #self.bet_map[winner_team] == 0 then
		if GameMode:IsSoloMap() then
			barrage_data.type = "pvp_win_all_solo"
			barrage_data.playerId = winner_players[1]
		else
			barrage_data.type = "pvp_win_all"
			barrage_data.teamId = winner_team
		end

	-- Regular win
	else
		if GameMode:IsSoloMap() then
			barrage_data.type = "pvp_win_solo"
			barrage_data.playerId = winner_players[1]
		else
			barrage_data.type = "pvp_win"
			barrage_data.teamId = winner_team
		end
	end

	Barrage:FireBullet(barrage_data)
	
	-- Pay out bet winners
	for _, bet_data in pairs(self.bet_map[winner_team]) do
		local player_id = bet_data.player_id
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if not bet_data.team_bet_ratio then bet_data.team_bet_ratio = 1 end
		local bet_winnings = math.floor(self.total_round_pot * math.min(1, 0.4 + winner_bet_fraction * 2.5) * bet_data.team_bet_ratio)

		local bet_profit = self:RewardBetBonus(player_id, bet_data.value, bet_winnings)

		History:AddBetLine(player_id, {
			teams = pvp_players,
			betValue = bet_profit,
			betIsWin = true
		})

		EventDriver:Dispatch("BetManager:won_bet", {
			player_id = player_id,
		})

		ProgressTracker:EventTriggered("CUSTOM_EVENT_BET_WON", {winner = hero, gold = bet_profit})

		local bet_barrage_data = {}
		bet_barrage_data.type = "bet_win"
		bet_barrage_data.playerId = player_id
		bet_barrage_data.gold_value = bet_profit

		Barrage:FireBullet(bet_barrage_data)
	end

	-- Handle bet losers
	for _, bet_data in pairs(self.bet_map[loser_team]) do
		local player_id = bet_data.player_id
		local bet = bet_data.value

		-- Gambler bet refund
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero then 
			local gambler = hero:FindAbilityByName("innate_gambler")
			if gambler then
				local refund_percent = gambler:GetSpecialValueFor("refund_percent") / 100
				local refund_gold = math.min(bet * refund_percent, bet) 

				PlayerResource:ModifyGold(player_id, refund_gold, true, DOTA_ModifyGold_CreepKill)
				GameMode:UpdatePlayerGold(player_id)

				bet = math.round(math.max(bet - refund_gold, 0))
			end
		end

		History:AddBetLine(player_id, {
			teams = pvp_players,
			betValue = bet,
			betIsWin = false
		})

		EventDriver:Dispatch("BetManager:lost_bet", {
			player_id = player_id,
		})
	end
end

function BetManager:CreateLuckyStarsJackpotFx(hero)
	if (not hero) or hero:IsNull() then return end

	local lucky_stars_pfx = ParticleManager:CreateParticle("particles/custom/lucky_stars_victory.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(lucky_stars_pfx, 3, hero:GetAbsOrigin() + Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(lucky_stars_pfx)

	Timers:CreateTimer(2, function()
		EmitGlobalSound("oracle_orac_move_18")
	end)

	return lucky_stars_pfx
end

function BetManager:CreateDuelistVictoryFx(hero)
	-- Still need to finish up effects for this, but just adding in the structure for reference.
	return nil
end

-- Grants a player their duel reward gold in waves
function BetManager:RewardWinnerBonus(player_id, gold, particle_modifier)

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local total_waves = 40
	local gold_per_wave = math.ceil(gold / total_waves)

	if (not hero) or hero:IsNull() then
		RoundManager:GiveGoldToPlayer(player_id, gold, nil, ROUND_MANAGER_GOLD_SOURCE_DUEL)
		return gold
	end

	local first_pfx = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_start_ti6.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControlEnt(first_pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)

	local second_pfx = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_start_ti6_lvl3_rays.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControlEnt(second_pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)

	local third_pfx = false
	if particle_modifier then
		third_pfx = particle_modifier(self, hero)
	end

	local current_wave = 0

	Timers:CreateTimer(function()
		RoundManager:GiveGoldToPlayer(player_id, gold_per_wave, nil, ROUND_MANAGER_GOLD_SOURCE_DUEL)
		current_wave = current_wave + 1

		if current_wave >= total_waves then
			ParticleManager:DestroyParticle(first_pfx, false)
			ParticleManager:DestroyParticle(second_pfx, false)
			if third_pfx then ParticleManager:DestroyParticle(third_pfx, false) end

			ParticleManager:ReleaseParticleIndex(first_pfx)
			ParticleManager:ReleaseParticleIndex(second_pfx)
			if third_pfx then ParticleManager:ReleaseParticleIndex(third_pfx) end
		else
			return 0.15
		end
	end)

	return math.ceil(gold * (1 + 0.01 * hero:GetDuelGoldAmplification()))
end

-- Grants a player their bet reward gold in waves. Returns the bet's net profit, including any bet gold amplification.
function BetManager:RewardBetBonus(player_id, original_bet, full_bet_winnings)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local bet_profit = full_bet_winnings - original_bet
	local total_waves = 40
	local gold_per_wave = math.ceil(bet_profit / total_waves)

	local wave = 0

	RoundManager:GiveGoldToPlayer(player_id, original_bet, nil, ROUND_MANAGER_GOLD_SOURCE_OTHER)

	Timers:CreateTimer(0.15, function()
		RoundManager:GiveGoldToPlayer(player_id, gold_per_wave, nil, ROUND_MANAGER_GOLD_SOURCE_BETS)

		if math.mod(wave, 15) == 0 then
			local bet_gold_pfx = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_spindle_rig.vpcf", PATTACH_OVERHEAD_FOLLOW, hero)
			ParticleManager:ReleaseParticleIndex(bet_gold_pfx)
		end

		wave = wave + 1

		if wave < total_waves then
			return 0.15
		end
	end)

	return math.ceil(bet_profit * (1 + 0.01 * hero:GetBetGoldAmplification()))
end
