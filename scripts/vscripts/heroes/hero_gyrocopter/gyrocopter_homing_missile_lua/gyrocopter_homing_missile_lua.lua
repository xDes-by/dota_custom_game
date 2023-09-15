LinkLuaModifier("modifier_gyrocopter_homing_missile_lua_pre_flight", "heroes/hero_gyrocopter/gyrocopter_homing_missile_lua/gyrocopter_homing_missile_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_homing_missile_lua", "heroes/hero_gyrocopter/gyrocopter_homing_missile_lua/gyrocopter_homing_missile_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_homing_missile_lua_handler", "heroes/hero_gyrocopter/gyrocopter_homing_missile_lua/gyrocopter_homing_missile_lua", LUA_MODIFIER_MOTION_NONE)

-----------------------------------------------------------------
gyrocopter_homing_missile_lua = gyrocopter_homing_missile_lua or class({})

function gyrocopter_homing_missile_lua:GetIntrinsicModifierName()
	return "modifier_gyrocopter_homing_missile_lua_handler"
end

function gyrocopter_homing_missile_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100) 
end

function gyrocopter_homing_missile_lua:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target then
		if target:GetTeam() ~= self:GetCaster():GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end
	end

	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_homing_missile_fire_02",
				"gyrocopter_gyro_homing_missile_fire_03",
				"gyrocopter_gyro_homing_missile_fire_04",
				"gyrocopter_gyro_homing_missile_fire_06",
				"gyrocopter_gyro_homing_missile_fire_07"
			}
		end
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end

	local missile_starting_position = nil
	local pre_flight_time = self:GetSpecialValueFor("pre_flight_time")
	
	count = 1
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int11") ~= nil then 
		count = 3
	end	

	for i = 1, count do
		set_point = i * 200
		missile_starting_position = self:GetCaster():GetAbsOrigin() + ((self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * set_point)
			
		local missile = CreateUnitByName("npc_dota_gyrocopter_homing_missile", missile_starting_position, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		missile:AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_homing_missile_lua_pre_flight", {duration = pre_flight_time})
		missile:AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_homing_missile_lua", {})

		missile:SetForwardVector((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized())
		missile:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		
		local fuse_particle = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_homing_missile_fuse.vpcf", PATTACH_ABSORIGIN, missile)
		ParticleManager:SetParticleControlForward(fuse_particle, 0, missile:GetForwardVector() * (-1))
		ParticleManager:ReleaseParticleIndex(fuse_particle)
	end
end

--------------------------------------------------------

modifier_gyrocopter_homing_missile_lua_handler = modifier_gyrocopter_homing_missile_lua_handler or class({})

function modifier_gyrocopter_homing_missile_lua_handler:IsHidden() return true end
function modifier_gyrocopter_homing_missile_lua_handler:IsPurgable() return false end
function modifier_gyrocopter_homing_missile_lua_handler:RemoveOnDeath()	return false end

function modifier_gyrocopter_homing_missile_lua_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_gyrocopter_homing_missile_lua_handler:OnAttackLanded( params )
	local caster = self:GetCaster()
	local target = params.target
	if params.attacker~=self:GetParent() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str10") ~= nil and RandomInt(1, 100) <= 2 then
		missile_starting_position = self:GetCaster():GetAbsOrigin() + ((self:GetCaster():GetAbsOrigin()):Normalized() * 200)
		_G.hmt = target	
		local missile = CreateUnitByName("npc_dota_gyrocopter_homing_missile", missile_starting_position, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		missile:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_homing_missile_lua_pre_flight", {duration = 3})
		missile:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_homing_missile_lua", {})

		

		missile:SetForwardVector((self:GetCaster():GetAbsOrigin()):Normalized())
		missile:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		
		local fuse_particle = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_homing_missile_fuse.vpcf", PATTACH_ABSORIGIN, missile)
		ParticleManager:SetParticleControlForward(fuse_particle, 0, missile:GetForwardVector() * (-1))
		ParticleManager:ReleaseParticleIndex(fuse_particle)
	end
end
--------------------------------------------------------

modifier_gyrocopter_homing_missile_lua_pre_flight = modifier_gyrocopter_homing_missile_lua_pre_flight or class({})

function modifier_gyrocopter_homing_missile_lua_pre_flight:IsHidden() return true end
function modifier_gyrocopter_homing_missile_lua_pre_flight:IsPurgable()	return false end

function modifier_gyrocopter_homing_missile_lua_pre_flight:OnCreated(keys)
	self.speed = self:GetAbility():GetSpecialValueFor("speed")

	self.interval = 1 / self:GetAbility():GetSpecialValueFor("acceleration")
	
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Enemy")

	if self:GetAbility():GetCursorTarget() then
		self.target	= self:GetAbility():GetCursorTarget() 
	else
		self.target = _G.hmt
	end
end

function modifier_gyrocopter_homing_missile_lua_pre_flight:OnDestroy()
	if not IsServer() then return end
	
	if not self:GetParent():IsAlive() then return end
	
	self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile.Enemy")
	
	if self:GetParent():HasModifier("modifier_gyrocopter_homing_missile_lua") then
		self:GetParent():SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		
		if self.target and not self.target:IsNull() and self.target:IsAlive() then
			self:GetParent():MoveToNPC(self.target)
		else
			local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_particle)
			
			self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
			self:GetParent():ForceKill(false)
			self:GetParent():AddNoDraw()
			return
		end
		
		self:GetParent():FindModifierByName("modifier_gyrocopter_homing_missile_lua"):StartIntervalThink(self.interval)
		
		local missile_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(missile_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_fuse", self:GetParent():GetAbsOrigin(), true)
		self:GetParent():FindModifierByName("modifier_gyrocopter_homing_missile_lua"):AddParticle(missile_particle, false, false, -1, false, false)
	else
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
end

---------------------------------------------
modifier_gyrocopter_homing_missile_lua = modifier_gyrocopter_homing_missile_lua or class({})

function modifier_gyrocopter_homing_missile_lua:IsHidden()		return true end
function modifier_gyrocopter_homing_missile_lua:IsPurgable()	return false end

function modifier_gyrocopter_homing_missile_lua:OnCreated(keys)
	self.pre_flight_time			= self:GetAbility():GetSpecialValueFor("pre_flight_time")
	self.damage						= self:GetAbility():GetSpecialValueFor("damage")
	self.speed						= self:GetAbility():GetSpecialValueFor("speed")
	self.acceleration				= self:GetAbility():GetSpecialValueFor("acceleration")
	self.enemy_vision_time			= self:GetAbility():GetSpecialValueFor("enemy_vision_time")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str9") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetStrength()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int7") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetIntellect()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi11") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetAgility()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int10") ~= nil then 
		if self:GetCaster():GetIntellect() > self:GetCaster():GetStrength() and self:GetCaster():GetIntellect() > self:GetCaster():GetAgility() then
			self.damage = self.damage * 2
		end
	end	
	
	if not IsServer() then return end
	
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.damage_type = self:GetAbility():GetAbilityDamageType()

	if self:GetAbility():GetCursorTarget() then
		self.target	= self:GetAbility():GetCursorTarget() 
	else
		self.target = _G.hmt
	end

	self.interval = 1 / self.acceleration

	self.speed_counter = 0

	if self.target then
		self.target_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target, self:GetCaster():GetTeamNumber())
		self:AddParticle(self.target_particle, false, false, -1, false, false)
	end
	
	self.rocket_orders = {
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION]	= true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]	= true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]		= true,
		[DOTA_UNIT_ORDER_ATTACK_TARGET]		= true,
		[DOTA_UNIT_ORDER_STOP]				= true,
		[DOTA_UNIT_ORDER_HOLD_POSITION]		= true
	}
