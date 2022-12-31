innate_capitalist = class({})

LinkLuaModifier("modifier_innate_capitalist", "heroes/innates/capitalist", LUA_MODIFIER_MOTION_NONE)

function innate_capitalist:GetIntrinsicModifierName()
	return "modifier_innate_capitalist"
end

modifier_innate_capitalist = class({})

function modifier_innate_capitalist:IsHidden() return true end
function modifier_innate_capitalist:IsDebuff() return false end
function modifier_innate_capitalist:IsPurgable() return false end
function modifier_innate_capitalist:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_capitalist:OnCreated(keys)
	if IsClient() then return end

	self:OnRefresh(keys)
end

function modifier_innate_capitalist:OnRefresh(keys)
	if IsClient() then return end

	self.bonus_gold = self:GetAbility():GetSpecialValueFor("bonus_gold")
end

function modifier_innate_capitalist:GetModifierCreepGoldAmplification()
	return self.bonus_gold or 0
end

function modifier_innate_capitalist:OnRoundPreparationStarted(keys)
	if keys.round_number <= 1 then return end

	local parent = self:GetParent()

	if (not parent) or parent:IsNull() then return end

	local player_id = parent:GetPlayerID()
	local team = parent:GetTeam()

	if (not player_id) or (not GameMode:HasPlayerSelectedHero(player_id)) then return end

	if GameMode:HasPlayerAbandoned(player_id) or (not GameMode:IsTeamAlive(team)) then
		self:Destroy()
		return
	end

	local gold_ticks = 25
	local player = PlayerResource:GetPlayer(player_id)
	local hero_gold = parent:GetGold()
	local interest_gold = math.ceil(math.min(hero_gold, 20000) * self:GetAbility():GetSpecialValueFor("interest_percent") * 0.01)
	local gold_per_tick = math.ceil(interest_gold / gold_ticks)
	local last_tick_gold = math.ceil(interest_gold - gold_per_tick * gold_ticks)

	if player then
		Notifications:Bottom(player, {text = "#capitalist_interest_notice", duration = 7, style = {color = "yellow"}})
		Notifications:Bottom(player, {text = interest_gold, duration = 7, style = {color = "yellow"}})
	end

	Timers:CreateTimer(1, function()

		if gold_ticks % 2 == 0 then
			local particle_name = "particles/custom/mammonite_small.vpcf"

			if hero_gold > 1000 and hero_gold < 5000 then
				particle_name = "particles/custom/mammonite_medium.vpcf"
			elseif hero_gold >= 5000 then
				particle_name = "particles/custom/mammonite_large.vpcf"
			end

			local coin_pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(coin_pfx, 0, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(coin_pfx)
		end

		gold_ticks = gold_ticks - 1

		if gold_ticks > 0 then
			RoundManager:GiveGoldToPlayer(player_id, gold_per_tick, nil, ROUND_MANAGER_GOLD_SOURCE_OTHER)
			return 0.2
		else
			RoundManager:GiveGoldToPlayer(player_id, gold_per_tick + last_tick_gold, nil, ROUND_MANAGER_GOLD_SOURCE_OTHER)
		end
	end)
end
