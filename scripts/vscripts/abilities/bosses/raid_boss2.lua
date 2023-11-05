boss_split = class({})
modifier_boss_split_split_delay = class({})
modifier_boss_split_duration = class({})

LinkLuaModifier("modifier_boss_split_split_delay", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_split_duration", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invu", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)

function boss_split:GetIntrinsicModifierName()
	return "modifier_boss_split"
end

function boss_split:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Brewmaster.PrimalSplit.Cast")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_split_split_delay", {duration = self:GetSpecialValueFor("split_duration")})
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.25)
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function modifier_boss_split_split_delay:IsHidden()	return true end
function modifier_boss_split_split_delay:IsPurgable()	return false end

function modifier_boss_split_split_delay:OnCreated()
	if not IsServer() then return end
	
	local split_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(split_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlForward(split_particle, 0, self:GetParent():GetForwardVector())
	self:AddParticle(split_particle, false, false, -1, false, false)
end

function modifier_boss_split_split_delay:OnDestroy()
	if not IsServer() then return end
	
	if self:GetParent():IsAlive() and self:GetAbility() then
		self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Spawn")
		
		self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_invu", {})
		
		local earth_panda = CreateUnitByName("npc_raid_earth", self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100, true, self:GetParent(), self:GetParent(), self:GetCaster():GetTeamNumber())		
		local storm_panda = CreateUnitByName("npc_raid_storm", RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, 120, 0), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())		
		local fire_panda = CreateUnitByName("npc_raid_fire", RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, -120, 0), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		
		earth_panda:add_items(5)
		fire_panda:add_items(5)
		storm_panda:add_items(5)

		if diff_wave.wavedef == "Easy" then
			earth_panda:AddNewModifier(unit, nil, "modifier_easy", {})
			storm_panda:AddNewModifier(unit, nil, "modifier_easy", {})
			fire_panda:AddNewModifier(unit, nil, "modifier_easy", {})
		end
		if diff_wave.wavedef == "Normal" then
			earth_panda:AddNewModifier(unit, nil, "modifier_normal", {})
			storm_panda:AddNewModifier(unit, nil, "modifier_normal", {})
			fire_panda:AddNewModifier(unit, nil, "modifier_normal", {})
		end
		if diff_wave.wavedef == "Hard" then
			earth_panda:AddNewModifier(unit, nil, "modifier_hard", {})
			storm_panda:AddNewModifier(unit, nil, "modifier_hard", {})
			fire_panda:AddNewModifier(unit, nil, "modifier_hard", {})
		end	
		if diff_wave.wavedef == "Ultra" then
			earth_panda:AddNewModifier(unit, nil, "modifier_ultra", {})
			storm_panda:AddNewModifier(unit, nil, "modifier_ultra", {})
			fire_panda:AddNewModifier(unit, nil, "modifier_ultra", {})
		end	
		if diff_wave.wavedef == "Insane" then
			earth_panda:AddNewModifier(unit, nil, "modifier_insane", {})
			storm_panda:AddNewModifier(unit, nil, "modifier_insane", {})
			fire_panda:AddNewModifier(unit, nil, "modifier_insane", {})
			new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
			earth_panda:AddAbility(new_abil_passive):SetLevel(4)
			storm_panda:AddAbility(new_abil_passive):SetLevel(4)
			fire_panda:AddAbility(new_abil_passive):SetLevel(4)
		end	
		if diff_wave.wavedef == "Impossible" then
			earth_panda:AddNewModifier(unit, nil, "modifier_impossible", {})
			storm_panda:AddNewModifier(unit, nil, "modifier_impossible", {})
			fire_panda:AddNewModifier(unit, nil, "modifier_impossible", {})
			new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
			earth_panda:AddAbility(new_abil_passive):SetLevel(4)
			storm_panda:AddAbility(new_abil_passive):SetLevel(4)
			fire_panda:AddAbility(new_abil_passive):SetLevel(4)
		end		
		
		self:GetParent():AddNoDraw()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_invu = class({})

function modifier_invu:IsPurgable()
	return false
end

function modifier_invu:OnCreated()
	self.count = 3
end

