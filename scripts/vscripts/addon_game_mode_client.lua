ListenToGameEvent('npc_spawned', function(_, keys)
    SendToConsole("dota_hud_healthbars 1")
    SendToConsole("dota_health_bar_shields 0")
end, nil)	

ListenToGameEvent("game_end", function(_, keys)
    SendToConsole("dota_hud_healthbars 2")
    SendToConsole("dota_health_bar_shields 1")
end, nil)