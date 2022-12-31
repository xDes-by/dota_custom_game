LinkLuaModifier("modifier_creature_gang_up", "creatures/abilities/regular/creature_gang_up", LUA_MODIFIER_MOTION_NONE)

creature_gang_up = class({})

function creature_gang_up:GetIntrinsicModifierName()
	return "modifier_creature_gang_up"
end

modifier_creature_gang_up = class({})

function modifier_creature_gang_up:IsHidden() return true end
function modifier_creature_gang_up:IsDebuff() return false end
function modifier_creature_gang_up:IsPurgable() return false end
function modifier_creature_gang_up:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_creature_gang_up:OnCreated(keys)
	if IsClient() then return end

	Timers:CreateTimer(0.1, function()
		if (not self) or self:IsNull() then return nil end

		local parent = self:GetParent()

		self.health_step = self:GetAbility():GetSpecialValueFor("health_step")
		self.next_treshold = 100 - self.health_step

		if parent and (not parent:IsNull()) and parent.spawn_team then
			local summons = math.floor(100 / self.health_step)
			local spawner = RoundManager:GetCurrentRoundSpawner(parent.spawn_team)
			spawner.summon_count = spawner.summon_count + summons
			self.spawner = spawner
		end

		self:StartIntervalThink(0.1)
	end)
end

function modifier_creature_gang_up:OnIntervalThink()
	if IsClient() then return end

	local parent = self:GetParent()

	if (not parent) or parent:IsNull() or (not parent.spawn_team) then return end

	local spawner = self.spawner

	if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) then return end

	if parent:GetHealthPercent() <= self.next_treshold then
		self.next_treshold = self.next_treshold - self.health_step

		local monke = spawner:SpawnUnit("npc_dota_lesser_relict", parent:GetAbsOrigin() + RandomVector(175), true)
		monke:EmitSound("CreatureGangUp.Spawn")
	end
end
