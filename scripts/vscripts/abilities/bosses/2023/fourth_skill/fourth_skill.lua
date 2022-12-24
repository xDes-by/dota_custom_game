LinkLuaModifier("modifier_tiny_toss_movement", "abilities/bosses/2023/fourth_skill/fourth_skill", LUA_MODIFIER_MOTION_NONE)

hero_destroyer_fourth_skill = hero_destroyer_fourth_skill or class({})

points_2023 = {
	[1] = {624, -9706, 256},
	[2] = {9992, -11263, 256},
	[3] = {9449, -4205, 128},
	[4] = {-9472, -10752, 384},
	[5] = {2924, -1678, 512},
	[6] = {-7863, -5518, 279},
	[7] = {11235, 468, 256},
	[8] = {7744, 6259, 128},
}

function hero_destroyer_fourth_skill:OnSpellStart()
	pt = points_2023[RandomInt(1,8)]
	self.tossPosition = Vector(pt[1],pt[2],pt[3])
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	local tossVictim = caster
	local duration = 2

	local vLocation = self.tossPosition
	local kv =
	{
		vLocX = vLocation.x,
		vLocY = vLocation.y,
		vLocZ = vLocation.z,
		duration = duration,
		damage = self:GetSpecialValueFor("damage")
	}

	hTarget:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
	ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = hTarget:GetMaxHealth()/100*self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = self.ability})
		
	caster:StartGesture(ACT_TINY_TOSS)
	EmitSoundOn("Ability.TossThrow", self:GetCaster())
end

---------------------------------------------------------------------------------------------------------

modifier_tiny_toss_movement = modifier_tiny_toss_movement or class({})

function modifier_tiny_toss_movement:IsDebuff() return true end
function modifier_tiny_toss_movement:IsStunDebuff() return true end
function modifier_tiny_toss_movement:RemoveOnDeath() return false end
function modifier_tiny_toss_movement:IsHidden() return true end
function modifier_tiny_toss_movement:IgnoreTenacity() return true end
function modifier_tiny_toss_movement:IsMotionController() return true end
function modifier_tiny_toss_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_tiny_toss_movement:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:OnCreated( kv )
	self.toss_minimum_height_above_lowest = 500
	self.toss_minimum_height_above_highest = 100
	self.toss_acceleration_z = 4000
	self.toss_max_horizontal_acceleration = 3000

	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		EmitSoundOn("Hero_Tiny.Toss.Target", self:GetParent())

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.damage = kv.damage
		self.vLastKnownTargetPos = self.vLoc

		print(self.vStartPosition)
		print(self.vLoc)


		local duration = 2
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

function modifier_tiny_toss_movement:OnIntervalThink()
	if IsServer() then
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end
		self:HorizontalMotion(self.parent, self.frametime)
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_tiny_toss_movement:TossLand()
	if IsServer() then
		if self.toss_land_commenced then
			return nil
		end

		self.toss_land_commenced = true

		GridNav:DestroyTreesAroundPoint(self.vLastKnownTargetPos, 300, true)

		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetParent():GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PHYSICAL, ability = self.ability})
	
		EmitSoundOn("Ability.TossImpact", self.parent)
	end
end

function modifier_tiny_toss_movement:OnDestroy()
	if IsServer() then
		--self.parent:SetUnitOnClearGround()
	end
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_movement:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				return {[MODIFIER_STATE_STUNNED] = true}
			else
				return {[MODIFIER_STATE_ROOTED] = true}
			end
		end
	end
	
	return {}
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:HorizontalMotion( me, dt )
	if IsServer() then

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

function modifier_tiny_toss_movement:VerticalMotion( me, dt )
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


function modifier_tiny_toss_movement:CheckMotionControllers()
	local parent = self:GetParent()
	local modifier_priority = self:GetMotionControllerPriority()
	local is_motion_controller = false
	local motion_controller_priority
	local found_modifier_handler

	local non_imba_motion_controllers =
	{"modifier_brewmaster_storm_cyclone",
	 "modifier_dark_seer_vacuum",
	 "modifier_eul_cyclone",
	 "modifier_earth_spirit_rolling_boulder_caster",
	 "modifier_huskar_life_break_charge",
	 "modifier_invoker_tornado",
	 "modifier_item_forcestaff_active",
	 "modifier_rattletrap_hookshot",
	 "modifier_phoenix_icarus_dive",
	 "modifier_shredder_timber_chain",
	 "modifier_slark_pounce",
	 "modifier_spirit_breaker_charge_of_darkness",
	 "modifier_tusk_walrus_punch_air_time",
	 "modifier_earthshaker_enchant_totem_leap"}
	

	-- Fetch all modifiers
	local modifiers = parent:FindAllModifiers()	

	for _,modifier in pairs(modifiers) do		
		-- Ignore the modifier that is using this function
		if self ~= modifier then			

			-- Check if this modifier is assigned as a motion controller
			if modifier.IsMotionController then
				if modifier:IsMotionController() then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- Get the motion controller priority
					motion_controller_priority = modifier:GetMotionControllerPriority()

					-- Stop iteration					
					break
				end
			end

			-- If not, check on the list
			for _,non_imba_motion_controller in pairs(non_imba_motion_controllers) do				
				if modifier:GetName() == non_imba_motion_controller then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- We assume that vanilla controllers are the highest priority
					motion_controller_priority = DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST

					-- Stop iteration					
					break
				end
			end
		end
	end

	-- If this is a motion controller, check its priority level
	if is_motion_controller and motion_controller_priority then

		-- If the priority of the modifier that was found is higher, override
		if motion_controller_priority > modifier_priority then			
			return false

		-- If they have the same priority levels, check which of them is older and remove it
		elseif motion_controller_priority == modifier_priority then			
			if found_modifier_handler:GetCreationTime() >= self:GetCreationTime() then				
				return false
			else				
				found_modifier_handler:Destroy()
				return true
			end

		-- If the modifier that was found is a lower priority, destroy it instead
		else			
			parent:InterruptMotionControllers(true)
			found_modifier_handler:Destroy()
			return true
		end
	else
		-- If no motion controllers were found, apply
		return true
	end
end