function modifier_invu:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_invu:OnDeath(keys)
	if not IsServer() then return end
	if keys.unit:GetUnitName() == "npc_raid_earth" or
		keys.unit:GetUnitName() == "npc_raid_storm" or
		keys.unit:GetUnitName() == "npc_raid_fire" then
		self.count = self.count - 1
		if self.count == 0 then
			self:GetParent():RemoveNoDraw()
			self:GetParent():SetHealth(self:GetParent():GetMaxHealth()/2)	
			self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Spawn")
			self:Destroy()
		end
	end
end

function modifier_invu:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_OUT_OF_GAME]	= true,	
		[MODIFIER_STATE_STUNNED]			= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]		= true,
		[MODIFIER_STATE_DISARMED]	= true,
		[MODIFIER_STATE_SILENCED]	= true,
		[MODIFIER_STATE_MAGIC_IMMUNE]	= true,
		}
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_raid_boss_tornado", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_boss_tornado_cyclone", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_boss_tornado_empower_debuff", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)
		
raid_boss_tornado = class({})

raid_boss_tornado.loop_interval = 0.03
raid_boss_tornado.ability_effect_path 			= "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
raid_boss_tornado.ability_effect_cyclone_path 	= "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf"


function raid_boss_tornado:GetCastAnimation()
	return ACT_DOTA_CAST_TORNADO
end

function raid_boss_tornado:OnSpellStart()
	if IsServer() then 
	local caster 	= self:GetCaster()
	local ability 	= caster:FindAbilityByName("raid_boss_tornado")
	local caster_location 			= caster:GetAbsOrigin() 
	
	local tornado_travel_distance 	= ability:GetSpecialValueFor("travel_distance")
	local tornado_lift_duration  	= ability:GetSpecialValueFor("lift_duration")
	local area_of_effect 			= ability:GetSpecialValueFor("area_of_effect")
	local travel_speed = ability:GetSpecialValueFor("travel_speed")
	local end_vision_duration 		= ability:GetSpecialValueFor("end_vision_duration")
	local vision_distance 			= ability:GetSpecialValueFor("vision_distance")
	local cyclone_initial_height 	= ability:GetSpecialValueFor("cyclone_initial_height")
	local cyclone_min_height 		= ability:GetSpecialValueFor("cyclone_min_height")
	local cyclone_max_height 		= ability:GetSpecialValueFor("cyclone_max_height")
	local tornado_duration 			= tornado_travel_distance / travel_speed
	local daze_duration 			= 0

local tornado_dummy_unit =  CreateModifierThinker(caster, self, nil, {},caster_location, caster:GetTeamNumber(), false)
tornado_dummy_unit:EmitSound("Hero_Invoker.Tornado")

local tornado_projectile_table =  
{
	EffectName 			= raid_boss_tornado.ability_effect_path,
	Ability 			= ability,
	vSpawnOrigin 		= caster_location,
	fDistance 			= tornado_travel_distance,
	fStartRadius 		= area_of_effect,
	fEndRadius 			= area_of_effect,
	Source = tornado_dummy_unit,
	bHasFrontalCone 	= false,
	iMoveSpeed 			= travel_speed,
	bReplaceExisting 	= false,
	bProvidesVision 	= true,
	iVisionTeamNumber 	= caster:GetTeam(),
	iVisionRadius 		= vision_distance,
	bDrawsOnMinimap 	= false,
	bVisibleToEnemies 	= true, 
	iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
	iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	fExpireTime 		= GameRules:GetGameTime() + tornado_duration + 20,
	ExtraData 			= 	{	tornado_lift_duration 	= tornado_lift_duration, 
	end_vision_duration 	= end_vision_duration,
	cyclone_initial_height 	= cyclone_initial_height,
	cyclone_min_height		= cyclone_min_height,
	cyclone_max_height 		= cyclone_max_height,
	daze_duration 			= daze_duration,
	cyclone_effect_path 	= raid_boss_tornado.ability_effect_cyclone_path,
	vision_distance 		= vision_distance,
	tornado_dummy_unit 		= tornado_dummy_unit:entindex()
				}
	}

local target_point 	= self:GetCursorPosition()
local caster_point 	= caster_location 

local point_difference_normalized 	= (target_point - caster_point):Normalized()

local projectile_vvelocity 			= point_difference_normalized * travel_speed
projectile_vvelocity.z = 0
tornado_projectile_table.vVelocity 	= projectile_vvelocity

