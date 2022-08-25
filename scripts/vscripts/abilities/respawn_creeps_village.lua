RESPAWN_TIME = 8

point_village = {"village_spawn_1","village_spawn_2","village_spawn_3","village_spawn_4","village_spawn_5","village_spawn_6","village_spawn_7","village_spawn_8"}

function respawncreeps (keys )
	if _G.Activate_belka == false then
		local caster = keys.caster               
		local point = point_village[RandomInt(1,#point_village)]
		local caster_respoint = Entities:FindByName(nil,point):GetAbsOrigin()    
		Timers:CreateTimer(RESPAWN_TIME,function()        
		
		FindClearSpaceForUnit(caster, caster_respoint + RandomVector( RandomInt( 0, 50)), false)
		caster:Stop()
		caster:RespawnUnit()
		end)
	end
end