boss_spawn_spiderling = class({})

function boss_spawn_spiderling:OnSpellStart()
	if IsClient() then return end

	local caster = self:GetCaster()

	if (not caster.spawn_team) then return end

	local spawner = RoundManager:GetCurrentRound():GetSpawner(caster.spawn_team)

	if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) then return end

	spawner.summon_count = spawner.summon_count + 1

	local spider = spawner:SpawnUnit("npc_dota_spider_range", caster:GetAbsOrigin() + RandomVector(175), true)
	spider:EmitSound("BossSpiderling.Spawn")
end
