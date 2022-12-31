LinkLuaModifier("modifier_creature_golden_goose", "creatures/abilities/regular/creature_golden_goose", LUA_MODIFIER_MOTION_NONE)

creature_golden_goose = class({})

function creature_golden_goose:GetIntrinsicModifierName()
	return "modifier_creature_golden_goose"
end

modifier_creature_golden_goose = class({})

function modifier_creature_golden_goose:IsHidden() return true end
function modifier_creature_golden_goose:IsDebuff() return false end
function modifier_creature_golden_goose:IsPurgable() return false end
function modifier_creature_golden_goose:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creature_golden_goose:RemoveOnDeath() return false end

if not IsServer() then return end

function modifier_creature_golden_goose:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_FINISHED
	}
	return funcs
end


function modifier_creature_golden_goose:OnDeath(keys)
	if keys.unit ~= self:GetParent() or not keys.attacker then return end

	local spawner = RoundManager:GetCurrentRound().spawners[keys.unit.spawn_team]
	if not spawner then return end

	local round_gold = spawner.round:GetGoldBounty()
	local gold_tick = round_gold * 0.04

	keys.unit:EmitSound("General.CoinsBig")
	local coin_pfx = ParticleManager:CreateParticle("particles/creature/golden_goose.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(coin_pfx, 0, keys.unit:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(coin_pfx)

	local team = keys.attacker:GetTeam()
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:GetTeam() == team and hero:IsMainHero() then
			local player_id = hero:GetPlayerID()
			local player = hero:GetPlayerOwner()
			local ticks = 50
			Timers:CreateTimer(0, function()
				RoundManager:GiveGoldToPlayer(player_id, gold_tick, nil, ROUND_MANAGER_GOLD_SOURCE_CREEPS)

				ticks = ticks - 1
				if ticks > 0 then
					return 0.1
				end
			end)
		end
	end
end



function modifier_creature_golden_goose:OnAttackStart(keys)
	if keys.attacker == self:GetCaster() then
		self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_SPAWN, self:GetCaster():GetAttacksPerSecond() * 2.0)
	end
end

function modifier_creature_golden_goose:OnAttackFinished(keys)
	if keys.attacker == self:GetCaster() then
		self:GetCaster():FadeGesture(ACT_DOTA_SPAWN)
	end
end

