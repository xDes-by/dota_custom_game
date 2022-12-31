snapfire_spit_creep_lua = class({})
LinkLuaModifier("snapfire_spit_creep_lua_thinker", "heroes/hero_snapfire/snapfire_spit_creep_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("snapfire_spit_creep_lua_movement", "heroes/hero_snapfire/snapfire_spit_creep_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("snapfire_spit_creep_lua_thinker_aura", "heroes/hero_snapfire/snapfire_spit_creep_lua", LUA_MODIFIER_MOTION_NONE)

function snapfire_spit_creep_lua:Spawn()
	if IsServer() then
		self:SetActivated(false)
		if not self:GetCaster():HasScepter() then
			self:SetHidden(true)
		end
    end
end

-- Aghs interactions
function snapfire_spit_creep_lua:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		if self:GetCaster():HasModifier("snapfire_gobble_up_lua_caster") then
			self:SetActivated(true)
		end
		self:SetHidden(false)
	else
		self:SetActivated(false)
		self:SetHidden(true)
	end
end

function snapfire_spit_creep_lua:GetAOERadius()
    return self:GetSpecialValueFor("impact_radius")
end

function snapfire_spit_creep_lua:OnSpellStart()
    if not IsServer() then return end

    local gobble_ability = self:GetCaster():FindAbilityByName("snapfire_gobble_up_lua")
    if gobble_ability == nil or gobble_ability.currently_held == nil then return end

    -- 
    local caster = self:GetCaster()
    local location = self:GetCursorPosition()
    local distance = (location - caster:GetAbsOrigin()):Length2D()
    local unit = gobble_ability.currently_held
    caster:EmitSound("Hero_Snapfire.SpitOut.Projectile")
    
    -- Ability Specials
    local projectile_speed = self:GetSpecialValueFor("projectile_speed")

    -- Creates a thinker at the target location and shoot the unit
    local land_time = distance/projectile_speed
    local what = unit:AddNewModifier(unit, self, "snapfire_spit_creep_lua_movement", {
        impact_time = land_time,
        vLocX = location.x,
        vLocY = location.y,
        vLocZ = location.z,
    })
    

    -- Ability clean-up
    if caster:HasModifier("snapfire_gobble_up_lua_caster") then
        caster:FindModifierByName("snapfire_gobble_up_lua_caster"):SetDuration(0.05, true)
    end
    if unit:HasModifier("snapfire_gobble_up_lua_target") then
        unit:FindModifierByName("snapfire_gobble_up_lua_target"):SetDuration(0.05, true)
    end

    -- Ability Activation Logic
    --[[ If coding isn't broken yet, destroying the caster modifier should do this
	self:SetActivated(false)
	if caster:HasAbility("snapfire_spit_creep_lua") then
		caster:FindAbilityByName("snapfire_gobble_up_lua"):SetActivated(true)
    end
    ]]
end

-- Spit Creep Movement
snapfire_spit_creep_lua_movement = snapfire_spit_creep_lua_movement or class({})

function snapfire_spit_creep_lua_movement:IsDebuff() return true end
function snapfire_spit_creep_lua_movement:IsStunDebuff() return true end
function snapfire_spit_creep_lua_movement:RemoveOnDeath() return false end
function snapfire_spit_creep_lua_movement:IsHidden() return true end
function snapfire_spit_creep_lua_movement:IgnoreTenacity() return true end
function snapfire_spit_creep_lua_movement:IsMotionController() return true end
function snapfire_spit_creep_lua_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function snapfire_spit_creep_lua_movement:IsPurgable() return false end

--------------------------------------------------------------------------------

function snapfire_spit_creep_lua_movement:OnCreated( kv )
    local ability = self:GetAbility()
	self.toss_minimum_height_above_lowest = ability:GetSpecialValueFor("min_height_above_lowest")
	self.toss_minimum_height_above_highest = ability:GetSpecialValueFor("min_height_above_highest")
	self.toss_acceleration_z = ability:GetSpecialValueFor("min_acceleration")
	self.toss_max_horizontal_acceleration = ability:GetSpecialValueFor("max_acceleration")

	if IsServer() then
		self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.parent:RemoveNoDraw()
        local gobble_ability = self:GetAbility():GetCaster():FindAbilityByName("snapfire_gobble_up_lua")
        self.is_death_exception = gobble_ability:IsDeathException(self:GetParent())

        -- Defining attributes now to prevent a fringe case where mortimers kisses gets deleted while unit is mid-flight
        self.caster = self:GetAbility():GetCaster()
        self.impact_radius = self:GetAbility():GetSpecialValueFor("impact_radius")
        self.damage = self.caster:FindAbilityByName("snapfire_mortimer_kisses"):GetSpecialValueFor("damage_per_impact")
        self.damage_type = self.ability:GetAbilityDamageType()
        self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
        self.puddle_duration = self.ability:GetSpecialValueFor("burn_ground_duration")

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = kv.impact_time
		local flDesiredHeight = self.toss_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.toss_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.toss_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.toss_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.toss_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.toss_acceleration_z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function snapfire_spit_creep_lua_movement:OnIntervalThink()
	if IsServer() then
        -- Check for motion controllers
        --[[ Dota IMBA code for overriding motion and shit
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then
			self:Destroy()
			return nil
        end
        ]]

        -- Vision
        AddFOWViewer(self.caster:GetTeam(), self.parent:GetAbsOrigin(), 500, FrameTime(), false)  

		-- Horizontal motion
		self:HorizontalMotion(self.parent, self.frametime)

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function snapfire_spit_creep_lua_movement:TossLand()
	if IsServer() then
		-- If the Toss was already completed, do nothing
		if self.land_complete then
			return nil
		end
		-- Mark Toss as completed
		self.land_complete = true

		-- Destroy trees at the target point
		GridNav:DestroyTreesAroundPoint(self.vLastKnownTargetPos, self.impact_radius, true)

		local victims = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 1, false)
		for _, victim in pairs(victims) do
            victim:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_duration})
            ApplyDamage({victim = victim, attacker = self.caster, damage = self.damage, damage_type = self.damage_type, ability = self.ability})
        end
        
        AddFOWViewer(self.caster:GetTeam(), self.vLastKnownTargetPos, self.impact_radius, 3.5, true)
        ResolveNPCPositions(self.parent:GetAbsOrigin(), 150)

        CreateModifierThinker(self.caster, self.ability, "snapfire_spit_creep_lua_thinker", {duration = self.puddle_duration}, self.vLastKnownTargetPos, self.caster:GetTeam(), false)

        if not self.is_death_exception then
            self:GetParent():Kill(self:GetAbility(), self.caster)
        end

        self:Destroy()
    end
