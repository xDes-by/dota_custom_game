function solar_flare_start(event)
	local caster = event.caster
	local caster_pos = caster:GetAbsOrigin()
	local ability = event.ability
	local ability_level = ability:GetLevel() -1
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local delay = ability:GetLevelSpecialValueFor("delay", ability_level)
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
	local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlags = DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
	local particle_start = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
	local particle_end = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
	local targets = FindUnitsInRadius(caster:GetTeam(), caster_pos, nil, range, iTeam, DOTA_UNIT_TARGET_HERO, iFlags, 0, false)
	
	--StartAnimation(caster, {duration=1.0, activity = ACT_DOTA_CAST_ABILITY_5, translate="purification"})
	for _, target in ipairs(targets) do
		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			local point = target:GetAbsOrigin()
			local dummy = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
			ability:ApplyDataDrivenModifier(caster, dummy, "modifier_dummy", {})
			local startFX = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleControl(startFX, 0, point)
			ParticleManager:SetParticleControl(startFX, 1, Vector(damage_radius, 0, 0))
			EmitSoundOn("Hero_Invoker.SunStrike.Charge", target)
			Timers:CreateTimer(delay, function()
					ParticleManager:DestroyParticle(startFX, false)
					local dummy2 = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
					ability:ApplyDataDrivenModifier(caster, dummy2, "modifier_dummy", {})
					local endFX = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN, dummy2)
					ParticleManager:SetParticleControl(endFX, 0, point)
					ParticleManager:SetParticleControl(endFX, 1, Vector(damage_radius, 0, 0))
					EmitSoundOn("Hero_Invoker.SunStrike.Ignite", target)
					local units = FindUnitsInRadius(caster:GetTeam(), point, nil, damage_radius, iTeam, iType, 0, 0, false)
					for _, unit in ipairs(units) do
						if unit:GetTeam() == DOTA_TEAM_GOODGUYS then
							local damage_table = {
													attacker = caster,
													victim = unit,
													ability = ability,
													damage_type = ability:GetAbilityDamageType(),
													damage = damage
												}
							ApplyDamage(damage_table)
						end
					end
				end
			)
		end
	end
end