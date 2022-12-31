LinkLuaModifier("modifier_mud_golem_boss_split", "creatures/abilities/boss/boss_split", LUA_MODIFIER_MOTION_NONE)

boss_split = class({})

function boss_split:GetIntrinsicModifierName()
	return "modifier_mud_golem_boss_split"
end



modifier_mud_golem_boss_split = class({})

function modifier_mud_golem_boss_split:IsDebuff() return false end
function modifier_mud_golem_boss_split:IsHidden() return true end
function modifier_mud_golem_boss_split:IsPurgable() return false end
function modifier_mud_golem_boss_split:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_mud_golem_boss_split:RemoveOnDeath() return false end

function modifier_mud_golem_boss_split:OnCreated(keys)
	if IsClient() then return end

	Timers:CreateTimer(0.1, function()
		if (not self) or self:IsNull() then return nil end

		local parent = self:GetParent()

		if parent and parent:GetUnitName() == "npc_dota_mud_golem_boss" and parent.spawn_team then
			local spawner = RoundManager:GetCurrentRound():GetSpawner(parent.spawn_team)

			if spawner and spawner:AreExtraSpawnsAllowed() then
				spawner.summon_count = spawner.summon_count + 26
			end
		end
	end)
end

function modifier_mud_golem_boss_split:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_EVENT_ON_DEATH
		}
	end
end

function modifier_mud_golem_boss_split:OnDeath(keys)
	if IsClient() or keys.unit ~= self:GetParent() or (not keys.unit.spawn_team) then return end

	local spawner = RoundManager:GetCurrentRound():GetSpawner(keys.unit.spawn_team)

	if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) or spawner.round ~= keys.unit.spawn_round then return end

	local child_name = {}
	child_name["npc_dota_mud_golem_boss"] = "npc_dota_mud_golem_elite"
	child_name["npc_dota_mud_golem_elite"] = "npc_dota_mud_golem"
	child_name["npc_dota_mud_golem"] = "npc_dota_mud_shard"

	local new_unit = child_name[keys.unit:GetUnitName()]
	local golem_count = (new_unit == "npc_dota_mud_golem_elite" and 2) or 3
	local parent_position = keys.unit:GetAbsOrigin()

	Timers:CreateTimer(0.2, function()
		golem_count = golem_count - 1

		if spawner and spawner:AreExtraSpawnsAllowed() then
			local shard = spawner:SpawnUnit(new_unit, parent_position + RandomVector(175), true)
			shard:EmitSound("CreatureSplit.Spawn")
		end

		if golem_count > 0 then
			return 0.2
		end
	end)
end
