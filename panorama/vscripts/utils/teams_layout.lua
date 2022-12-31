teams_layout = {
	["ffa"] = {
		player_count = 1,
		max_fortune_rank = 5,
		teamlist = {
			DOTA_TEAM_GOODGUYS,
			DOTA_TEAM_BADGUYS,
			DOTA_TEAM_CUSTOM_1,
			DOTA_TEAM_CUSTOM_2,
			DOTA_TEAM_CUSTOM_3,
			DOTA_TEAM_CUSTOM_4,
			DOTA_TEAM_CUSTOM_5,
			DOTA_TEAM_CUSTOM_6,
			DOTA_TEAM_CUSTOM_7,
			DOTA_TEAM_CUSTOM_8,
		},
		rating_delta = {
			[1] = 35,
			[2] = 30,
			[3] = 25,
			[4] = 15,
			[5] = 5,
			[6] = -5,
			[7] = -15,
			[8] = -20,
			[9] = -25,
			[10] = -30,
		},
		location_offsets = {
			-- none, as player is single in his arena
		}
	},
	["duos"] = {
		player_count = 2,
		max_fortune_rank = 4,
		teamlist = {
			DOTA_TEAM_GOODGUYS,
			DOTA_TEAM_BADGUYS,
			DOTA_TEAM_CUSTOM_1,
			DOTA_TEAM_CUSTOM_2,
			DOTA_TEAM_CUSTOM_3,
			DOTA_TEAM_CUSTOM_4,
		},
		rating_delta = {
			[1] = 35,
			[2] = 21,
			[3] = 7,
			[4] = -4,
			[5] = -18,
			[6] = -32,
		},
		location_offsets = {
			Vector(0, -100, 0),
			Vector(0, 100, 0),
		}
	},
	["squads"] = {
		player_count = 4,
		max_fortune_rank = 2,
		teamlist = {
			DOTA_TEAM_GOODGUYS,
			DOTA_TEAM_BADGUYS,
			DOTA_TEAM_CUSTOM_1,
			DOTA_TEAM_CUSTOM_2,
		},
		rating_delta = {
			[1] = 35,
			[2] = 15,
			[3] = -10,
			[4] = -30,
		},
		location_offsets = {
			Vector(0, -100, 0),
			Vector(0, 100, 0),
			Vector(0, 300, 0),
			Vector(0, -300, 0),
		}
	},
	["enfos"] = {
		player_count = 5,
		max_fortune_rank = 1,
		teamlist = {
			DOTA_TEAM_GOODGUYS,
			DOTA_TEAM_BADGUYS,
		},
		rating_delta = {
			[1] = 35,
			[2] = -32,
		},
		location_offsets = {
			Vector(0, -300, 0),
			Vector(0, -150, 0),
			Vector(0, 0, 0),
			Vector(0, 150, 0),
			Vector(0, 300, 0),
		}
	},
	["demo"] = {
		player_count = 1,
		max_fortune_rank = 1,
		teamlist = {
			DOTA_TEAM_GOODGUYS,
			DOTA_TEAM_BADGUYS,
			DOTA_TEAM_CUSTOM_1,
			DOTA_TEAM_CUSTOM_2,
			DOTA_TEAM_CUSTOM_3,
			DOTA_TEAM_CUSTOM_4,
			DOTA_TEAM_CUSTOM_5,
			DOTA_TEAM_CUSTOM_6,
			DOTA_TEAM_CUSTOM_7,
			DOTA_TEAM_CUSTOM_8,
		},
		rating_delta = {
			[1] = 0,
		},
		location_offsets = {
			-- none, as player is single in his arena
		}
	},


}

return teams_layout
