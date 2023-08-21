death_prophet_exorcism_bh = class({})

function death_prophet_exorcism_bh:GetIntrinsicModifierName()
	return "modifier_death_prophet_exorcism_bh_talent"
end

function death_prophet_exorcism_bh:OnSpellStart()
	local caster = self:GetCaster()
	
	caster:RemoveModifierByName("modifier_death_prophet_exorcism_bh")
	caster:AddNewModifier( caster, self, "modifier_death_prophet_exorcism_bh", {duration = self:GetDuration()})
	
	caster:EmitSound("Hero_DeathProphet.Exorcism.Cast")
	ParticleManager:FireParticle("particles/units/heroes/hero_death_prophet/death_prophet_spawn.vpcf", PATTACH_POINT_FOLLOW, caster)
end

function death_prophet_exorcism_bh:CreateGhost(parent, radius, duration)
	local caster = self:GetCaster()
	local speed = self:GetSpecialValueFor("spirit_speed")
	local turnSpeed = 150
	local give_up_distance = self:GetSpecialValueFor("give_up_distance")
	local max_distance = self:GetSpecialValueFor("max_distance")
	local damage = self:GetSpecialValueFor("average_damage") + caster:GetIntellect() * self:GetSpecialValueFor("int_dmg")
	if caster:FindAbilityByName("npc_dota_hero_death_prophet_int6") then
		damage = damage + caster:GetIntellect() * 0.75
	end
	if caster:FindAbilityByName("npc_dota_hero_death_prophet_agi8") then
		damage = damage + caster:GetAgility() * 0.50
	end
	local damageType = DAMAGE_TYPE_MAGICAL
	local stateList = {ORBITING = 1, SEEKING = 2, RETURNING = 3}
	local direction = TernaryOperator( parent:GetRightVector(), RollPercentage(50), parent:GetRightVector() * (-1) )
	local position = parent:GetAbsOrigin() + direction * 180
	
	parent.nearbyEnemies = parent:FindEnemyUnitsInRadius(parent:GetAbsOrigin(), radius )
	local ProjectileThink = function(self)
		local position = self:GetPosition()
		local velocity = self:GetVelocity()
		local speed = self:GetSpeed()
		local parentDistance = CalculateDistance( parent, position )
		if velocity.z > 0 then velocity.z = 0 end
		if self.state == stateList.ORBITING then
			local distance = self.orbitRadius - parentDistance
			local direction = CalculateDirection( position, parent)
			self:SetVelocity( GetPerpendicularVector( direction ) * speed * (-1)^self.orientation + direction * distance )
			self:SetPosition( GetGroundPosition( position + (self:GetVelocity()*ProjectileManager:FrameTime()), nil ) )
			local newTarget = parent:GetAttackTarget() or parent.nearbyEnemies[RandomInt(1, #parent.nearbyEnemies)]
			if newTarget then
				self.seekTarget = newTarget
				self.state = stateList.SEEKING
			end
		elseif self.state == stateList.SEEKING then
			if self.seekTarget and not self.seekTarget:IsNull() and self.seekTarget:IsAlive() then
				local distance = CalculateDistance( position, self.seekTarget )
				local targetPos = self.seekTarget:GetAbsOrigin()
				local direction = CalculateDirection( self.seekTarget, position)
				local distVect = distance * direction
				local comparator = velocity - distVect
				
				local angle = math.deg( math.atan2(distVect.y, distVect.x) - math.atan2(velocity.y, velocity.x) )
				if angle > 360 then
					angle = angle - 360
				end
				angle = math.abs( angle )
				local direction = RotateVector2D( velocity, ToRadians( math.min( self.turn_speed, angle ) ) * ProjectileManager:FrameTime() )
				self:SetVelocity( direction * speed + CalculateDirection( self.seekTarget, position ) * math.max(100, (500 - distance) ) )
				local newPosition = GetGroundPosition( position + (velocity*ProjectileManager:FrameTime()), nil )
				self:SetPosition( newPosition )
				if distance <= self:GetRadius() + self.seekTarget:GetHullRadius() + self.seekTarget:GetCollisionPadding() then
					local status, err, ret = pcall(self.hitBehavior, self, self.seekTarget, newPosition)
					if not status then
						print(err)
						self:Remove()
					elseif not err then -- if no errors then xpcall doesn't return to err; so ret gets shoved back
						self:Remove()
						return nil
					end
				end
			else
				self.state = stateList.RETURNING
			end
		elseif self.state == stateList.RETURNING then
			local distance = CalculateDistance( position, parent )
			local targetPos = parent:GetAbsOrigin()
			local direction = CalculateDirection( parent, position)
			local distVect = distance * direction
			local comparator = velocity - distVect
			
			local angle = math.deg( math.atan2(distVect.y, distVect.x) - math.atan2(velocity.y, velocity.x) )
			if angle > 360 then
				angle = angle - 360
			end
			angle = math.abs( angle )
			
			local direction = RotateVector2D( velocity, ToRadians( math.min( self.turn_speed, angle ) ) * ProjectileManager:FrameTime() )
			self:SetVelocity( direction * speed + CalculateDirection( parent, position ) * math.max(100, (500 - distance) ) )
			self:SetPosition( GetGroundPosition( position + (velocity*ProjectileManager:FrameTime()), nil ) )
			if parentDistance < ( self:GetRadius() + parent:GetHullRadius() + parent:GetCollisionPadding() ) then
				self.state = stateList.ORBITING
				if parent:FindAbilityByName("npc_dota_hero_death_prophet_str10") then
					local heal = parent:GetMaxHealth() * 0.03
					parent:Heal( heal,nil)
					SendOverheadEventMessage( parent, OVERHEAD_ALERT_HEAL , parent, heal, nil )
				end
			end
		end
		if parentDistance > self.maxRadius then
			self:Remove()
		end
	end
	
	local ProjectileHit = function(self, target, position)
		local ability = self:GetAbility()
		if self.seekTarget then
			self.state = stateList.RETURNING
			self.seekTarget = nil
			local damage = self.damage
			local critical_strike = false
			if caster:FindAbilityByName("npc_dota_hero_death_prophet_int_last") and RollPseudoRandomPercentage(5, caster:entindex(), caster) then
				damage = damage * (1 + caster:GetIntellect() / 100)
				critical_strike = true
			end
			local enemies = {}
			table.insert(enemies, target)
			if caster:FindAbilityByName("npc_dota_hero_death_prophet_agi11") then
				enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					target:GetOrigin(),	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					150,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
					0,	-- int, flag filter
					0,	-- int, order filter
					false	-- bool, can grow cache
				)
			end
			for _, enemy in pairs(enemies) do
				if enemy == target then
					ability:DealDamage( caster, enemy, damage, {damage_type = self.damageType} )
					if critical_strike then
						SendOverheadEventMessage( parent, OVERHEAD_ALERT_DEADLY_BLOW , enemy, damage, nil )
					end
					if caster:FindAbilityByName("npc_dota_hero_death_prophet_agi_last") then
						caster:PerformAttack(
							enemy, -- hTarget
							true, -- bUseCastAttackOrb
							true, -- bProcessProcs
							true, -- bSkipCooldown
							false, -- bIgnoreInvis
							false, -- bUseProjectile
							false, -- bFakeAttack
							false -- bNeverMiss
						)
					end
					
				else
					ability:DealDamage( caster, enemy, damage * 0.7, {damage_type = self.damageType} )
				end
			end
		end
		return true
	end
	local projectile = ProjectileHandler:CreateProjectile(ProjectileThink, ProjectileHit, {  FX = "particles/units/heroes/hero_death_prophet/death_prophet_spirit_model.vpcf",
																		  position = position,
																		  caster = self:GetCaster(),
																		  ability = self,
																		  speed = speed,
																		  radius = 24,
																		  velocity = speed * parent:GetForwardVector(),
																		  turn_speed = turnSpeed,
																		  state = stateList.ORBITING,
																		  orbitRadius = math.random() * radius + 50,
																		  maxRadius = max_distance,
																		  damage = damage,
																		  damageType = damageType,
																		  giveUpDistance = give_up_distance,
																		  orientation = RandomInt(1,10),
																		  damageDealt = 0,
																		  duration = duration,
																		  isUniqueProjectile = true})
	return projectile
end

modifier_death_prophet_exorcism_bh = class({})
LinkLuaModifier( "modifier_death_prophet_exorcism_bh", "heroes/hero_death_prophet/death_prophet_exorcism_bh/death_prophet_exorcism_bh", LUA_MODIFIER_MOTION_NONE)

function modifier_death_prophet_exorcism_bh:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_death_prophet_exorcism_bh:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_bonus
end

function modifier_death_prophet_exorcism_bh:GetModifierHealthBonus()
	return self.health_bonus
end


function modifier_death_prophet_exorcism_bh:OnCreated()
	self.spawnRate = self:GetAbility():GetSpecialValueFor("ghost_spawn_rate")
	self.maxGhosts = self:GetAbility():GetSpecialValueFor("spirits")
	self.seekRadius = self:GetAbility():GetSpecialValueFor("radius")
	self.movement_bonus = self:GetAbility():GetSpecialValueFor("movement_bonus") - self:GetAbility():GetSpecialValueFor("movement_base")
	self.health_bonus = 0
	if self:GetCaster():FindAbilityByName("npc_dota_hero_death_prophet_str7") then
		self.health_bonus = self:GetCaster():GetStrength() * 10
	end
	if IsServer() then
		self:StartIntervalThink( self.spawnRate )
		self:GetCaster():EmitSound("Hero_DeathProphet.Exorcism")
		self.ghostList = {}
	end
end

if IsServer() then
	
	
	function modifier_death_prophet_exorcism_bh:OnIntervalThink()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		caster.nearbyEnemies = caster:FindEnemyUnitsInRadius(caster:GetAbsOrigin(), self.seekRadius)
		if self:GetGhostCount() >= self.maxGhosts then return end
		local ghost = self:GetAbility():CreateGhost(self:GetCaster(), ability:GetSpecialValueFor("radius"), self:GetDuration())
		table.insert( self.ghostList, ghost )
	end
	
	function modifier_death_prophet_exorcism_bh:OnDestroy()
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		caster:StopSound("Hero_DeathProphet.Exorcism")
		if not caster:IsAlive() and caster:HasTalent("special_bonus_unique_death_prophet_exorcism_1") then
			local respawnPosition = caster:GetAbsOrigin()
			caster:RespawnHero(false, false)
			caster:SetHealth(1)
			caster:SetAbsOrigin( respawnPosition )
		end
		local heal = 0
		for _, ghost in ipairs( self:GetGhosts() ) do
			heal = heal + ghost.damageDealt
			ghost:Remove()
		end
		if caster:IsAlive() then
			caster:HealEvent( heal, ability, caster )
		end
	end
	
	function modifier_death_prophet_exorcism_bh:GetGhosts()
		return self.ghostList
	end

	function modifier_death_prophet_exorcism_bh:GetGhostCount()
		for i = #self.ghostList, 1, -1 do
			if not ProjectileHandler.projectiles[self.ghostList[i].uniqueProjectileID] then
				table.remove(self.ghostList, i)
			end
		end
		return #self.ghostList
	end
end

modifier_death_prophet_exorcism_bh_talent = class({})
LinkLuaModifier( "modifier_death_prophet_exorcism_bh_talent", "heroes/hero_death_prophet/death_prophet_exorcism_bh/death_prophet_exorcism_bh", LUA_MODIFIER_MOTION_NONE)

function modifier_death_prophet_exorcism_bh_talent:OnCreated()
	self.movement_base = self:GetAbility():GetSpecialValueFor("movement_base")
end

function modifier_death_prophet_exorcism_bh_talent:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}
end

function modifier_death_prophet_exorcism_bh_talent:OnDeath(params)
	if params.attacker == self:GetParent() and self:GetParent():HasTalent("special_bonus_unique_death_prophet_exorcism_2") and not params.unit:IsMinion() then
		local ghosts = 1
		local roll = RollPercentage(50)
		if params.unit:IsBoss() then
			ghosts = 2
		end
		if roll or params.unit:IsBoss() then
			for i = 1, ghosts do
				self:GetAbility():CreateGhost( self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetDuration() )
			end
		end
	end
end

function modifier_death_prophet_exorcism_bh_talent:IsHidden()
	return true
end

function modifier_death_prophet_exorcism_bh_talent:IsPurgable()
	return false
end

function modifier_death_prophet_exorcism_bh_talent:RemoveOnDeath()
	return false
end

function modifier_death_prophet_exorcism_bh_talent:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_base
end
