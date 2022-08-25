point_belka = {"forest_spawn_1","forest_spawn_2","forest_spawn_3","forest_spawn_4","forest_spawn_5","forest_spawn_6","forest_spawn_7","forest_spawn_8","forest_spawn_9","forest_spawn_10","forest_spawn_11"}

function respawncreeps (keys )
	if _G.Activate_belka == false then
		local caster = keys.caster           
		local team = caster:GetTeamNumber()      
		local point = point_belka[RandomInt(1,#point_belka)]
		local caster_respoint = Entities:FindByName(nil,point):GetAbsOrigin()
		local name = caster:GetUnitName()     
		Timers:CreateTimer(RandomInt(120,180),function()        
		local unit = CreateUnitByName(name, caster_respoint + RandomVector( RandomInt( 0, 50)), true, nil, nil, team)
		end)
	end
end

