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
modifier_spirit_breaker_greater_bash_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spirit_breaker_greater_bash_lua:IsHidden()
	return true
end

function modifier_spirit_breaker_greater_bash_lua:IsDebuff()
	return false
end

function modifier_spirit_breaker_greater_bash_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spirit_breaker_greater_bash_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.pseudoseed = RandomInt( 1, 100 )

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )

	self.movespeed_pct = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_pct" )
	self.movespeed_duration = self:GetAbility():GetSpecialValueFor( "movespeed_duration" )


	if not IsServer() then return end
end

function modifier_spirit_breaker_greater_bash_lua:OnRefresh( kv )
	self:OnCreated( kv )	
end

function modifier_spirit_breaker_greater_bash_lua:OnRemoved()
end

function modifier_spirit_breaker_greater_bash_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spirit_breaker_greater_bash_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_spirit_breaker_greater_bash_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "speed_damage" then
			return 1
		end
		if data.ability_special_value == "chance_pct" then
			return 1
		end
	end
	return 0
end
-- data.ability_special_level
function modifier_spirit_breaker_greater_bash_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self.ability then
		if data.ability_special_value == "damage" then
			return self:GetAbilityDamage({level = data.ability_special_level, damage = true})
		end
		if data.ability_special_value == "speed_damage" then
			return self:GetAbilityDamage({level = data.ability_special_level, speed_damage = true})
		end
		if data.ability_special_value == "chance_pct" then
			return self:GetAbilityChance({level = data.ability_special_level})
		end
	end
	return 0
end

function modifier_spirit_breaker_greater_bash_lua:OnTakeDamage(params)
	if params.unit == self.parent then
		if (self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_str12") or self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_str13")) and params.damage_type == DAMAGE_TYPE_PHYSICAL then
			local distance = (self.parent:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D()
			if self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_str13") then
				if distance <= 800 and not params.attacker:IsMagicImmune() and not params.attacker:IsBuilding() then
					if not params.attacker.baraBashFirstTime and RollPseudoRandomPercentage( 70, self.pseudoseed, self.parent ) then
						params.attacker.baraBashFirstTime = true
						self:Bash( params.attacker )
					elseif params.attacker.baraBashFirstTime and RollPseudoRandomPercentage( 30, self.pseudoseed, self.parent ) then
						self:Bash( params.attacker )
					end
				end
			elseif self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_str12") then
				if distance <= 500 and not params.attacker:IsMagicImmune() and not params.attacker:IsBuilding() then
					if not params.attacker.baraBashFirstTime and RollPseudoRandomPercentage( 40, self.pseudoseed, self.parent ) then
						params.attacker.baraBashFirstTime = true
						self:Bash( params.attacker )
					elseif params.attacker.baraBashFirstTime and RollPseudoRandomPercentage( 20, self.pseudoseed, self.parent ) then
						self:Bash( params.attacker )
					end
				end
			end
		end
	end
end

function modifier_spirit_breaker_greater_bash_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self.parent:PassivesDisabled() then return end
	if not self.ability:IsFullyCastable() then return end

	-- unit filter
	local filter = UnitFilter(
		params.target,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		self.parent:GetTeamNumber()
	)
	if filter~=UF_SUCCESS then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_agi8") then
		self.duration = 0.01
	end
	-- roll pseudo random
	if RollPseudoRandomPercentage( self:GetSpecialValueFor("chance_pct"), self.pseudoseed, self.parent ) then
		-- set cooldown
		self.ability:UseResources( false, false, false, true )

		-- proc
		self:Bash( params.target )
	elseif self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_agi11") and RollPseudoRandomPercentage( self:GetSpecialValueFor("chance_pct"), self.pseudoseed, self.parent ) then
		local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		for _, enemy in pairs(enemies) do
			if enemy ~= params.target then
				-- set cooldown
				self.ability:UseResources( false, false, false, true )

				-- proc
				self:Bash( enemy )
				break
			end
		end
	end
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------
-- Helper

function modifier_spirit_breaker_greater_bash_lua:GetAbilityDamage(params)
	local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", params.level )
	local speed_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "speed_damage", params.level )

	if self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_int10") then
		damage = damage + self.parent:GetIntellect() * 0.50
	end
	if self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_str7") then
		damage = damage + self.parent:GetStrength() * 0.50
	end
	if self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_agi13") then
		damage = damage + self.parent:GetBaseDamageMax() * 0.60
	end
	if self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_int13") then
		speed_damage = speed_damage + self:GetCaster():GetLevel()
	end
	if params.damage then
		return damage
	end
	if params.speed_damage then
		return speed_damage
	end
	return damage + self.parent:GetIdealSpeed() * speed_damage/100
end

function modifier_spirit_breaker_greater_bash_lua:GetAbilityChance(params)
	local chance = self:GetAbility():GetLevelSpecialValueNoOverride( "chance_pct", params.level )
	if self.parent:FindAbilityByName("npc_dota_hero_spirit_breaker_int7") then
		chance = chance + 10
	end
	return chance
end

function modifier_spirit_breaker_greater_bash_lua:Bash( target, dmg_multi )
	dmg_multi = dmg_multi or 1
	local direction = target:GetOrigin()-self.parent:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	local dist = self.knockback_distance

	-- create arc
	target:AddNewModifier(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			dir_x = direction.x,
			dir_y = direction.y,
			duration = self.knockback_duration,
			distance = dist,
			height = self.knockback_height,
			activity = ACT_DOTA_FLAIL,
		} -- kv
	)

	-- stun
	target:AddNewModifier(
		self.parent, -- player source
		self.ability, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = self.duration } -- kv
	)

	

	

	local damage = self.parent:GetIdealSpeed() * self:GetAbilityDamage({level = self.ability:GetLevel(), speed_damage = true}) / 100 + self:GetSpecialValueFor("damage")
	local damageTable = {
		victim = target,
		attacker = self.parent,
		damage = damage * dmg_multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability, --Optional.
	}
	ApplyDamage(damageTable)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_agi12") then
		self:GetCaster():PerformAttack(
			damageTable.target, -- hTarget
			true, -- bUseCastAttackOrb
			false, -- bProcessProcs
			true, -- bSkipCooldown
			false, -- bIgnoreInvis
			false, -- bUseProjectile
			false, -- bFakeAttack
			false -- bNeverMiss
		)
	end
	
	-- play effects
	self:PlayEffects( target, target:IsCreep() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_spirit_breaker_greater_bash_lua:PlayEffects( target, isCreep )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
	local sound_cast = "Hero_Spirit_Breaker.GreaterBash"
	if isCreep then
		sound_cast = "Hero_Spirit_Breaker.GreaterBash.Creep"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end