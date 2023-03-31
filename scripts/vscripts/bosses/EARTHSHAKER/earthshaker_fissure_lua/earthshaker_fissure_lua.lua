earthshaker_fissure_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_fissure_lua_thinker", "bosses/EARTHSHAKER/earthshaker_fissure_lua/modifier_earthshaker_fissure_lua_thinker.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_fissure_fly_lua", "bosses/EARTHSHAKER/earthshaker_fissure_lua/modifier_earthshaker_fissure_fly_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

-- Ability Start
function earthshaker_fissure_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	-- load data
	
	local distance = self:GetSpecialValueFor("AbilityCastRange")
	local duration = self:GetSpecialValueFor("fissure_duration")
	local fissure_range = self:GetSpecialValueFor("fissure_range")
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, fissure_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		self:CreateLinearFissureBlockers(enemies[1]:GetAbsOrigin(), distance, duration)
	end

	-- Effects
    self:CreateCircularFissureBlockers(fissure_range, duration)
	

    CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_earthshaker_fissure_fly_lua", -- modifier name
		{ duration = duration }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
end

function earthshaker_fissure_lua:CreateLinearFissureBlockers(point, distance, duration)
	local caster = self:GetCaster()

	local damage = self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("fissure_radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	-- generate data
	local block_width = 24
	local block_delta = 8.25
	-- get wall vector
	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local wall_vector = direction * distance

	-- Create blocker along path
	local block_spacing = (block_delta+2*block_width)
	local blocks = distance/block_spacing
	local block_pos = caster:GetHullRadius() + block_delta + block_width
	local start_pos = caster:GetOrigin() + direction*block_pos

	for i=1,blocks do
		local block_vec = caster:GetOrigin() + direction*block_pos
		local blocker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_earthshaker_fissure_lua_thinker", -- modifier name
			{ duration = duration }, -- kv
			block_vec,
			caster:GetTeamNumber(),
			true
		)
		blocker:SetHullRadius( block_width )
		block_pos = block_pos + block_spacing
	end

	-- find units in line
	local end_pos = start_pos + wall_vector
	local units = FindUnitsInLine(
		caster:GetTeamNumber(),
		start_pos,
		end_pos,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- apply damage, shove and stun
	for _,unit in pairs(units) do
		-- shove
		FindClearSpaceForUnit( unit, unit:GetOrigin(), true )

		if unit:GetTeamNumber()~=caster:GetTeamNumber() then
			-- damage
			damageTable.victim = unit
			ApplyDamage(damageTable)

			-- stun
			unit:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_generic_stunned_lua", -- modifier name
				{ duration = stun_duration } -- kv
			)
		end
	end
	self:PlayEffects( start_pos, end_pos, duration )
end

function earthshaker_fissure_lua:CreateCircularFissureBlockers(radius, duration)
    local caster = self:GetCaster()
    -- Generate data
    local block_width = 24
    local block_delta = 8.25

    -- Number of blockers to create the circle
    local blocker_count = 100

    local center = caster:GetOrigin() -- You can change this to the center of the circle you want to create

    for i = 0, blocker_count - 1 do
        local angle = i * 2 * math.pi / blocker_count
        local xOffset = radius * math.cos(angle)
        local yOffset = radius * math.sin(angle)

        local block_vec = center + Vector(xOffset, yOffset, 0)

        -- Only create blockers if the team is not equal to caster's team
        local blocker = CreateModifierThinker(
            caster, -- player source
            self, -- ability source
            "modifier_earthshaker_fissure_lua_thinker", -- modifier name
            { duration = duration }, -- kv
            block_vec,
            caster:GetTeamNumber(),
            true
        )
        blocker:SetHullRadius(block_width)
    end
	self:PlayEffects2( caster:GetOrigin(), radius, 10, duration )
end

--------------------------------------------------------------------------------
function earthshaker_fissure_lua:PlayEffects( start_pos, end_pos, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	local sound_cast = "Hero_EarthShaker.Fissure"

	-- generate data
	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, start_pos )
	ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( start_pos, sound_cast, caster )
	EmitSoundOnLocationWithCaster( end_pos, sound_cast, caster )
end

function earthshaker_fissure_lua:PlayEffects2(center, radius, segments, duration)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
    local sound_cast = "Hero_EarthShaker.Fissure"

    -- generate data
    local caster = self:GetCaster()

    -- Calculate angle increment for each segment
    local angle_increment = 360 / segments

    for i = 0, segments - 1 do
        local angle = math.rad(i * angle_increment)
        local start_pos = center + Vector(radius * math.cos(angle), radius * math.sin(angle), 0)
        local end_pos = center + Vector(radius * math.cos(angle + math.rad(angle_increment)), radius * math.sin(angle + math.rad(angle_increment)), 0)

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(effect_cast, 0, start_pos)
        ParticleManager:SetParticleControl(effect_cast, 1, end_pos)
        ParticleManager:SetParticleControl(effect_cast, 2, Vector(duration, 0, 0))
        ParticleManager:ReleaseParticleIndex(effect_cast)

        -- Create Sound
        EmitSoundOnLocationWithCaster(start_pos, sound_cast, caster)
        EmitSoundOnLocationWithCaster(end_pos, sound_cast, caster)
    end
end