end

function snapfire_spit_creep_lua_movement:OnDestroy()
	if IsServer() then
        --[[
        self:SetAbsOrigin(Vector(self:GetAbsOrigin().x, self:GetAbsOrigin().y, GetGroundPosition(self:GetAbsOrigin(), self).z))		
		FindClearSpaceForUnit(self, self:GetAbsOrigin(), true)
        ResolveNPCPositions(self:GetAbsOrigin(), 64)
        ]]
	end
end

function snapfire_spit_creep_lua_movement:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function snapfire_spit_creep_lua_movement:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function snapfire_spit_creep_lua_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function snapfire_spit_creep_lua_movement:CheckState()
	
	return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function snapfire_spit_creep_lua_movement:HorizontalMotion( me, dt )
	if IsServer() then
		-- If the unit being tossed died, interrupt motion controllers and remove self (nah lul)
		-- if not self.parent:IsAlive() then
			-- self.parent:InterruptMotionControllers(true)
			-- self:Destroy()
		-- end

		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.toss_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function snapfire_spit_creep_lua_movement:VerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.toss_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.toss_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			self:TossLand()
		end
	end
end

-- Snapfire Spit Creep Thinker
snapfire_spit_creep_lua_thinker = class({})

function snapfire_spit_creep_lua_thinker:OnCreated()
    if IsClient() then return end
    self:PlayEffects(self:GetParent():GetAbsOrigin())
end

function snapfire_spit_creep_lua_thinker:PlayEffects(loc)
    -- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf"
	local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end


-- Aura Properties
function snapfire_spit_creep_lua_thinker:IsAura()
	return true
end

function snapfire_spit_creep_lua_thinker:GetModifierAura()
	return "snapfire_spit_creep_lua_thinker_aura"
end

function snapfire_spit_creep_lua_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function snapfire_spit_creep_lua_thinker:GetAuraRadius()
	return 275
end

function snapfire_spit_creep_lua_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function snapfire_spit_creep_lua_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-- Aura Modifier
snapfire_spit_creep_lua_thinker_aura = class({})

function snapfire_spit_creep_lua_thinker_aura:IsPurgable() return false end
function snapfire_spit_creep_lua_thinker_aura:IsHidden() return true end

-- Aura Effects
function snapfire_spit_creep_lua_thinker_aura:OnCreated()
    if IsClient() then return end
    self:StartIntervalThink(0.5)
    self:OnIntervalThink()
end

function snapfire_spit_creep_lua_thinker_aura:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = 50,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility()
    })
end

function snapfire_spit_creep_lua_thinker_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function snapfire_spit_creep_lua_thinker_aura:GetModifierMoveSpeedBonus_Percentage()
	return -25
end
