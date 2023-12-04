LinkLuaModifier("modifier_generic_stunned_lua",  "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_lua_true_sight",  "heroes/hero_zuus/zuus_lighting_bolt/zuus_lighting_bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_lua_dummy",  "heroes/hero_zuus/zuus_lighting_bolt/zuus_lighting_bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_zuus_lighting_bolt_intrinsic", "heroes/hero_zuus/zuus_lighting_bolt/modifier_zuus_lighting_bolt_intrinsic.lua", LUA_MODIFIER_MOTION_NONE )
zuus_lightning_bolt_lua = class({})


function zuus_lightning_bolt_lua:GetIntrinsicModifierName()
	return "modifier_zuus_lighting_bolt_intrinsic"
end

function zuus_lightning_bolt_lua:GetCooldown(level)
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi8") then
	-- 	return self.BaseClass.GetCooldown( self, level ) - 2
	-- end
	return self.BaseClass.GetCooldown( self, level )
end
function zuus_lightning_bolt_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function zuus_lightning_bolt_lua:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")
	return true
end

function zuus_lightning_bolt_lua:CastFilterResultTarget( target )
	if IsServer() then	
		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function zuus_lightning_bolt_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int10") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end
end

function zuus_lightning_bolt_lua:GetAOERadius()
	return 350
end

function zuus_lightning_bolt_lua:OnSpellStart()
	if IsServer() then
		local caster 		= self:GetCaster()
		local target 		= self:GetCursorTarget()
		local target_point 	= self:GetCursorPosition()

		local movement_speed 	= 10
		local turn_rate 	 	= 1

		CustomNetTables:SetTableValue(
		"player_table", 
		tostring(self:GetCaster():GetPlayerOwnerID()), 
		{ 	
			reduced_magic_resistance 	= reduced_magic_resistance,
			movement_speed 				= movement_speed,
			turn_rate 					= turn_rate
		})

		if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int10") then
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(),  target_point,  nil,  350,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  FIND_CLOSEST,  false )
			for _, enemy in pairs(enemies) do
				zuus_lightning_bolt_lua:CastLightningBolt(caster, self, enemy, enemy:GetAbsOrigin())
			end
		else
			zuus_lightning_bolt_lua:CastLightningBolt(caster, self, target, target_point)
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str8") and RandomInt(1, 100) <= 10 then
			local zuus_thundergods_wrath_lua = self:GetCaster():FindAbilityByName("zuus_thundergods_wrath_lua")
			if zuus_thundergods_wrath_lua and zuus_thundergods_wrath_lua:GetLevel() > 0 then
				zuus_thundergods_wrath_lua:LocalCast(1.0)
			end
		end
	end
end

