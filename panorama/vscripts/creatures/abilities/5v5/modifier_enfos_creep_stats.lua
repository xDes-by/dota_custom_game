modifier_enfos_creep_stats = modifier_enfos_creep_stats or class({})

function modifier_enfos_creep_stats:IsHidden() return true end
function modifier_enfos_creep_stats:IsDebuff() return false end
function modifier_enfos_creep_stats:IsPurgable() return false end
function modifier_enfos_creep_stats:RemoveOnDeath() return false end

function modifier_enfos_creep_stats:OnCreated(keys)
	if IsServer() then
		self.gold_bounty = keys.gold_bounty or 0
		self.xp_bounty = keys.xp_bounty or 0
	end

	self.bonus_ms = math.min(4 * (self:GetParent():GetLevel() - 1), 200)
end

function modifier_enfos_creep_stats:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_EVENT_ON_DEATH
		}
	else
		return {
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
		}
	end
end

function modifier_enfos_creep_stats:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_enfos_creep_stats:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_enfos_creep_stats:OnDeath(keys)
	if (not IsServer()) or (keys.unit ~= self:GetParent()) or (not keys.attacker) then return end

	local team = keys.attacker:GetTeam()
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:GetTeam() == team and hero:IsMainHero() then

			local gold_bounty = self.gold_bounty
			local xp_bounty = self.xp_bounty

			-- Gold bounty
			local player_id = hero:GetPlayerID()
			RoundManager:GiveGoldToPlayer(player_id, gold_bounty, nil, ROUND_MANAGER_GOLD_SOURCE_CREEPS)

			-- XP bounty
			if hero:HasModifier("modifier_mass_enlightenment_buff") then
				xp_bounty = xp_bounty * (1 + 0.5 * (hero:FindModifierByName("modifier_mass_enlightenment_buff"):GetStackCount() or 0))
			end

			hero:AddExperience(xp_bounty, DOTA_ModifyXP_CreepKill, false, true)
		end
	end
end
