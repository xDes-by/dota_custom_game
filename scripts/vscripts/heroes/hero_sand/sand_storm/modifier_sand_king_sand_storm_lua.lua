LinkLuaModifier( "modifier_regen", "heroes/hero_sand/modifier_regen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_as_sand", "heroes/hero_sand/sand_storm/modifier_sand_king_sand_storm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_eva", "heroes/hero_sand/sand_storm/modifier_sand_king_sand_storm_lua", LUA_MODIFIER_MOTION_NONE )

modifier_sand_king_sand_storm_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sand_king_sand_storm_lua:IsHidden()
	return false
end

function modifier_sand_king_sand_storm_lua:IsDebuff()
	return false
end

function modifier_sand_king_sand_storm_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sand_king_sand_storm_lua:OnCreated( kv )
	if IsServer() then
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value
	self.interval = 0.5
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int8") ~= nil then 
       	self.damage = self.damage + self:GetCaster():GetIntellect() * 0.25
    end

	if IsServer() then
		-- initialize
		self.active = true
		self.damageTable = {
			 victim = target,
			attacker = self:GetCaster(),
			damage = self.damage * self.interval,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- start effects
		self:PlayEffects( self.radius )
	end
end
end

function modifier_sand_king_sand_storm_lua:OnRefresh( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value
	
	if IsServer() then
		-- initialize
		self.damageTable.damage = self.damage * self.interval
		self.active = kv.start
		self:SetDuration( kv.duration, true )
	end
end

function modifier_sand_king_sand_storm_lua:OnDestroy( kv )
	if IsServer() then
		-- stop effects
		self:StopEffects()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sand_king_sand_storm_lua:OnIntervalThink()
	if self.active==0 then return end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_str6") ~= nil then 
	
	local self_sand = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,sand in pairs(self_sand) do
	if sand == self:GetCaster() then
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_regen", -- modifier name
		{
			duration = 0.5,
		} 
	)
	end
	end
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_agi11") ~= nil then 
	
	local self_sand = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,sand in pairs(self_sand) do
	if sand == self:GetCaster() then
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_as_sand", -- modifier name
		{
			duration = 0.5,
		} 
	)
	end
	end
	end
	
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_agi10") ~= nil then 
	
	local self_sand = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,sand in pairs(self_sand) do
	if sand == self:GetCaster() then
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_eva", -- modifier name
		{
			duration = 0.5,
		} 
	)
	end
	end
	end


	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	-- damage enemies
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- effects: reposition cloud
	if self.effect_cast then
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sand_king_sand_storm_lua:PlayEffects( radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf"
	local sound_cast = "Ability.SandKing_SandStorm.loop"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_sand_king_sand_storm_lua:StopEffects()
	-- Stop particles
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Stop sound
	local sound_cast = "Ability.SandKing_SandStorm.loop"
	StopSoundOn( sound_cast, self:GetParent() )
end


-----------------------------------------------------------------------------------------------

modifier_as_sand = class({})

function modifier_as_sand:IsHidden()
    return true
end

function modifier_as_sand:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_as_sand:IsPurgable()
	return false
end

function modifier_as_sand:RemoveOnDeath()
	return false
end

function modifier_as_sand:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():GetLevel() * 5
end

---------------------------------------------------------------------------------------------

modifier_eva = class({})

function modifier_eva:IsHidden()
    return true
end

function modifier_eva:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
    }
end

function modifier_eva:IsPurgable()
	return false
end

function modifier_eva:RemoveOnDeath()
	return false
end

function modifier_eva:GetModifierEvasion_Constant()
	return 80
end