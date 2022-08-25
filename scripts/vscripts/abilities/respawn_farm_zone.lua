RESPAWN_TIME = 0.1

function Respoint (keys )
	Timers:CreateTimer(0.03,function()	          
		local caster = keys.caster 	--пробиваем IP усопшего
		caster.respoint = caster:GetAbsOrigin() -- определяем точку спавна
		caster.fw = caster:GetForwardVector()
	end)
end

function respawncreeps(keys)	
	local caster = keys.caster
	local position = caster.respoint + RandomVector( RandomInt( 0, 50))
	Timers:CreateTimer(RESPAWN_TIME,function()	
	FindClearSpaceForUnit(caster, position, false)
	caster:Stop()
	caster:RespawnUnit()
	end)
end

