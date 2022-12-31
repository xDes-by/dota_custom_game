local current_xp_level = 1

local round_stats = {}

round_stats.spawn_count = {}
round_stats.health = {}
round_stats.damage = {}
round_stats.bat = {}
round_stats.as = {}
round_stats.armor = {}
round_stats.damage_reduction = {}
round_stats.xp_bounty = {}
round_stats.gold_bounty = {}

round_stats.spawn_count[1] = 10
round_stats.health[1] = 300
round_stats.damage[1] = 15
round_stats.bat[1] = 1.5
round_stats.as[1] = 0
round_stats.armor[1] = 0
round_stats.damage_reduction[1] = 0

round_stats.gold_bounty[1] = 500
round_stats.xp_bounty[1] = math.ceil(xpTable[current_xp_level])

for round = 2, 50 do
	round_stats.spawn_count[round] = 10
	round_stats.health[round] = math.floor((1.08 + 0.0035 * (50 - round)) * (round_stats.health[round - 1] + 30))
	round_stats.damage[round] = math.floor((1.085 + 0.0035 * (50 - round)) * (round_stats.damage[round - 1] + 0.75))
	round_stats.bat[round] = 1.5
	round_stats.as[round] = 4 * (round - 1)
	round_stats.armor[round] = 0.6 * (round - 1)
	round_stats.damage_reduction[round] = 0

	round_stats.gold_bounty[round] = 450 + 75 * round + 50 * (1 + 0.1 * round) ^ 2
	round_stats.xp_bounty[round] = math.ceil(xpTable[current_xp_level + math.max(1, math.floor(round / 10))] - xpTable[current_xp_level])

	current_xp_level = current_xp_level + math.max(1, math.floor(round / 10))
end

for round = 51, 300 do
	round_stats.spawn_count[round] = 10
	round_stats.health[round] = math.floor(1.08 * round_stats.health[round - 1])
	round_stats.damage[round] = math.floor(1.08 * round_stats.damage[round - 1])
	round_stats.bat[round] = 1.5
	round_stats.as[round] = 4 * (round - 1)
	round_stats.armor[round] = 0.6 * (round - 1)
	round_stats.damage_reduction[round] = 100 * (1 - (1 - 0.01 * round_stats.damage_reduction[round - 1]) * 0.98)

	round_stats.gold_bounty[round] = 6000
	round_stats.xp_bounty[round] = math.ceil(xpTable[math.min(1000, current_xp_level + 5)] - xpTable[current_xp_level])

	current_xp_level = math.min(1000, current_xp_level + 5)
end

return round_stats
