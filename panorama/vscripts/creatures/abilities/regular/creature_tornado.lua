LinkLuaModifier("modifier_creature_tornado", "creatures/abilities/regular/creature_tornado", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_tornado_slow", "creatures/abilities/regular/creature_tornado", LUA_MODIFIER_MOTION_NONE)

creature_tornado = class({})

function creature_tornado:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

function creature_tornado:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		if (not caster.spawn_team) or (not GameMode.arena_centers[caster.spawn_team]) then
			return nil
		end

		self.slow_duration = self:GetSpecialValueFor("slow_duration")
		self.stun_duration = self:GetSpecialValueFor("stun_duration")
		self.spawn_duration = self:GetSpecialValueFor("spawn_duration")
		self.spawn_interval = self:GetSpecialValueFor("spawn_interval")
		self.damage = self:GetSpecialValueFor("damage")
		self.radius = self:GetSpecialValueFor("radius")
		self.speed = self:GetSpecialValueFor("speed")
		self.elapsed_time = 0
		self.accumulated_tick = 0
		self.tornados = {}

		self.arena_center = GameMode.arena_centers[caster.spawn_team]

		if GameMode:IsSoloMap() then
			self.max_x = 896
			self.max_y = 896
		elseif GetMapName() == "duos" then
			self.max_x = 1152
			self.max_y = 896
		end

		caster:EmitSound("n_creep_Wildkin.Tornado")

		self:LaunchTornado(RandomVector(1))
	end
end

function creature_tornado:LaunchTornado(direction)
	local caster = self:GetCaster()
	local tornado_loc = caster:GetAbsOrigin() + direction * 200

	caster:EmitSound("n_creep_Wildkin.SummonTornado")

	local spawn_pfx = ParticleManager:CreateParticle("particles/creature/tornado_spawn.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(spawn_pfx, 0, tornado_loc)

	Timers:CreateTimer(self.spawn_duration, function()
		caster:EmitSound("CreatureTornado.Cast")
		caster:EmitSound("CreatureTornado.Launch")

		ParticleManager:DestroyParticle(spawn_pfx, false)
		ParticleManager:ReleaseParticleIndex(spawn_pfx)

		local tornado_projectile = {
			Ability				=	self,
			EffectName			=	"particles/creature/tornado.vpcf",
			vSpawnOrigin		=	tornado_loc,
			fDistance			=	300000,
			fStartRadius		=	self.radius,
			fEndRadius			=	self.radius,
			Source				=	caster,
			bHasFrontalCone		=	false,
			bReplaceExisting	=	false,
			iUnitTargetTeam		=	DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	=	DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		=	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		=	GameRules:GetGameTime() + 300,
			bDeleteOnHit		=	true,
			vVelocity			=	direction * self.speed,
			bProvidesVision		=	false
		}

		table.insert(self.tornados, ProjectileManager:CreateLinearProjectile(tornado_projectile))
	end)
end

function creature_tornado:OnChannelThink(interval)
	if IsServer() then
		local caster = self:GetCaster()

		self.elapsed_time = self.elapsed_time + interval
		self.accumulated_tick = self.accumulated_tick + interval

		if self.accumulated_tick > self.spawn_interval then
			self.accumulated_tick = self.accumulated_tick - self.spawn_interval
			self:LaunchTornado(RandomVector(1))
		end
	end
end

function creature_tornado:OnChannelFinish(interrupted)
	if IsServer() then
		self:GetCaster():StopSound("n_creep_Wildkin.Tornado")

		for _, tornado_id in pairs(self.tornados) do
			ProjectileManager:DestroyLinearProjectile(tornado_id)
		end
	end
end

function creature_tornado:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

function creature_tornado:OnProjectileHit(unit, location)
	if IsServer() then
		if (not unit:IsMagicImmune()) then
			unit:AddNewModifier(self:GetCaster(), self, "modifier_creature_tornado", {duration = self.stun_duration, slow_duration = self.slow_duration, damage = self.damage})
			return true
		else
			return false
		end
	end
end

function creature_tornado:OnProjectileThinkHandle(tornado)
	if IsServer() then
		local caster = self:GetCaster()
		local position = ProjectileManager:GetLinearProjectileLocation(tornado)
		local velocity = ProjectileManager:GetLinearProjectileVelocity(tornado):Normalized()
		local create_tornado = false
		local new_velocity = Vector(velocity.x, velocity.y, 0)

		if math.abs(position.x - self.arena_center.x) >= self.max_x then
			create_tornado = true
			new_velocity = Vector((-1) * new_velocity.x, new_velocity.y, 0)
		end

		if math.abs(position.y - self.arena_center.y) >= self.max_y then
			create_tornado = true
			new_velocity = Vector(new_velocity.x, (-1) * new_velocity.y, 0)
		end

		if create_tornado then
			table.remove(self.tornados, tornado)
			ProjectileManager:DestroyLinearProjectile(tornado)

			local tornado_projectile = {
				Ability				= self,
				EffectName			= "particles/creature/tornado.vpcf",
				vSpawnOrigin		= position,
				fDistance			= 300000,
				fStartRadius		= self.radius,
				fEndRadius			= self.radius,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 300,
				bDeleteOnHit		= true,
				vVelocity			= new_velocity * self.speed,
				bProvidesVision		= false
			}

			table.insert(self.tornados, ProjectileManager:CreateLinearProjectile(tornado_projectile))
		end

		GridNav:DestroyTreesAroundPoint(position, self.radius, false)
	end
end		





modifier_creature_tornado = class({})

function modifier_creature_tornado:IsDebuff() return true end
function modifier_creature_tornado:IsHidden() return false end
function modifier_creature_tornado:IsPurgable() return true end
function modifier_creature_tornado:IsMotionController() return true end
function modifier_creature_tornado:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end

function modifier_creature_tornado:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		parent:StartGesture(ACT_DOTA_FLAIL)

		self.slow_duration = keys.slow_duration
		self.damage = keys.damage

		self.movement_origin = parent:GetAbsOrigin()
		self.facing_origin = parent:GetForwardVector()
		self.angle_origin = parent:GetAngles()
		self.initial_height = self.movement_origin.z

		self:StartIntervalThink(0.03)
	end
end

function modifier_creature_tornado:OnIntervalThink()
	if IsServer() then
		if not self then return end

		local parent = self:GetParent()
		local elapsed_time = self:GetElapsedTime()

		-- Turn the unit
		local angle = parent:GetAngles()
		local new_angle = RotateOrientation(angle, QAngle(0, 15, 0))
		parent:SetAngles(new_angle[1], new_angle[2], new_angle[3])

		-- Move the unit horizontally
		local distance_from_center = 35 * math.cos(2 * math.pi * elapsed_time / 0.7)
		local horizontal_position = RotatePosition(self.movement_origin + self.facing_origin * distance_from_center, QAngle(0, 360 * elapsed_time / 0.7, 0), self.movement_origin)

		-- Move the unit vertically
		local vertical_position = self.initial_height + 300
		if elapsed_time <= 0.2 then
			vertical_position = self.initial_height + 300 * elapsed_time / 0.2
		elseif elapsed_time > 0.5 then
			vertical_position = self.initial_height + 300 * (1 - (elapsed_time - 0.5) / 0.2)
		end
		vertical_position = vertical_position + 75 * math.sin(2 * math.pi * elapsed_time / 0.7)
		parent:SetAbsOrigin(Vector(horizontal_position.x, horizontal_position.y, vertical_position))
	end
end

function modifier_creature_tornado:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()

		parent:FadeGesture(ACT_DOTA_FLAIL)
		parent:SetAbsOrigin(self.movement_origin)
		ResolveNPCPositions(self.movement_origin, 128)
		parent:SetAngles(self.angle_origin[1], self.angle_origin[2], self.angle_origin[3])

		parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_creature_tornado_slow", {duration = self.slow_duration})
		ApplyDamage({victim = parent, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_creature_tornado:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	return state
end



modifier_creature_tornado_slow = class({})

function modifier_creature_tornado_slow:IsHidden() return false end
function modifier_creature_tornado_slow:IsDebuff() return true end
function modifier_creature_tornado_slow:IsPurgable() return true end

function modifier_creature_tornado_slow:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	self.slow = ability:GetSpecialValueFor("slow")
end

function modifier_creature_tornado_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_creature_tornado_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_creature_tornado_slow:GetModifierAttackSpeedBonus_Constant()
	return self.slow
end
