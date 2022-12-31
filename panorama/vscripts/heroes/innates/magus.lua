innate_magus = class({})

LinkLuaModifier("modifier_innate_magus", "heroes/innates/magus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_magus_cooldown", "heroes/innates/magus", LUA_MODIFIER_MOTION_NONE)

function innate_magus:GetIntrinsicModifierName()
	return "modifier_innate_magus"
end

---@class modifier_innate_magus:CDOTA_Modifier_Lua
modifier_innate_magus = class({})

function modifier_innate_magus:IsHidden() return true end
function modifier_innate_magus:IsDebuff() return false end
function modifier_innate_magus:IsPurgable() return false end
function modifier_innate_magus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_magus:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_magus:OnRefresh(keys)
	if IsClient() then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()

	if (not ability) or ability:IsNull() then return end

	self.proc_chance = ability:GetSpecialValueFor("ability_proc_chance") or 0
	self.proc_cooldown = ability:GetSpecialValueFor("proc_cooldown") or 0
	self.proc_cooldown_hero = ability:GetSpecialValueFor("proc_cooldown_hero") or 0

	if not self.wisp_particle and not parent:HasModifier("modifier_innate_magus_cooldown") then self:CreateWisp() end
end

function modifier_innate_magus:CreateWisp()
	local parent = self:GetParent()
	self.wisp_particle = ParticleManager:CreateParticle("particles/custom/innates/magus_wisp_rotate.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(self.wisp_particle, 4, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), false)
end

function modifier_innate_magus:DeclareFunctions()
	if IsServer() then return {	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_innate_magus:GetModifierProcAttack_Feedback(keys)
	if keys.attacker:GetTeam() == keys.target:GetTeam() then return end

	if not keys.attacker:IsAlive() then return end

	-- Magus effect on cooldown
	if keys.attacker:HasModifier("modifier_innate_magus_cooldown") then return end
	
	if RollPercentage(self.proc_chance) then
		self:UseCastableSpell(keys.attacker, keys.target)
	end
end

function modifier_innate_magus:UseCastableSpell(caster, victim)
	local spell_list = self:SelectSpells(caster, victim)

	if #spell_list > 0 then
		local proc_pfx = ParticleManager:CreateParticle("particles/custom/innates/magus_activate.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(proc_pfx, 3, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(proc_pfx)
		
		if self.wisp_particle then
			ParticleManager:DestroyParticle(self.wisp_particle, false)
			ParticleManager:ReleaseParticleIndex(self.wisp_particle)

			self.wisp_particle = nil
		end

		caster:SetCursorCastTarget(victim)

		local spell = spell_list[math.random(#spell_list)]
		spell:OnSpellStart()

		local cooldown = ((GameMode:IsPlayerDueling(caster:GetPlayerOwnerID()) or self.hero_ability[spell:GetAbilityName()] ) and self.proc_cooldown_hero) or self.proc_cooldown
		caster:AddNewModifier(caster, nil, "modifier_innate_magus_cooldown", {duration = cooldown})
	end
end

function modifier_innate_magus:SelectSpells(caster, victim)
	local spell_list = {}

	for i = 0, (DOTA_MAX_ABILITIES - 1) do
		local ability = self:GetParent():GetAbilityByIndex(i)
		if ability and self:SpellFilter(ability, caster, victim) then
			table.insert(spell_list, ability)
			--print(ability, ability:GetAbilityName())
		end
	end

	return spell_list
end

---@param ability CDOTABaseAbility
function modifier_innate_magus:SpellFilter(ability, caster, victim)
	-- Filter
	if ability:GetLevel() == 0 then return false end
	if not ability:IsActivated() then return false end

	local ability_name = ability:GetAbilityName()

	if self.forced_abilities[ability_name] then return true end

	-- Filter by Behavior
	if not ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then return false end
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_AUTOCAST) and not self.autocast_exceptions[ability_name] then return false end
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_CHANNELLED) then return false end

	-- Filter by charge type
	if ability.charge_modifier and ability.charge_modifier.charge_type == ROUND_BASED then return false end

	-- Filter by Ability
	if self.filter_ability[ability_name] then return false end

	-- Filter by team target
	local filter_team = ability:GetAbilityTargetTeam()
	if bit.band(filter_team, DOTA_UNIT_TARGET_TEAM_ENEMY) ~= DOTA_UNIT_TARGET_TEAM_ENEMY then return false end

	local filter_type = ability:GetAbilityTargetType()
	local filter_flags = ability:GetAbilityTargetFlags()

	-- Magic Missile pierces magic immunity with talent
	if ability_name == "vengefulspirit_magic_missile" and caster:HasTalent("special_bonus_unique_vengeful_spirit_3") then
		filter_flags = bit.bor(filter_flags, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	end
	
	local res = UnitFilter(victim, filter_team, filter_type, filter_flags, caster:GetTeam())
	if res ~= UF_SUCCESS then return false end

	return true
end

-- Abilities that should work with Magus but have wrong DOTA_UNIT_TARGET_TEAM or DOTA_UNIT_TARGET_TYPE
modifier_innate_magus.forced_abilities = {
	phantom_assassin_phantom_strike = true,
	hoodwink_acorn_shot = true,
	spectre_spectral_dagger = true,
}

modifier_innate_magus.autocast_exceptions = {
	sven_storm_bolt = true
}

modifier_innate_magus.filter_ability = {
	tiny_tree_throw_lua = true,
	clinkz_death_pact_lua = true,
	enigma_demonic_conversion_lua = true,
	terrorblade_sunder_lua = true,
	spirit_breaker_charge_of_darkness = true,
	tusk_walrus_kick = true,
	razor_static_link = true,
	--ability_name = true
}

-- Abilities that should make magus work as it does on heroes even if casted on creeps
modifier_innate_magus.hero_ability = {
	juggernaut_omni_slash = true,
	broodmother_spawn_spiderlings_lua = true,
	--ability_name = true
}


modifier_innate_magus_cooldown = class({})

function modifier_innate_magus_cooldown:IsHidden() return false end
function modifier_innate_magus_cooldown:IsDebuff() return true end
function modifier_innate_magus_cooldown:IsPurgable() return false end
function modifier_innate_magus_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_magus_cooldown:GetTexture()
	return "innates/innate_magus"
end

function modifier_innate_magus_cooldown:OnDestroy()
	if IsClient() then return end

	local parent = self:GetParent()
	if parent and parent:HasModifier("modifier_innate_magus") then
		local modifier = parent:FindModifierByName("modifier_innate_magus")
		
		if (not modifier.wisp_particle) then modifier:CreateWisp() end
	end
end
