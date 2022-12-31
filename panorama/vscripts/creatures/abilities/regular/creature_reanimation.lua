LinkLuaModifier("modifier_creature_reanimation", "creatures/abilities/regular/creature_reanimation", LUA_MODIFIER_MOTION_NONE)

creature_reanimation = class({})

function creature_reanimation:GetIntrinsicModifierName()
	return "modifier_creature_reanimation"
end

modifier_creature_reanimation = class({})

function modifier_creature_reanimation:IsHidden() return true end
function modifier_creature_reanimation:IsDebuff() return false end
function modifier_creature_reanimation:IsPurgable() return false end
function modifier_creature_reanimation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creature_reanimation:RemoveOnDeath() return false end

function modifier_creature_reanimation:OnCreated(keys)
	if IsClient() then return end

	Timers:CreateTimer(0.1, function()
		if (not self) or self:IsNull() then return nil end

		local parent = self:GetParent()

		if parent.spawn_team then
			local spawner = RoundManager:GetCurrentRound():GetSpawner(parent.spawn_team)
			spawner.summon_count = spawner.summon_count + 1
			self.spawner = spawner
		end
	end)
end

function modifier_creature_reanimation:DeclareFunctions()
	if IsServer() then return {	MODIFIER_EVENT_ON_DEATH } end
end

function modifier_creature_reanimation:OnDeath(keys)
	if IsClient() or keys.unit ~= self:GetParent() or (not keys.unit.spawn_team) then return end

	local spawner = self.spawner

	if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) then return end

	local parent_position = keys.unit:GetAbsOrigin()

	Timers:CreateTimer(1.5, function()
		if (not spawner) or (not spawner:AreExtraSpawnsAllowed()) then return end

		local reanimate_pfx = ParticleManager:CreateParticle("particles/creature/reanimation.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(reanimate_pfx, 0, parent_position)
		ParticleManager:ReleaseParticleIndex(reanimate_pfx)

		if spawner then
			spawner:SpawnUnit("npc_dota_skeleton_reincarnated", parent_position, true)
		end
	end)
end
