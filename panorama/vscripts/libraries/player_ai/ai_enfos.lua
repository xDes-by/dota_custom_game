AI_Enfos = class({})

-- called from Enfos:Init(), in Enfos mode only
function AI_Enfos:Init()
	Timers:CreateTimer(30, function()
		return self:Think()
	end)

	EventDriver:Listen("PvpManager:pvp_countdown_ended", AI_Enfos.OnPvpStarted, self)

	-- prevent casting abilities too often, for stuff like Lethargy etc
	self.ability_cooldowns = {
		[DOTA_TEAM_BADGUYS] = {},
		[DOTA_TEAM_GOODGUYS] = {}
	}

	self.team_heroes = {
		[DOTA_TEAM_BADGUYS] = {},
		[DOTA_TEAM_GOODGUYS] = {}
	}
end

function AI_Enfos:ReindexHeroes()
	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		self.team_heroes[team] = {}
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and not hero:IsNull() then
				table.insert(self.team_heroes[team], hero)
			end
		end
	end
end

function AI_Enfos:Think()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return 10 end

	self:ReindexHeroes()

	for team, bots in pairs(AI_Core.bots_per_team) do
		if table.count(bots) >= 5 then
			ErrorTracking.Try(self.ProcessTeam, self, team, bots)
		end
	end

	return 2
end

function AI_Enfos:ProcessTeam(team, bots)
	local enemies = self.team_heroes[Enfos.enemy_team[team]]
	-- pick random bot on which behalf wizard spells will be casted
	local bot_controller, player_id = table.random(bots)
	if not bot_controller or bot_controller:IsNull() then return end

	local hero = bot_controller.parent
	if not hero or hero:IsNull() then return end

	local current_wizard_level = EnfosWizard:GetWizardLevel(team)

	if current_wizard_level < 2 then
		local upgrade_name = current_wizard_level == 0 and "upgrade_wizard" or "upgrade_wizard_2"
		return self:UseWizardAbility(bot_controller, upgrade_name, {no_target = true})
	end

	local enemies_midpoint = nil
	for _, enemy in pairs(enemies) do
		if not enemies_midpoint then 
			enemies_midpoint = enemy:GetAbsOrigin()
		else
			enemies_midpoint = enemies_midpoint + enemy:GetAbsOrigin() 
		end
		
		if enemy:HasModifier("modifier_hero_dueling") then
			if not hero:CanEntityBeSeenByMyTeam(enemy) then
				return self:UseWizardAbility(bot_controller, "arcane_eye", {location = enemy:GetAbsOrigin()})
			end
		end

		if enemy:GetHealthPercent() < 50 then
			return self:UseWizardAbility(bot_controller, "disjunction", {location = enemy:GetAbsOrigin()})
		end
	end

	enemies_midpoint = enemies_midpoint / #enemies
	local midpoint_enemies_count = 0
	for _, enemy in pairs(enemies) do
		if (enemies_midpoint - enemy:GetAbsOrigin()):Length() <= 900 then
			midpoint_enemies_count = midpoint_enemies_count + 1
		end
	end

	if midpoint_enemies_count >= 4 then
		return self:UseWizardAbility(bot_controller, "lethargy", {location = enemies_midpoint})
	end

	for _, ally in pairs(self.team_heroes[team]) do
		if ally:GetHealthPercent() < 25 then
			return self:UseWizardAbility(bot_controller, "revivify", {target = ally})
		end
	end

	local portal_location = Enfos.team_objectives[team]

	-- searching for creeps on straight line to portal, and moving them out
	local creeps = FindUnitsInLine(
		DOTA_TEAM_NEUTRALS, 
		portal_location + Vector(0, -2000, 0), portal_location, nil, 300, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	)
	for _, creep in pairs(creeps) do
		if creep and not creep:IsNull() and not creep:HasModifier("modifier_mass_banishment_prevention") then
			return self:UseWizardAbility(bot_controller, "mass_banishment", {location = creep:GetAbsOrigin()})
		end
	end

	if #creeps > 0 then
		return self:UseWizardAbility(bot_controller, "meteor_swarm", {no_target = true})
	end

	return self:UseWizardAbility(bot_controller, "mass_enlightenment", {no_target = true})
end


function AI_Enfos:OnPvpStarted(event)
	if GameMode:GetModeState() ~= GAME_STATE_ENFOS_PVP_TEAM then return end

	for team, bots in pairs(AI_Core.bots_per_team) do
		local bot_controller, player_id = table.random(bots)
		if bot_controller then
			self:UseWizardAbility(bot_controller, "adrenaline_rush", {no_target = true})
		end
	end
end

function AI_Enfos:UseWizardAbility(bot_controller, ability_name, targeting_data)
	local team = bot_controller.team
	local hero = bot_controller.parent
	local spell_mana_cost = EnfosWizard:GetManaCost(ability_name)
	if self.ability_cooldowns[team][ability_name] then return end

	if EnfosWizard:GetBusyState(team) then return end
	if EnfosWizard:GetMana(team) < spell_mana_cost then return end
	
	if hero:IsStunned() or hero:IsSilenced() or hero:IsHexed() or not hero:IsAlive() then return end

	local wizard_ability = hero:AddAbility("enfos_wizard_" .. ability_name)
	if not wizard_ability or wizard_ability:IsNull() then return end
	wizard_ability:SetLevel(1)
	local cast_modifier = hero:AddNewModifier(hero, wizard_ability, "modifier_enfos_wizard_casting_spell", {})

	local spell_data = {}
	spell_data.hero_entindex = hero:entindex()
	spell_data.ability_entindex = wizard_ability:entindex()

	EnfosWizard:SetIsBusyState(team, true, spell_data)

	-- ensure casting state doesn't leak
	Timers:CreateTimer(5, function() 
		if cast_modifier and not cast_modifier:IsNull() then
			cast_modifier:Destroy()
		end
	end)

	-- skip frame for ability to init and cast
	Timers:CreateTimer(0, function()
		if not hero or hero:IsNull() then return end
		if not wizard_ability or wizard_ability:IsNull() then return end
		AI_Enfos:_CastWizardAbility(hero, wizard_ability, targeting_data)
	end)

	self.ability_cooldowns[team][ability_name] = true
	Timers:CreateTimer(15, function()
		self.ability_cooldowns[team][ability_name] = false
	end)
end


function AI_Enfos:_CastWizardAbility(hero, wizard_ability, targeting_data)
	if targeting_data.target then
		CastTargetedAbility(hero, targeting_data.target, wizard_ability)
	elseif targeting_data.location then
		CastPositionalAbility(hero, targeting_data.location, wizard_ability)
	elseif targeting_data.no_target then
		CastUntargetedAbility(hero, wizard_ability)
	end
end