local tornado_projectile = ProjectileManager:CreateLinearProjectile(tornado_projectile_table)

	end
end

function raid_boss_tornado:OnProjectileThink_ExtraData(vLocation, ExtraData)
	if IsServer() then 
	EntIndexToHScript(ExtraData.tornado_dummy_unit):SetAbsOrigin(vLocation)
	end
end


function raid_boss_tornado:OnProjectileHit_ExtraData(target, location, ExtraData)
if IsServer() then
if target ~= nil then 
	local caster 	= self:GetCaster()
	local tornado_lift_duration 	= ExtraData.tornado_lift_duration
	local cyclone_initial_height 	= ExtraData.cyclone_initial_height
	local cyclone_min_height 		= ExtraData.cyclone_min_height
	local cyclone_max_height 		= ExtraData.cyclone_max_height
	local tornado_start 			= GameRules:GetGameTime()
	local vision_distance 			= ExtraData.vision_distance
	local end_vision_duration 		= ExtraData.end_vision_duration
	
	if tornado_lift_duration ~= nil then
		target.invoker_tornado_forward_vector = target:GetForwardVector()
		
		target:AddNewModifier(caster, target, "modifier_raid_boss_tornado_cyclone", {duration = tornado_lift_duration * (1 - target:GetStatusResistance())})
		local cyclone_effect = ParticleManager:CreateParticle(ExtraData.cyclone_effect_path, PATTACH_ABSORIGIN, target)

		target:EmitSound("Hero_Invoker.Tornado.Target")
		
		local flying_z_modifier = target:FindModifierByName("modifier_raid_boss_tornado_cyclone")
		local z_position = 0
		tornado_lift_duration = flying_z_modifier:GetDuration()

		local time_to_reach_initial_height 		= 2/10
		local initial_ascent_height_per_frame 	= ((cyclone_initial_height) / time_to_reach_initial_height) * raid_boss_tornado.loop_interval 
		local up_down_cycle_height_per_frame 	= initial_ascent_height_per_frame / 3  
		if up_down_cycle_height_per_frame > 7.5 then  
			up_down_cycle_height_per_frame = 7.5
		end
		
		local final_descent_height_per_frame = nil  

		local time_to_stop_fly = tornado_lift_duration - time_to_reach_initial_height -- raid_boss_tornado.loop_interval
		local going_up = true
		
		Timers:CreateTimer(function()
			local time_in_air = GameRules:GetGameTime() - tornado_start
			
			self:spinn({target = target, tornado_lift_duration = tornado_lift_duration})
			-- Throw target unit up in the air towards cyclone's initial height.
			if z_position < cyclone_initial_height and time_in_air <= time_to_reach_initial_height then

z_position = z_position + initial_ascent_height_per_frame
flying_z_modifier:SetStackCount(z_position)
return raid_boss_tornado.loop_interval
			-- Go down until the target reaches the ground.
			elseif time_in_air > time_to_stop_fly and time_in_air <= tornado_lift_duration then
--Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
--the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration ends.
if final_descent_height_per_frame == nil then
	-- distance to ground
	local descent_initial_height_above_ground = cyclone_initial_height
	-- Since (time_to_reach_initial_height / raid_boss_tornado.loop_interval) will end up in a decimal we will get rounding issues in the loop. 
	-- By using math.floor we discards decimals and gives us the correct value which to divide reamining distance to ground
	local rounding_coeff = math.floor(time_to_reach_initial_height / raid_boss_tornado.loop_interval)
	-- Final value which we subtracts from unit z-position untill it reaches ground.
	final_descent_height_per_frame = descent_initial_height_above_ground / rounding_coeff
end

z_position = z_position - final_descent_height_per_frame
flying_z_modifier:SetStackCount(z_position)
return raid_boss_tornado.loop_interval
			-- Before its time to decend we make Up and down cycles
			elseif time_in_air <= tornado_lift_duration then
-- Up
if z_position < cyclone_max_height and going_up then 
	z_position = z_position + up_down_cycle_height_per_frame
	flying_z_modifier:SetStackCount(z_position)
	return raid_boss_tornado.loop_interval
-- Down
elseif z_position >= cyclone_min_height then
	going_up = false
	z_position = z_position - up_down_cycle_height_per_frame
	flying_z_modifier:SetStackCount(z_position)
	return raid_boss_tornado.loop_interval
-- Go up
else
	going_up = true
	return raid_boss_tornado.loop_interval
end
return raid_boss_tornado.loop_interval
			end
-- Stop sound
target:StopSound("Hero_Invoker.Tornado.Target")
-- Cleanup
ParticleManager:DestroyParticle(cyclone_effect, false)
-- Cant deal damage if modifiers are on
if target:HasModifier("modifier_raid_boss_tornado") then
	target:RemoveModifierByName("modifier_raid_boss_tornado") 
end

if target:HasModifier("modifier_raid_boss_tornado_cyclone") then
	target:RemoveModifierByName("modifier_raid_boss_tornado_cyclone")
	target:SetAbsOrigin(GetGroundPosition(target:GetAbsOrigin(), caster))
end

-- Apply damage
self:LandDamage(target, caster, self, {base_damage = target:GetMaxHealth()*0.2, wex_land_damage = target:GetMaxHealth()*0.2})

-- If we have empower tornado talent... apply disarm
if ExtraData.daze_duration > 0 then
	target:AddNewModifier(caster, self, "modifier_raid_boss_tornado_empower_debuff", {duration = ExtraData.daze_duration * (1 - target:GetStatusResistance())})
end
		end)		
	end
