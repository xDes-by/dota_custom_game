STATE_PASSIVE = -1
STATE_SOLO = 0
STATE_DUOS = 1
STATE_ABANDONED = 2
STATE_SENTIENT = 3

AI_ABILITY_TYPE_PASSIVE = 0
AI_ABILITY_TYPE_ACTIVE = 1
AI_ABILITY_TYPE_SUMMON = 2

-- compensation items to be sold automatically
COMPENSATION_ITEMS = {
	item_relearn_book_lua = 1,
	item_comeback_gift = 1,
	item_summon_book_lua = 1,
}

-- items which will be used only in duels (adding abilities here also work despite the name)
DUEL_ONLY_ITEMS = {
	item_sphere = 1,
	item_lotus_orb = 1,
	item_black_king_bar = 1,
	item_refresher = 1,
	item_ethereal_blade = 1,
}

UNCASTABLE_ITEMS = {
	item_moon_shard = 1,
	item_book_of_rekindling = 1,
	item_summon_book_lua = 1,
}

-- level at which ai can level any talents
TALENTS_FREE_LEVEL = 30 

BET_MAX_EXPECTED_DIFFERENCE = 10000
CONST_BOOK_GOLD_COST = 5000
CONST_PARAGON_BOOK_GOLD_COST = 6000

-- leave at least 2000 gold to bet
CONST_HOLD_GOLD = 2000
