swamp_spawn = class({})

function swamp_spawn:OnSpellStart()
	local caster_pos = self:GetCaster():GetAbsOrigin()
	for i = 1, 4 do
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-700, 700)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
		
		local creep = CreateUnitByName( "medusa_ward", target_point, true, nil, nil, DOTA_TEAM_BADGUYS )
		creep:AddNewModifier(creep, nil, "modifier_kill", {duration = 7})
		add_modifier(creep)
	end
end

function add_modifier(unit)
	if diff_wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
	if diff_wave.wavedef == "Impossible" then
		unit:AddNewModifier(unit, nil, "modifier_impossible", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
end	