function zuus_lightning_bolt_lua:CastLightningBolt(caster, ability, target, target_point, nimbus, rewritten_damage)
	if IsServer() then
		local spread_aoe 			= ability:GetSpecialValueFor("spread_aoe")
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day  	= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night  	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local stun_duration 		= ability:GetSpecialValueFor("stun_duration")
		local pierce_spellimmunity 	= false
		local z_pos 				= 2000

		if nimbus then
			nimbus:EmitSound("Hero_Zuus.LightningBolt")
		else
			caster:EmitSound("Hero_Zuus.LightningBolt")
		end

		AddFOWViewer(caster:GetTeam(), target_point, true_sight_radius, sight_duration, false)
		
		if target ~= nil then
			-- target = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, target_point.z), false, nil, nil, DOTA_TEAM_NEUTRALS)
			target_point = target:GetAbsOrigin()

			-- If cast on self. no lightning will be cast but the cloud will spawn at this coordinate.
			if target == caster then
				z_pos = 950
			end
		end

		-- Spell was used on the ground search for invisible hero to target
		if target == nil then
			local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
			if pierce_spellimmunity == true then 
				target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			end

			-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				target_flags, 
				FIND_CLOSEST, 
				false
			)
			
			local closest = radius
			for i,unit in ipairs(nearby_enemy_units) do
				if not unit:IsMagicImmune() or pierce_spellimmunity then 
					-- First unit is the closest
					target = unit
					break
				end
			end
		end

		if not nimbus and target then
			-- If the target possesses a ready Linken's Sphere, do nothing
			if target:GetTeam() ~= caster:GetTeam() then
				if target:TriggerSpellAbsorb(ability) then
					return nil
				end
			end
		end

		-- If we still dont have a target we search for nearby creeps
		if target == nil then
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				ability:GetAbilityTargetType(),
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)

			for i,unit in ipairs(nearby_enemy_units) do
				-- First unit is the closest
				target = unit
				break
			end
		end

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
		if target == nil then 
			-- Renders the particle on the ground target
			ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
			ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
			ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
		elseif target:IsMagicImmune() == false or pierce_spellimmunity then  
			target_point = target:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
			ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
			ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
		end

		-- Add dummy to provide us with truesight aura
		local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
		local true_sight = dummy_unit:AddNewModifier(caster, ability, "modifier_zuus_lightning_bolt_lua_true_sight", {duration = sight_duration})
		true_sight:SetStackCount(true_sight_radius)
		dummy_unit:SetDayTimeVisionRange(sight_radius_day)
		dummy_unit:SetNightTimeVisionRange(sight_radius_night)

		dummy_unit:AddNewModifier(caster, ability, "modifier_zuus_lightning_bolt_lua_dummy", {})
		dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = sight_duration + 1})

		if target ~= nil and target:GetTeam() ~= caster:GetTeam() then
			
				
			target:AddNewModifier(caster, ability, "modifier_generic_stunned_lua", {duration = stun_duration * (1 - target:GetStatusResistance())})
			
			bolt_damage = rewritten_damage
			if not bolt_damage then
				bolt_damage = ability:GetSpecialValueFor("damage")
			end
			
			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 
			damage_table.damage			= bolt_damage
			damage_table.victim 		= target

			-- Cannot deal magic dmg to immune... change to pure
			if pierce_spellimmunity then
				damage_table.damage_type = DAMAGE_TYPE_PURE
			end

			ApplyDamage(damage_table)
		end
	end
end


modifier_zuus_lightning_bolt_lua_dummy = class({})
function modifier_zuus_lightning_bolt_lua_dummy:IsHidden() return true end
function modifier_zuus_lightning_bolt_lua_dummy:IsPurgable() return false end
function modifier_zuus_lightning_bolt_lua_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end



------------------------------------------------------------------
--  			Lightning bolt true_sight modifier 				--
------------------------------------------------------------------
modifier_zuus_lightning_bolt_lua_true_sight = class({})
function modifier_zuus_lightning_bolt_lua_true_sight:IsAura()
    return true
end

function modifier_zuus_lightning_bolt_lua_true_sight:IsHidden()
    return true
end

function modifier_zuus_lightning_bolt_lua_true_sight:IsPurgable()
    return false
end

function modifier_zuus_lightning_bolt_lua_true_sight:GetAuraRadius()
	if self:GetParent():GetName() == "npc_dota_creep_neutral" then
		return self:GetStackCount()
	else
		return 1
	end
end

function modifier_zuus_lightning_bolt_lua_true_sight:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_zuus_lightning_bolt_lua_true_sight:GetAuraSearchTeam()
	if self:GetParent():GetName() == "npc_dota_creep_neutral" then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_zuus_lightning_bolt_lua_true_sight:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_zuus_lightning_bolt_lua_true_sight:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_zuus_lightning_bolt_lua_true_sight:GetAuraDuration()
    return 0.5
end




----------------------------------------------
--  			FOW modifier  				--
----------------------------------------------
LinkLuaModifier("modifier_zuus_lightning_bolt_lua_fow", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_zuus_lightning_bolt_lua_fow = class({})
function modifier_zuus_lightning_bolt_lua_fow:IsHidden() return true end
function modifier_zuus_lightning_bolt_lua_fow:OnCreated(keys) 
	if IsServer() then 
		self.parent = self:GetParent()
		self.radius = keys.radius
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_zuus_lightning_bolt_lua_fow:OnIntervalThink()
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.parent:GetAbsOrigin(), self.radius, FrameTime(), false)
end