end

function modifier_gyrocopter_homing_missile_lua:OnIntervalThink()
	self.speed_counter	= self.speed_counter + 1
	self:SetStackCount(self.speed_counter)
	if self.target then
		if self.target:IsNull() or not self.target:IsAlive() then
			local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_particle)
			
			self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
			self:GetParent():ForceKill(false)
			self:GetParent():AddNoDraw()
			return
		end
		
		if (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 250 then
			self:GetParent():MoveToNPC(self.target)
		else
			self:GetParent():MoveToPosition(self.target:GetAbsOrigin())
		end
	else
		if not self.angle or self.angle == 0 then
			self.differential = 0
		elseif self.angle > 0 then
			self.differential = self.rc_turn_speed_degrees * self.interval
		elseif self.angle < 0 then
			self.differential = self.rc_turn_speed_degrees * self.interval * (-1)
		end
		
		self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, self.differential * (-1), 0), self:GetParent():GetForwardVector() * self:GetParent():GetIdealSpeed()))
		
		if self.turn_counter then
			self.turn_counter = self.turn_counter + math.min(math.abs(self.differential), math.abs(self.angle) - self.turn_counter)
			
			if self.turn_counter >= math.abs(self.angle) then
				self.turn_counter	= nil
				self.angle			= 0
				self.differential	= 0
			end
		end
	end
	
	if self.target and (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetParent():GetHullRadius() then
		self.target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
		self.target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
		
		if not self.target:IsMagicImmune() then
			self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * (1 - self.target:GetStatusResistance())})
			
			ApplyDamage({
				victim 			= self.target,
				damage 			= self.damage,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if not self.target:IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
				if not self.responses then
					self.responses = 
					{
						"gyrocopter_gyro_homing_missile_impact_01",
						"gyrocopter_gyro_homing_missile_impact_02",
						"gyrocopter_gyro_homing_missile_impact_05",
						"gyrocopter_gyro_homing_missile_impact_06",
						"gyrocopter_gyro_homing_missile_impact_07",
						"gyrocopter_gyro_homing_missile_impact_08"
					}
				end
				
				EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
			end
		end
		
		local blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN, self.target)
		ParticleManager:SetParticleControl(blast_particle, 1, Vector(self:GetParent():GetIdealSpeed() * 20 * 0.01, self:GetParent():GetIdealSpeed() * 20 * 0.01, self:GetParent():GetIdealSpeed() * 20 * 0.01))
		ParticleManager:ReleaseParticleIndex(blast_particle)

		if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str7") ~= nil then 
			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				if enemy ~= self.target then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					
					ApplyDamage({
						victim 			= enemy,
						damage 			= self.damage,
						damage_type		= self.damage_type,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self:GetAbility()
					})
				end
			end
		end
		
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), 400, self.enemy_vision_time, false)
		
		local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(explosion_particle)
		
		self:StartIntervalThink(-1)
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
	
	if self:GetParent():GetAbsOrigin().z < 0 then
		self:StartIntervalThink(-1)
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
end

