-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_razor_eye_of_the_storm_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_eye_of_the_storm_lua:IsHidden()
	return false
end

function modifier_razor_eye_of_the_storm_lua:IsDebuff()
	return false
end

function modifier_razor_eye_of_the_storm_lua:RemoveOnDeath()
	return false
end

function modifier_razor_eye_of_the_storm_lua:IsPurgable()
	return false
end

-- Optional Classifications
-- function modifier_razor_eye_of_the_storm_lua:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE
-- end

--------------------------------------------------------------------------------
-- Initializations
function modifier_razor_eye_of_the_storm_lua:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.interval = self:GetAbility():GetSpecialValueFor( "strike_interval" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str_last") then
		self.interval = self.interval - 0.3
	end
	if not IsServer() then return end

	self.strikes = 1
	if self.parent:HasScepter() then
		self.strikes = self.strikes + 1
		self.building = true
	end
	self.targets = {}

	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( self.interval )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects1()
end

function modifier_razor_eye_of_the_storm_lua:OnRefresh( kv )
end

function modifier_razor_eye_of_the_storm_lua:OnRemoved()
end

function modifier_razor_eye_of_the_storm_lua:OnDestroy()
	if not IsServer() then return end
	-- stop sound
	local sound_loop = "Hero_Razor.Storm.Loop"
	local sound_end = "Hero_Razor.StormEnd"
	StopSoundOn( sound_loop, self.parent )
	EmitSoundOn( sound_end, self.parent )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_razor_eye_of_the_storm_lua:OnIntervalThink()
	local targets = {}

	local type_filter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	if self.building then
		type_filter = type_filter + DOTA_UNIT_TARGET_BUILDING
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		type_filter,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	if #enemies<1 then return end

	-- sort based on health
	table.sort( enemies, function( left, right )
		return left:GetHealth() < right:GetHealth()
	end)

	-- find static-linked enemies (modifier name subject to change)
	local linked = {}
	for i,enemy in ipairs(enemies) do
		if enemy:HasModifier( "modifier_static_link_lua" ) then
			table.insert( linked, enemy )
		end
	end
	local targets_count = self:GetAbility():GetSpecialValueFor("targets_count")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str7")	then
		targets_count = targets_count + 1
	end
	-- find enemies based on number of strikes per interval
	for i=1,self.strikes do
		local target
		-- find enemies in linked
		for _,enemy in pairs(linked) do
			if not targets[enemy] then
				targets[enemy] = true
				target = enemy
				break
			end
		end
		if target then break end
		-- find target in lowest
		for _,enemy in pairs(enemies) do
			if not targets[enemy] then
				-- check building
				if not enemy:IsBuilding() then
					targets_count = targets_count - 1
					targets[enemy] = true
					target = enemy
				elseif (enemy:IsAncient() or enemy:IsTower() or enemy:IsBarracks()) then
					targets_count = targets_count - 1
					targets[enemy] = true
					target = enemy
				end
				if targets_count <= 0 then
					break
				end
			end
		end
	end
	local damage = self.damage
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_int6") then
		self.damageTable.damage_type = DAMAGE_TYPE_MAGICAL
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
	else
		damage = damage + self.parent:GetAverageTrueAttackDamage(self.parent) * self:GetAbility():GetSpecialValueFor("damage_perc") / 100
		if caster:FindAbilityByName("npc_dota_hero_razor_agi6") then
			damage = damage + self.parent:GetAverageTrueAttackDamage(self.parent) * 60 / 100
		end
		self.damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_agi11") then
		local min_value = 2
		local max_value = 5
		local d = min_value + self:GetAbility():GetLevel() * ((max_value - min_value) / 15)
		damage = damage + (self.parent:GetStrength() + self.parent:GetIntellect() + self.parent: GetAgility()) * d / 100
	end
	self.damageTable.damage = damage
	-- strike targets
	for enemy,_ in pairs(targets) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- add modifier
		enemy:AddNewModifier(
			self.parent, -- player source
			self, -- ability source
			"modifier_razor_eye_of_the_storm_lua_debuff", -- modifier name
			{
				duration = self:GetRemainingTime(),
				armor = self.armor,
			} -- kv
		)

		-- play effects
		self:PlayEffects2( enemy )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_razor_eye_of_the_storm_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_rain_storm.vpcf"
	local sound_cast = "Hero_Razor.Storm.Cast"
	local sound_loop = "Hero_Razor.Storm.Loop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_razor_eye_of_the_storm_lua:PlayEffects2( enemy )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf"
	local sound_cast = "Hero_razor.lightning"

	-- Create Particle
	-- NOTE: Don't know what is the proper effect
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() + Vector(0,0,500) )
	-- ParticleManager:SetParticleControlEnt(
	-- 	effect_cast,
	-- 	0,
	-- 	self.parent,
	-- 	PATTACH_CUSTOMORIGIN,
	-- 	"",
	-- 	self.parent:GetOrigin() + Vector(0,0,300), -- unknown
	-- 	false -- unknown, true
	-- )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		enemy,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, enemy )
end