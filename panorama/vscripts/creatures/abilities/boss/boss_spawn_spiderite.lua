boss_spawn_spiderite = class({})

function boss_spawn_spiderite:OnSpellStart()
	if IsClient() then return end

	local caster = self:GetCaster()

	if (not caster.spawn_team) then return end

	local spawner = RoundManager:GetCurrentRound():GetSpawner(caster.spawn_team)

	if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) then return end

	local spawn_count = self:GetSpecialValueFor("count")
	local caster_loc = caster:GetAbsOrigin()

	Timers:CreateTimer(0, function()

		if spawner and spawner:AreExtraSpawnsAllowed() then
			spawner.summon_count = spawner.summon_count + 1
			local spider = spawner:SpawnUnit("npc_dota_spiderite", caster_loc + RandomVector(175), true)
			spider:EmitSound("BossSpiderite.Spawn")
		end

		spawn_count = spawn_count - 1

		if spawn_count > 0 and spawner:AreExtraSpawnsAllowed() then
			return 0.4
		end
	end)
end
