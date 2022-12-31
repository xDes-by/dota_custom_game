if EnfosWizard == nil then EnfosWizard = class({}) end

ENFOS_WIZARD_BASE_MANA_REGEN = {}
ENFOS_WIZARD_BASE_MANA_REGEN[0] = 3.0
ENFOS_WIZARD_BASE_MANA_REGEN[1] = 5.5
ENFOS_WIZARD_BASE_MANA_REGEN[2] = 8.0

ENFOS_WIZARD_CREEP_MANA_REGEN_PENALTY = 0.0075
ENFOS_WIZARD_DUEL_VICTORY_BOOST = 2.0
ENFOS_WIZARD_DUEL_VICTORY_BOOST_DURATION = 180

LinkLuaModifier("modifier_enfos_wizard_mana_regen", "creatures/abilities/5v5/modifier_enfos_wizard_mana_regen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_wizard_winner_boost", "creatures/abilities/5v5/modifier_enfos_wizard_winner_boost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_wizard_casting_spell", "creatures/abilities/5v5/modifier_enfos_wizard_casting_spell", LUA_MODIFIER_MOTION_NONE)

function EnfosWizard:Spawn()

	self.spell_prefix = "enfos_wizard_"
	self.spell_mana_costs = {
		rune_spawned = 50,
		arcane_eye = 75,
		mass_banishment = 200,
		revivify = 300,
		disjunction = 400,
		adrenaline_rush = 600,
		lethargy = 800,
		upgrade_wizard = 900,
		death_sentence = 1000,
		meteor_swarm = 1000,
		sanctuary = 1200,
		upgrade_treasury = 1250,
		plague_of_frogs = 1500,
		upgrade_wizard_2 = 1900,
		rain_of_riches = 2000,
		upgrade_treasury_2 = 2250,
		mass_enlightenment = 2500,
		celestial_stasis = 3000
	}

	self.wizards = {}
	self.wizards[DOTA_TEAM_GOODGUYS] = CreateUnitByName("npc_enfos_wizard", Entities:FindByName(nil, "radiant_wizard"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.wizards[DOTA_TEAM_BADGUYS] = CreateUnitByName("npc_enfos_wizard", Entities:FindByName(nil, "dire_wizard"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)

	local forward_vector = RotatePosition(Vector(1, 0, 0), QAngle(0, 300, 0), Vector(100, 0, 0)):Normalized()

	for team, unit in pairs(self.wizards) do
		unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 30))
		unit:SetForwardVector(forward_vector)
	end

	self.data = {}

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		self.data[team] = {}
		self.data[team].wizard_is_busy = false
		self.data[team].treasury_level = 0
		self.data[team].wizard_level = 0
		self.data[team].wizard_entindex = self.wizards[team]:entindex()
	end

	CustomGameEventManager:RegisterListener("TryWizardSpell", Dynamic_Wrap(EnfosWizard, 'TryWizardSpell'))

	CustomNetTables:SetTableValue("game", "enfos_wizard_data", self.data)
end

function EnfosWizard:Start()
	for _, wizard in pairs(self.wizards) do
		wizard:AddNewModifier(wizard, nil, "modifier_enfos_wizard_mana_regen", {})
	end
end

function EnfosWizard:GrantWinnerBuff(team)
	self.wizards[team]:AddNewModifier(self.wizards[team], nil, "modifier_enfos_wizard_winner_boost", {duration = ENFOS_WIZARD_DUEL_VICTORY_BOOST_DURATION})
end

function EnfosWizard:GetMana(team)
	return self.wizards[team]:GetMana()
end

function EnfosWizard:GetManaCost(spell)
	return self.spell_mana_costs[spell]
end

function EnfosWizard:SpendManaForSpell(team, spell)
	local spell_mana_cost = (spell == "meteor_swarm" and self.wizards[team]:GetMana()) or self.spell_mana_costs[spell]
	self.wizards[team]:SpendMana(spell_mana_cost, nil)
end

function EnfosWizard:AbortSpellCast(caster)
	caster:RemoveModifierByName("modifier_enfos_wizard_casting_spell")
end

function EnfosWizard:CastSpellResult(caster, spell)
	EnfosWizard:SpendManaForSpell(caster:GetTeam(), spell)
	Timers:CreateTimer(0.1, function()
		if not caster or caster:IsNull() then return end
		caster:RemoveModifierByName("modifier_enfos_wizard_casting_spell")
	end)

	local player_id = caster:GetPlayerOwnerID()
	local old_spent_mana = Enfos.spent_enfos_spent_currency.mana[player_id]
	local mana_cost = EnfosWizard:GetManaCost(spell)
	
	Enfos.spent_enfos_spent_currency.mana[player_id] = old_spent_mana + (mana_cost or 0)
	
	CustomGameEventManager:Send_ServerToAllClients("team_panels:update_spent_enfos_currency", {
		spent_currency_data = Enfos.spent_enfos_spent_currency
	})

	CustomGameEventManager:Send_ServerToAllClients("enfos_notifications:add_message", {
		abilityLevel = 0,
		abilityName = self.spell_prefix..spell,
		playerId = caster:GetPlayerOwnerID(),
		type = 1,
	})
end

function EnfosWizard:SetIsBusyState(team, state, casting_data)
	self.data[team].wizard_is_busy = state
	self.data[team].wizard_casting_data = casting_data
	CustomNetTables:SetTableValue("game", "enfos_wizard_data", self.data)
end

function EnfosWizard:GetBusyState(team)
	return self.data[team].wizard_is_busy
end

function EnfosWizard:GetWizardLevel(team)
	return self.data[team].wizard_level
end

function EnfosWizard:UpgradeWizard(team)
	EnfosWizard.data[team].wizard_level = EnfosWizard.data[team].wizard_level + 1
	CustomNetTables:SetTableValue("game", "enfos_wizard_data", EnfosWizard.data)
end

function EnfosWizard:TryWizardSpell(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
	local team = PlayerResource:GetTeam(keys.PlayerID)
	local spell_mana_cost = EnfosWizard:GetManaCost(keys.spell)

	if not hero:IsAlive() then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", {message = "#casting_while_dead"})
	elseif (not spell_mana_cost) then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", {message = "#wrong_spell"})
	elseif EnfosWizard:GetMana(team) < spell_mana_cost then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", {message = "#not_enough_wizard_mana"})
	elseif EnfosWizard:GetBusyState(team) then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", {message = "#wizard_busy"})
	else
		EnfosWizard:StartSpellCast(keys.PlayerID, keys.spell)
	end
end

function EnfosWizard:StartSpellCast(player_id, spell)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local team = PlayerResource:GetTeam(player_id)

	local spell_ability = hero:AddAbility(EnfosWizard.spell_prefix..spell)
	if not spell_ability or spell_ability:IsNull() then return end
	
	spell_ability:SetLevel(1)
	spell_ability:EndCooldown()
	hero:AddNewModifier(hero, spell_ability, "modifier_enfos_wizard_casting_spell", {})

	local spell_data = {}
	spell_data.hero_entindex = hero:entindex()
	spell_data.ability_entindex = spell_ability:entindex()

	EnfosWizard:SetIsBusyState(team, true, spell_data)

	CustomGameEventManager:Send_ServerToPlayer(player, "player_started_wizard_spell", spell_data)
end