else 
	EntIndexToHScript(ExtraData.tornado_dummy_unit):StopSound("Hero_Invoker.Tornado")
	EntIndexToHScript(ExtraData.tornado_dummy_unit):RemoveSelf()
	self:CreateVisibilityNode(location, ExtraData.vision_distance, ExtraData.end_vision_duration)
end
			end
		end

		function raid_boss_tornado:spinn(kv)
			local target = kv.target
			local total_degrees = 20

			--Rotate as close to 20 degrees per x.x seconds (666.666 degrees per second) as possible, so that the target lands facing their initial direction.
			if kv.target.invoker_tornado_degrees_to_spin == nil and kv.tornado_lift_duration ~= nil then
local ideal_degrees_per_second = 666.666
local ideal_full_spins = (ideal_degrees_per_second / 360) * kv.tornado_lift_duration
--Round the number of spins to aim for to the closest integer.
ideal_full_spins = math.floor(ideal_full_spins + .5) 
local degrees_per_second_ending_in_same_forward_vector = (360 * ideal_full_spins) / kv.tornado_lift_duration
kv.target.invoker_tornado_degrees_to_spin = degrees_per_second_ending_in_same_forward_vector * raid_boss_tornado.loop_interval
			end
			
			target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0, kv.target.invoker_tornado_degrees_to_spin, 0), target:GetForwardVector()))
		end

		function raid_boss_tornado:LandDamage(target, attacker, ability, kv)
			local damage_type = self:GetAbilityDamageType() 
			target:EmitSound("Hero_Invoker.Tornado.LandDamage")
			
			--Set so the target is facing the original direction as they were when they were hit by the tornado.
			if target.invoker_tornado_forward_vector ~= nil then
