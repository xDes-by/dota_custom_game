ListenToGameEvent('npc_spawned', function(_, keys)
    SendToConsole("dota_hud_healthbars 1")
end, nil)	

ListenToGameEvent("game_end", function(_, keys)
    SendToConsole("dota_hud_healthbars 2")
end, nil)