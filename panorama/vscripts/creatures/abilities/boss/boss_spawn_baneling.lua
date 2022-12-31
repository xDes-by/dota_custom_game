boss_spawn_baneling = class({})

function boss_spawn_baneling:OnSpellStart()
	if IsClient() then return end

	local caster = self:GetCaster()

	if (not caster.spawn_team) then return end

	local spawner = RoundManager:GetCurrentRound():GetSpawner(caster.spawn_team)

	if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) then return end

	spawner.summon_count = spawner.summon_count + 1

	local spider = spawner:SpawnUnit("npc_dota_baneling", caster:GetAbsOrigin() + RandomVector(150), true)
	spider:EmitSound("BossBaneling.Spawn")
end
