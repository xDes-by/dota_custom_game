AI = {}

AI.Init = function( self )
	-- Defer the initialization to first tick, to allow spawners to set state.
	self.aiState = {
		hAggroTarget = nil,
		flShoutRange = 100,
		nWalkingMoveSpeed = 280,
		nAggroMoveSpeed = 380,
		flAcquisitionRange = 1000,
		vTargetWaypoint = nil,
		isAttacking = false,
	}
	self:SetContextThink( "init_think", function() 
		self.aiThink = aiThink
		self.CheckIfHasAggro = CheckIfHasAggro
		self.RoamBetweenWaypoints = RoamBetweenWaypoints
		self:SetAcquisitionRange( self.aiState.flAcquisitionRange )
		self.bIsRoaring = false
		
		local tWaypoints = {}
		local nWaypointsPerRoamNode = 3
		local nMinWaypointSearchDistance = 0
		local nMaxWaypointSearchDistance = 1048

		while #tWaypoints < nWaypointsPerRoamNode do
			local vWaypoint = self:GetAbsOrigin() + RandomVector( RandomFloat( nMinWaypointSearchDistance, nMaxWaypointSearchDistance ) )
			if GridNav:CanFindPath( self:GetAbsOrigin(), vWaypoint ) then
				table.insert( tWaypoints, vWaypoint )
			end
		end
		self.aiState.tWaypoints = tWaypoints
		self:SetContextThink( "ai_base_creature.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end


function aiThink( self )
	if not self:IsAlive() then
		return
	end
	if GameRules:IsGamePaused() then
		return 0.1
	end
	local agro = self:CheckIfHasAggro()
	if agro then
		return agro
	end
	return self:RoamBetweenWaypoints()
end


function CheckIfHasAggro( self )
	if self:GetAggroTarget() ~= nil then
		self:SetBaseMoveSpeed( self.aiState.nAggroMoveSpeed )
		if self:GetAggroTarget() ~= self.aiState.hAggroTarget then
			self.aiState.hAggroTarget = self:GetAggroTarget()
		end
		 
	--[[	local existingParticle = self:Attribute_GetIntValue( "particleID", -1 )
		if existingParticle == -1 then
			local nAggroParticleID = ParticleManager:CreateParticle( "particles/items2_fx/mask_of_madness.vpcf", PATTACH_OVERHEAD_FOLLOW, self )
			ParticleManager:SetParticleControlEnt( nAggroParticleID, PATTACH_OVERHEAD_FOLLOW, self, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self:GetAbsOrigin(), true )
			self:Attribute_SetIntValue( "particleID", nAggroParticleID )
		end]]
		
		if not self.aiState.isAttacking then
			self.aiState.ChasingStartPos = self:GetAbsOrigin()
	 		self.aiState.isAttacking = true
	 	else
	 		local distance = (self:GetAbsOrigin() - self.aiState.ChasingStartPos):Length2D()
	 		if distance > 1000 then
	 			self:MoveToPosition(self.aiState.ChasingStartPos)
	 			return distance / 200
	 		end
		end

	 	return RandomFloat(0.5, 1)
	else
	--[[	local nAggroParticleID = self:Attribute_GetIntValue( "particleID", -1 )
		if nAggroParticleID ~= -1 then
			ParticleManager:DestroyParticle( nAggroParticleID, true )
			self:DeleteAttribute( "particleID" )
		end	]]	
		self:SetBaseMoveSpeed( self.aiState.nWalkingMoveSpeed )
		self.bIsRoaring = false
		return nil
	end
end


function RoamBetweenWaypoints( self )
	local gameTime = GameRules:GetGameTime()
	local aiState = self.aiState
	if aiState.vWaypoint ~= nil then
		local flRoamTimeLeft = aiState.flNextWaypointTime - gameTime
		if flRoamTimeLeft <= 0 then
			aiState.vWaypoint = nil
		end
	end
	if aiState.vWaypoint == nil then
	 aiState.vWaypoint = aiState.tWaypoints[ RandomInt( 1, #aiState.tWaypoints ) ]
	 aiState.flNextWaypointTime = gameTime + RandomFloat( 2, 4 )
		self:MoveToPositionAggressive( aiState.vWaypoint )
	end
	return RandomFloat( 0.5, 1.0 )
end

function Spawn( entityKeyValues )
    AI.Init( thisEntity )
end
