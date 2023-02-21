modifier_drow_ranger_marksmanship_lua = class({})

--------------------------------------------------------------------------------
function modifier_drow_ranger_marksmanship_lua:IsHidden()
	return true
end

function modifier_drow_ranger_marksmanship_lua:IsDebuff()
	return false
end

function modifier_drow_ranger_marksmanship_lua:IsPurgable()
	return false
end

function modifier_drow_ranger_marksmanship_lua:GetPriority()
	return MODIFIER_PRIORITY_LOW
end


function modifier_drow_ranger_marksmanship_lua:OnCreated( kv )
    self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "agility_range" )
	self.split_range = self:GetAbility():GetSpecialValueFor( "scepter_range" )
	self.split_count = self:GetAbility():GetSpecialValueFor( "split_count_scepter" )
	self.split_damage = self:GetAbility():GetSpecialValueFor( "damage_reduction_scepter" )

	self.active = true

	if not IsServer() then return end
	self.records = {}
	self.procs = false

	self.info = {
		Ability = self:GetAbility(),	
		
		EffectName = self:GetParent():GetRangedProjectileName(),
		iMoveSpeed = self:GetParent():GetProjectileSpeed(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,		
	
		bDodgeable = true,                           -- Optional
		bIsAttack = true,                                -- Optional

		ExtraData = {},
	}

	self:PlayEffects1()
end

function modifier_drow_ranger_marksmanship_lua:OnRefresh( kv )
		self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "agility_range" )	
		
	if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_str_last") ~= nil then
		self.chance = self:GetAbility():GetSpecialValueFor( "chance" ) * 2 
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) * 2
		self.radius = self:GetAbility():GetSpecialValueFor( "agility_range" ) * 2
	end
end

function modifier_drow_ranger_marksmanship_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
	return funcs
end

function modifier_drow_ranger_marksmanship_lua:GetModifierProcAttack_BonusDamage_Physical( keys )
	if not IsServer() then return end
	self.proc = false
	if keys.attacker ~= self:GetParent() then return end
	if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then return end
	if keys.target:IsBuilding() or keys.target:IsOther() then return end
	if RandomInt(1,100) < self.chance then
		self.proc = true
		self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_str_last") ~= nil then
			self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) * 2
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_str9") ~= nil and RandomInt(1,100) < 50 then
			local ability = self:GetCaster():FindAbilityByName( "drow_cross_lua" )
			if ability~=nil and ability:GetLevel()>=1 then
				ability:OnSpellStart()
			end
		end
		
		self.record = keys.record
		self:GetModifierProjectileName( keys )
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_str8") ~= nil then 
			self.damage = self.damage + self:GetCaster():GetStrength()
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_agi9") ~= nil then 
			self.damage = self.damage + self:GetCaster():GetAgility()
		end
		ApplyDamage({
			victim = keys.target,
			attacker = keys.attacker,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		})
	end
	return 0
end

function modifier_drow_ranger_marksmanship_lua:GetModifierProjectileName( params )
	if IsServer() then
		if params then
			return "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
		end
	end
end

function modifier_drow_ranger_marksmanship_lua:GetModifierProcAttack_Feedback( params )
		if not IsServer() then return end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_agi11") == nil then return end

		if self:GetAbility().split then return end

		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			params.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.split_range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		local count = 0
		for _,enemy in pairs(enemies) do
			if enemy~=params.target and count<self.split_count then

				-- roll pierce armor chance
				local procs = false
				if self.active and self.proc then
					procs = true
				end

				self.info.Target = enemy
				self.info.Source = params.target
				if procs then
					self.info.EffectName = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
					self.info.ExtraData = {
						procs = true,
					}
				else
					self.info.EffectName = self:GetParent():GetRangedProjectileName()
					self.info.ExtraData = {
						procs = false,
					}
				end
				ProjectileManager:CreateTrackingProjectile( self.info )

				count = count+1
			end
	end
end

function modifier_drow_ranger_marksmanship_lua:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	
	-- check if split shot
	if self:GetAbility().split then
		return -self.split_damage
	end
end

function modifier_drow_ranger_marksmanship_lua:IsAura()
	return self.active
end

function modifier_drow_ranger_marksmanship_lua:GetModifierAura()
	return "modifier_drow_ranger_marksmanship_lua_effect"
end

function modifier_drow_ranger_marksmanship_lua:GetAuraRadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_agi_last")
	if abil ~= nil then
		return 99999
	end
	return self.radius
end

function modifier_drow_ranger_marksmanship_lua:GetAuraDuration()
	return 0.5
end

function modifier_drow_ranger_marksmanship_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_drow_ranger_marksmanship_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_drow_ranger_marksmanship_lua:GetAuraSearchFlags()

local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_str7")
	if abil ~= nil then 
		return DOTA_UNIT_TARGET_FLAG_NONE
			else
		return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY
	end
end

function modifier_drow_ranger_marksmanship_lua:GetAuraEntityReject( hEntity )
	if IsServer() then

	end

	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_drow_ranger_marksmanship_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_drow/drow_marksmanship.vpcf"
 
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	-- set glowing
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(2,0,0) )

	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:PlayEffects2( true )
end

function modifier_drow_ranger_marksmanship_lua:PlayEffects2( start )
	-- turn on/off cold effect
	local state = 1
	if start then state = 2 end
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(state,0,0) )

	-- play start effect
	if not start then return end

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_drow/drow_marksmanship_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end