target:SetForwardVector(target.invoker_tornado_forward_vector)
			end

			-- Apply damage
			local damage_table = {}
			damage_table.attacker = attacker
			damage_table.victim = target
			damage_table.ability = ability
			damage_table.damage_type = ability:GetAbilityDamageType() 
			damage_table.damage = target:GetMaxHealth()*0.4
			ApplyDamage(damage_table)
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Tornado help modifier - hide dummy unit from game
		--------------------------------------------------------------------------------------------------------------------
		modifier_raid_boss_tornado = class({})
		function modifier_raid_boss_tornado:IsHidden() 	return false end
		function modifier_raid_boss_tornado:IsBuff() 	return false end
		function modifier_raid_boss_tornado:IsDebuff() 	return false end
		function modifier_raid_boss_tornado:IsPassive() 	return false end
		function modifier_raid_boss_tornado:IsPurgable() return false end
		function modifier_raid_boss_tornado:CheckState()
			local state = {
[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
[MODIFIER_STATE_INVULNERABLE] 		= true,
[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
[MODIFIER_STATE_UNSELECTABLE] 		= true,
[MODIFIER_STATE_OUT_OF_GAME] 		= true,
[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
[MODIFIER_STATE_ROOTED] 			= true,
			}
			return state
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Tornado modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_raid_boss_tornado_cyclone = class({})
		function modifier_raid_boss_tornado_cyclone:IsHidden() 	return true  end
		function modifier_raid_boss_tornado_cyclone:IsBuff() 	return false end
		function modifier_raid_boss_tornado_cyclone:IsDebuff() 	return false end
		function modifier_raid_boss_tornado_cyclone:IsPassive() 	return false end
		function modifier_raid_boss_tornado_cyclone:IsPurgable() return false end
		function modifier_raid_boss_tornado_cyclone:CheckState()
			local state = {
[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
[MODIFIER_STATE_STUNNED] 			= true,
[MODIFIER_STATE_ROOTED] 			= true,
[MODIFIER_STATE_DISARMED] 			= true,
[MODIFIER_STATE_INVULNERABLE] 		= true,
[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
[MODIFIER_STATE_FLYING] 			= true,
			}
			return state
		end

		function modifier_raid_boss_tornado_cyclone:DeclareFunctions()
			local funcs = {
MODIFIER_PROPERTY_VISUAL_Z_DELTA
			}
			
			return funcs
		end

		function modifier_raid_boss_tornado_cyclone:GetVisualZDelta()
			return self:GetStackCount()
		end

		function modifier_raid_boss_tornado_cyclone:OnCreated(kv)
		end


		function modifier_raid_boss_tornado_cyclone:OnRemoved(kv)
			self:SetStackCount(0)
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Tornado talent modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_raid_boss_tornado_empower_debuff = class({})
		function modifier_raid_boss_tornado_empower_debuff:IsHidden() 	return false end
		function modifier_raid_boss_tornado_empower_debuff:IsBuff() 		return false end
		function modifier_raid_boss_tornado_empower_debuff:IsDebuff() 	return true end
		function modifier_raid_boss_tornado_empower_debuff:IsPassive() 	return false end
		function modifier_raid_boss_tornado_empower_debuff:IsPurgable() 	return false end
		function modifier_raid_boss_tornado_empower_debuff:CheckState()
			local state = {
[MODIFIER_STATE_PASSIVES_DISABLED] 	= true,
			}
			return state
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------		
--------------------------------------------------------------------------------------------------------------------------------------------------------------		
--------------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_raid_thunder_clap", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_raid_thunder_clap_conductive_thinker", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE)

raid_thunder_clap = raid_thunder_clap or class({})
modifier_raid_thunder_clap = modifier_raid_thunder_clap or class({})

function raid_thunder_clap:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Brewmaster.ThunderClap")
	slow_duration = self:GetSpecialValueFor("duration")

	
	local clap_particle = ParticleManager:CreateParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(clap_particle, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(clap_particle)
	
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if ((enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()) * Vector(1, 1, 0)):Length2D() <= self:GetSpecialValueFor("radius") then
			enemy:EmitSound("Hero_Brewmaster.ThunderClap.Target")
			
			self.responses = {"brewmaster_brew_ability_thunderclap_01","brewmaster_brew_ability_thunderclap_02","brewmaster_brew_ability_thunderclap_03","brewmaster_brew_ability_primalsplit_02","brewmaster_brew_ability_primalsplit_03",}
				self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
			end
		
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_raid_thunder_clap", {duration = slow_duration * (1 - enemy:GetStatusResistance())})
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= enemy:GetMaxHealth()*0.25,
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			})
	end
end

-------------------------------------------

function modifier_raid_thunder_clap:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end

function modifier_raid_thunder_clap:OnCreated()
	self.movement_slow		= self:GetAbility():GetSpecialValueFor("movement_slow") * (-1)
	self.attack_speed_slow	= self:GetAbility():GetSpecialValueFor("attack_speed_slow") * (-1)
end

function modifier_raid_thunder_clap:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_raid_thunder_clap:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_raid_thunder_clap:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
fallen_meteor = class({})

function fallen_meteor:OnSpellStart()
	self.caster		= self:GetCaster()
	caster		= self:GetCaster()
	self.damage				=	self:GetSpecialValueFor("damage")
	self.duration					=	self:GetSpecialValueFor("duration")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	if not IsServer() then return end
	self.position = self.caster:GetAbsOrigin()
	local range = 800
	
	local particle_pre = "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf"

	for i = 1, 6 do
	
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-range, range)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_pos = Vector(self.position.x + dx, self.position.y + dy, self.position.z)
	local dummy = CreateUnitByName("npc_dummy_unit", target_pos, false, caster, caster, caster:GetTeamNumber())
	dummy:AddNewModifier(caster, nil, "modifier_dummy", {})
	local particleIndexPre = ParticleManager:CreateParticle(particle_pre, PATTACH_ABSORIGIN, dummy)
	Timers:CreateTimer(2,function()
	pos = dummy:GetAbsOrigin()
	ParticleManager:DestroyParticle( particleIndexPre, false )
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, dummy)
		ParticleManager:SetParticleControl(self.particle3, 0,	pos + Vector(0, 0, 1000)) -- 1000 feels kinda arbitrary but it also feels correct
		ParticleManager:SetParticleControl(self.particle3, 1, pos)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_fallen_meteor_burn", {duration = self.duration})
					
					local damageTable = {
						victim 			= enemy,
						damage 			= self.damage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}					
					ApplyDamage(damageTable)
			end
		end
	end)
	end)
	end