function modifier_gyrocopter_homing_missile_lua:OnDestroy()
	if not IsServer() then return end
	self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile.Enemy")
end

function modifier_gyrocopter_homing_missile_lua:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]						= true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS]	= self:GetParent():HasModifier("modifier_gyrocopter_homing_missile_lua_pre_flight"),
		[MODIFIER_STATE_IGNORING_STOP_ORDERS]				= true
	}
end

function modifier_gyrocopter_homing_missile_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_gyrocopter_homing_missile_lua:GetModifierMoveSpeed_Absolute()
	if self:GetParent():HasModifier("modifier_gyrocopter_homing_missile_lua_pre_flight") then
		return 0
	else
		return self.speed + self:GetStackCount()
	end
end

function modifier_gyrocopter_homing_missile_lua:GetModifierMoveSpeed_Limit()
	if self:GetParent():HasModifier("modifier_gyrocopter_homing_missile_lua_pre_flight") then
		return -0.01
	else
		return self.speed + self:GetStackCount()
	end
end

function modifier_gyrocopter_homing_missile_lua:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_gyrocopter_homing_missile_lua:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_gyrocopter_homing_missile_lua:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_gyrocopter_homing_missile_lua:OnAttacked(keys)
	if keys.target == self:GetParent() then
		if keys.attacker:IsHero() or keys.attacker:IsIllusion() then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - self.hero_damage)
		elseif keys.attacker:IsBuilding() then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - (self.hero_damage / 2))
		end
		
		if self:GetParent():GetHealth() <= 0 then
			self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
			self:GetParent():Kill(nil, keys.attacker)
			self:GetParent():AddNoDraw()
		end
	end
end

function modifier_gyrocopter_homing_missile_lua:OnOrder(keys)
	if keys.unit == self:GetParent() and self.rocket_orders[keys.order_type] then
		if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self.angle = 0
		else
			self.selected_pos = keys.new_pos
			
			if keys.target then
				self.selected_pos = keys.target:GetAbsOrigin()
			end
			
			self.angle = AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(self.selected_pos - self:GetParent():GetAbsOrigin()).y)
			self.turn_counter	= 0
		end
	end
end