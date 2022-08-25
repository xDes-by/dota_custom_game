function OnNue04PhaseStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local ufoIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04_light_ufo.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( ufoIndex , 0, caster:GetOrigin())
	ParticleManager:DestroyParticleSystemTime(ufoIndex,1.0)
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1})
	caster:EmitSound("Hero_ArcWarden.Flux.Cast")
end

function ParticleManager:DestroyParticleSystemTime(effectIndex,time)
    Timers:CreateTimer(time,
        function()
            ParticleManager:DestroyParticle(effectIndex,true)
            ParticleManager:ReleaseParticleIndex(effectIndex) 
        end
    )
end

function ParticleManager:DestroyParticleSystem(effectIndex,bool)
    if(bool)then
        ParticleManager:DestroyParticle(effectIndex,true)
        ParticleManager:ReleaseParticleIndex(effectIndex) 
    else
         Timers:CreateTimer(1,
            function()
                ParticleManager:DestroyParticle(effectIndex,true)
                ParticleManager:ReleaseParticleIndex(effectIndex) 
            end
        )
    end
end

function OnNue04Start(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targetPoint = keys.target_points[1]
	

	local ufoMoveIndex = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( ufoMoveIndex , 0, targetPoint)
	AddFOWViewer( DOTA_TEAM_GOODGUYS, targetPoint, 700, 1.5, false)

	local time = 2.5
	caster:SetContextThink(DoUniqueString("OnNue04SpellThinkUfo"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time>0 then
				time = time - 0.05
			else
				ParticleManager:DestroyParticleSystem(ufoMoveIndex,true)
				return nil
			end
			ParticleManager:SetParticleControl( ufoMoveIndex , 0, targetPoint - Vector(550,0,0) + (caster:GetOrigin() - targetPoint):Normalized()*time*100 )
			return 0.05
		end,
	0.05)

	caster:AddNoDraw()
	caster:AddNewModifier( caster, nil, "modifier_disarmed", { duration = 2 } )
	caster:SetContextThink(DoUniqueString("OnNue04SpellThink"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			caster:RemoveNoDraw()
			local targets = FindUnitsInRadius(
			   caster:GetTeam(),		
			   targetPoint,	
			   nil,					
			   keys.Radius,		
			   DOTA_UNIT_TARGET_TEAM_ENEMY,
			   keys.ability:GetAbilityTargetType(),
			   0,
			   FIND_CLOSEST,
			   false
		    )
		    
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl( effectIndex , 0, targetPoint)
			ParticleManager:SetParticleControl( effectIndex , 2, Vector(147,112,219))
			if caster:GetName() == "npc_dota_hero_phantom_assassin" then
				caster:EmitSound("Voice_Thdots_Nue.AbilityNue04_2")
			end

		    for k,v in pairs(targets) do
		    	local damage_table = {
					ability = keys.ability,
				    victim = v,
				    attacker = caster,
				    damage = 3500,
				    damage_type = keys.ability:GetAbilityDamageType(), 
		    	    damage_flags = keys.ability:GetAbilityTargetFlags()
				}
				
				v:AddNewModifier( caster, nil, "modifier_stunned", { duration = 1 } )
				
		    	ApplyDamage(damage_table)
			end
			FindClearSpaceForUnit(caster, targetPoint, true)
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
			local ufoIndex2 = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04_light_ufo.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl( ufoIndex2 , 0, caster:GetOrigin())
			ParticleManager:DestroyParticleSystemTime(ufoIndex2,1.0)

			caster:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
			return nil
		end,
	2.5)
end