end

-----------------------------------------------------------------------
LinkLuaModifier( "modifier_dummy", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE )

modifier_dummy = class({})

function modifier_dummy:IsHidden()
    return true
end


function modifier_dummy:IsPurgable()
    return false
end
function modifier_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	--	[MODIFIER_STATE_INVISIBLE] = true,		
	}
	return state
end

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

raid_crit = class({})
LinkLuaModifier( "modifier_raid_crit", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_raid_crit_impact", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function raid_crit:GetIntrinsicModifierName()
	return "modifier_raid_crit"
end

modifier_raid_crit = class({})

function modifier_raid_crit:IsHidden()
	return false
end

function modifier_raid_crit:IsPurgable()
	return false
end

function modifier_raid_crit:OnCreated( kv )
	self.chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self:StartIntervalThink(1)
end

function modifier_raid_crit:OnIntervalThink()
if IsServer() then 
	if self.chance >= RandomInt(1,100) then
		if not self:GetCaster():HasModifier("modifier_raid_crit_impact") then 
			local sound_cast = "Hero_Bloodseeker.BloodRite.Cast"
			EmitSoundOn( sound_cast, self:GetCaster() )
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_raid_crit_impact", {})
			end
		end
	end
end


--------------------------------------------------------------------------------

modifier_raid_crit_impact = class({})

function modifier_raid_crit_impact:IsHidden()
	return false
end

function modifier_raid_crit_impact:OnCreated( kv )
	self.caster = self:GetCaster()
end

function modifier_raid_crit_impact:OnDestroy(kv)
end

function modifier_raid_crit_impact:IsPurgable()
	return false
end

function modifier_raid_crit_impact:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_raid_crit_impact:GetStatusEffectName()
	return "particles/centaur/status_effect.vpcf"
end

function modifier_raid_crit_impact:StatusEffectPriority()
	return 15 
end

function modifier_raid_crit_impact:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_raid_crit_impact:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_raid_crit_impact:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		self.record = params.record
		return self:GetAbility():GetSpecialValueFor( "crit_bonus" )
	end
end

function modifier_raid_crit_impact:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
			self:GetParent():RemoveModifierByName("modifier_raid_crit_impact")
		end
	end
end

function modifier_raid_crit_impact:PlayEffects( target )
	local particle_cast =  "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "Hero_Brewmaster.Brawler.Crit"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end


-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

raid_bkb = class({})
LinkLuaModifier( "modifier_raid_bkb", "abilities/bosses/raid_boss2.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function raid_bkb:GetIntrinsicModifierName()
	return "modifier_raid_bkb"
end

modifier_raid_bkb = class({})

function modifier_raid_bkb:IsHidden() return false end
function modifier_raid_bkb:IsPurgable() return false end
function modifier_raid_bkb:IsDebuff() return false end

function modifier_raid_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_raid_bkb:OnCreated()
end

function modifier_raid_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_raid_bkb:CheckState()
    local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return state
end