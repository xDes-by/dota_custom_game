RESPAWN_TIME = 5

point_mines = {"mines_spawn_1","mines_spawn_2","mines_spawn_3","mines_spawn_4","mines_spawn_5","mines_spawn_6","mines_spawn_7","mines_spawn_8"}

function respawncreeps (keys )
	if _G.Activate_belka == false then
		local caster = keys.caster                
		local point = point_mines[RandomInt(1,#point_mines)]
		local caster_respoint = Entities:FindByName(nil,point):GetAbsOrigin()
		Timers:CreateTimer(RESPAWN_TIME,function()        
		
		FindClearSpaceForUnit(caster, caster_respoint + RandomVector( RandomInt( 0, 50)), false)
		caster:Stop()
		caster:RespawnUnit()
		end)
	end
end