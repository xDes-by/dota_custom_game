RESPAWN_TIME = 20

function Respoint (keys )
	if _G.Activate_belka == false then
		Timers:CreateTimer(0.01,function()	          
			local caster = keys.caster 	--пробиваем IP усопшего
			caster.respoint = caster:GetAbsOrigin() -- определяем точку спавна
			caster.fw = caster:GetForwardVector()
		end)
	end	
end

function respawncreeps(keys)	
	if _G.Activate_belka == false then
		local caster = keys.caster
		local position = caster.respoint + RandomVector( RandomInt( 0, 50))
		Timers:CreateTimer(RESPAWN_TIME,function()	
		FindClearSpaceForUnit(caster, position, false)
		caster:Stop()
		caster:RespawnUnit()
		end)
	end	
end

