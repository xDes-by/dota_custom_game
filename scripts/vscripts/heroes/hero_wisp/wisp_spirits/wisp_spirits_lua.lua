wisp_spirits_lua = class({})
LinkLuaModifier("modifier_wisp_spirits_lua", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_handler", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_spirits_lua_creep_hit", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_damage_handler", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_spirits_lua_true_sight", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spell_ampl_spirit", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE )

function wisp_spirits_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return caster:GetIntellect()
    end
end

function wisp_spirits_lua:OnSpellStart()
	if IsServer() then

		self.caster 					= self:GetCaster()
		self.ability 					= self.caster:FindAbilityByName("wisp_spirits_lua")
		self.start_time 				= GameRules:GetGameTime()
		self.spirits_num_spirits		= 0
		spirit_min_radius 		= self.ability:GetSpecialValueFor("min_range")
		spirit_max_radius 		= self.ability:GetSpecialValueFor("max_range")
		spirit_movement_rate		= self.ability:GetSpecialValueFor("spirit_movement_rate")
		creep_damage				= self.ability:GetSpecialValueFor("creep_damage")
		explosion_damage			= self.ability:GetSpecialValueFor("explosion_damage")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str_last") ~= nil then
			spirit_duration = 3600
		else
			spirit_duration = self.ability:GetSpecialValueFor("spirit_duration")
		end
		spirit_summon_interval	= self.ability:GetSpecialValueFor("spirit_summon_interval")
		max_spirits 				= self.ability:GetSpecialValueFor("num_spirits")
		collision_radius			= self.ability:GetSpecialValueFor("collision_radius")
		explosion_radius			= self.ability:GetSpecialValueFor("explode_radius")
		spirit_turn_rate 			= self.ability:GetSpecialValueFor("spirit_turn_rate")
		vision_radius				= self.ability:GetSpecialValueFor("explode_radius")
		vision_duration 			= self.ability:GetSpecialValueFor("vision_duration")
		damage_interval			= self.ability:GetSpecialValueFor("damage_interval")
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi6")	
		if abil ~= nil then 
		creep_damage = self:GetCaster():GetAttackDamage()/2
		end
			
		if self.ability.spirits_spiritsSpawned ~= nil then	
			ability 	= self.ability
			caster 	= self:GetCaster()
			for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
				if not spirit:IsNull() then
					spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
				end
			end
		end
		
		self.spirits_movementFactor				= 1	
		self.ability.spirits_spiritsSpawned		= {}

		EmitSoundOn("Hero_Wisp.Spirits.Cast", self.caster)	

		if self.caster:HasModifier("modifier_wisp_spirits_lua") then
			self.caster:RemoveModifierByName("modifier_wisp_spirits_lua")
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str_last") ~= nil then
			creep_damage = creep_damage + self:GetCaster():GetStrength() / 2
		end
		self.caster:AddNewModifier(
			self.caster, 
			self.ability, 
			"modifier_wisp_spirits_lua", 
			{
				duration = spirit_duration,
				spirits_starttime 		= GameRules:GetGameTime(),
				spirit_summon_interval	= spirit_summon_interval,
				max_spirits 			= max_spirits,
				collision_radius 		= collision_radius,
				explosion_radius 		= explosion_radius,
				spirit_min_radius		= spirit_min_radius,
				spirit_max_radius		= spirit_max_radius,
				spirit_movement_rate	= spirit_movement_rate,
				spirit_turn_rate 		= spirit_turn_rate,
				vision_radius			= vision_radius,
				vision_duration			= vision_duration,
				creep_damage 			= creep_damage,
				explosion_damage 		= explosion_damage,
			}) 

		self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_wisp_spirit_damage_handler", {duration = -1, damage_interval = damage_interval})
	end
end


modifier_imba_wisp_spirit_damage_handler = class({})
function modifier_imba_wisp_spirit_damage_handler:IsHidden() return true end
function modifier_imba_wisp_spirit_damage_handler:IsPurgable() return false end
function modifier_imba_wisp_spirit_damage_handler:OnCreated(params)
	if IsServer() then 
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		self:StartIntervalThink(params.damage_interval)
	end
end

function modifier_imba_wisp_spirit_damage_handler:OnIntervalThink()
	if IsServer() then 
		self.ability.hit_table = {}
	end
end

------------------------------
--		SPIRITS	modifier	--
------------------------------
modifier_wisp_spirits_lua = class({})
function modifier_wisp_spirits_lua:OnCreated(params)

	if IsServer() then
		self.start_time 				= params.spirits_starttime
		self.spirit_summon_interval 	= params.spirit_summon_interval
		self.max_spirits				= params.max_spirits
		self.collision_radius			= params.collision_radius
		self.explosion_radius			= params.explosion_radius
		self.spirit_radius 				= params.collision_radius
		self.spirit_min_radius			= params.spirit_min_radius
		self.spirit_max_radius			= params.spirit_max_radius
		self.spirit_movement_rate 		= params.spirit_movement_rate
		self.spirit_turn_rate			= params.spirit_turn_rate
		self.vision_radius				= params.vision_radius
		self.vision_duration			= params.vision_duration
		self.creep_damage 				= params.creep_damage
		self.explosion_damage			= params.explosion_damage

		-- timers for tracking update of FX
		self:GetAbility().update_timer 	= 0
		self.time_to_update  			= 0.5

		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	

		self:StartIntervalThink(0.03)
	end
end

function modifier_wisp_spirits_lua:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
		local caster_position 			= caster:GetAbsOrigin()
		local ability 					= self:GetAbility()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval
		local level						= ability:GetLevel()

		-- add time to update timer
		ability.update_timer = ability.update_timer + FrameTime()


		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)

		if ability.spirits_num_spirits < idealNumSpiritsSpawned then

			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_spitit_wisp", caster_position, false, caster, caster, caster:GetTeam())
					newSpirit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int9")	
				if abil ~= nil then 
					local spr = newSpirit:FindAbilityByName("spirit_arc_lightning")
					spr:SetLevel(level)
					newSpirit:AddNewModifier(newSpirit, nil, "modifier_spell_ampl_spirit",  { }) 
				end


			local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, newSpirit)

			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			newSpirit.spirit_pfx_silence = pfx

			local spiritIndex = ability.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			ability.spirits_num_spirits = spiritIndex
			ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_wisp_spirit_handler", 
				{ 
					duraiton 			= -1,
					vision_radius 		= self.vision_radius,
					vision_duration 	= self.vision_duration,
					tinkerval 			= 360 / self.spirit_turn_rate / self.max_spirits,
					collision_radius 	= self.collision_radius,
					explosion_radius 	= self.explosion_radius,
					creep_damage 		= self.creep_damage,
					explosion_damage 	= self.explosion_damage,
				}
			)
		end
		
		--------------------------------------------------------------------------------
		-- Update the radius
		--------------------------------------------------------------------------------
		local currentRadius	= self.spirit_radius
		local deltaRadius 	= ability.spirits_movementFactor * self.spirit_movement_rate * 0.03
		currentRadius 		= currentRadius + deltaRadius
		currentRadius 		= math.min( math.max( currentRadius, self.spirit_min_radius ), self.spirit_max_radius )
		self.spirit_radius 	= currentRadius

		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1

				-- Rotate
				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, currentRadius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)

			end
		end

		if ability.update_timer > self.time_to_update then 
			ability.update_timer = 0
		end

		if ability.spirits_num_spirits == self.max_spirits and numSpiritsAlive == 0 then
			-- All spirits have been exploded.
			caster:RemoveModifierByName("modifier_wisp_spirits_lua")
			return
		end
	end
end

function modifier_wisp_spirits_lua:Explode(caster, spirit, explosion_radius, explosion_damage, ability)
	if IsServer() then
		EmitSoundOn("Hero_Wisp.Spirits.Target", spirit)
		ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, spirit)

		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeam(),
			spirit:GetAbsOrigin(), 
			nil, 
			explosion_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)
		
		damage_type = DAMAGE_TYPE_PHYSICAL
		local abil = caster:FindAbilityByName("npc_dota_hero_wisp_int11")	
		if abil ~= nil then
		damage_type = DAMAGE_TYPE_MAGICAL
		end
		

		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= damage_type
		damage_table.damage			= explosion_damage

		-- Deal damage to each enemy hero
		for _,enemy in pairs(nearby_enemy_units) do
			if enemy ~= nil then
				damage_table.victim = enemy

				ApplyDamage(damage_table)
			end
		end

		-- Let's just have another one here for Rubick to "properly" destroy Spirit particles
		if spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
			ParticleManager:ReleaseParticleIndex(spirit.spirit_pfx_silence)
		end
		
		ability.spirits_spiritsSpawned[spirit.spirit_index] = nil
	end
end

function modifier_wisp_spirits_lua:OnRemoved()
	if IsServer() then
		local ability 	= self:GetAbility()
		local caster 	= self:GetCaster()
		for k,spirit in pairs( ability.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
			end
		end

		self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
	end
end

-- not required
--[[
function modifier_wisp_spirits_lua:GetTexture()
	if self:GetAbility().spirits_movementFactor == 1 then
		return "custom/kunnka_tide_red"
	else
		return "custom/kunnka_tide_high"
	end
end
--]]

----------------------------------------------------------------------
--		SPIRITS	true_sight modifier 								--
----------------------------------------------------------------------
modifier_wisp_spirits_lua_true_sight = class({})
function modifier_wisp_spirits_lua_true_sight:IsAura()
    return true
end

function modifier_wisp_spirits_lua_true_sight:IsHidden()
    return true
end

function modifier_wisp_spirits_lua_true_sight:IsPurgable()
    return false
end

function modifier_wisp_spirits_lua_true_sight:GetAuraRadius()
    return self:GetStackCount()
end

function modifier_wisp_spirits_lua_true_sight:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_wisp_spirits_lua_true_sight:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_wisp_spirits_lua_true_sight:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_wisp_spirits_lua_true_sight:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_wisp_spirits_lua_true_sight:GetAuraDuration()
    return 0.5
end
----------------------------------------------------------------------
--		SPIRITS	on creep hit modifier 								--
----------------------------------------------------------------------
modifier_wisp_spirits_lua_creep_hit = class({})
function modifier_wisp_spirits_lua_creep_hit:IsHidden() return true end
function modifier_wisp_spirits_lua_creep_hit:OnCreated() 
	if IsServer() then
		local target = self:GetParent()
		EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", target)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
end

function modifier_wisp_spirits_lua_creep_hit:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
	end
end



----------------------------------------------------------------------
--		SPIRITS	modifier (keep them from getting targeted)			--
----------------------------------------------------------------------
modifier_imba_wisp_spirit_handler = class({})
function modifier_imba_wisp_spirit_handler:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		--[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 		= true,
	}

	return state
end

function modifier_imba_wisp_spirit_handler:OnCreated(params)
	if IsServer() then
		self.caster 			= self:GetCaster()
		self.ability 			= self:GetAbility()
		self.vision_radius 		= params.vision_radius
		self.vision_duration	= params.vision_duration
		self.tinkerval 			= params.tinkerval
		self.collision_radius 	= params.collision_radius
		self.explosion_radius 	= params.explosion_radius
		self.creep_damage 		= params.creep_damage
		self.explosion_damage 	= params.explosion_damage

		-- dmg timer and hittable
		self.damage_interval 	= 0.10
		self.damage_timer 		= 0
		self.ability.hit_table	= {}

		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_wisp_spirit_handler:OnIntervalThink()
	if IsServer() then 
		local spirit = self:GetParent()
		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			self.caster:GetTeam(),
			spirit:GetAbsOrigin(), 
			nil, 
			self.collision_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)

		spirit.hit_table = self.ability.hit_table
		if nearby_enemy_units ~= nil and #nearby_enemy_units > 0 then
			modifier_imba_wisp_spirit_handler:OnHit(self.caster, spirit, nearby_enemy_units, self.creep_damage, self.ability)
		end
	end
end

function modifier_imba_wisp_spirit_handler:OnHit(caster, spirit, enemies_hit, creep_damage, ability) 
	local hit_hero = false
	
		damage_type = DAMAGE_TYPE_PHYSICAL
		local abil = caster:FindAbilityByName("npc_dota_hero_wisp_int11")	
		if abil ~= nil then
		damage_type = DAMAGE_TYPE_MAGICAL
		end
	
	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= damage_type

	-- Deal damage to each enemy hero
	for _,enemy in pairs(enemies_hit) do
		-- cant dmg ded stuff + cant dmg if ded
		if enemy:IsAlive() and not spirit:IsNull() then 
			local hit = false

			damage_table.victim = enemy

				if spirit.hit_table[enemy] == nil then
					spirit.hit_table[enemy] = true
					enemy:AddNewModifier(caster, ability, "modifier_wisp_spirits_lua_creep_hit", {duration = 0.03})
					damage_table.damage	= creep_damage
					hit = true
			end

			if hit then
				ApplyDamage(damage_table)
			end
		end
	end
end

function modifier_imba_wisp_spirit_handler:OnRemoved()
	if IsServer() then
		local spirit	= self:GetParent()
		local ability	= self:GetAbility()
		
		modifier_wisp_spirits_lua:Explode(self.caster, spirit, self.explosion_radius, self.explosion_damage, ability)
		
		if spirit.spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
		end
		
		if spirit.spirit_pfx_disarm ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_disarm, true)
		end

		ability:CreateVisibilityNode(spirit:GetAbsOrigin(), self.vision_radius, self.vision_duration)

		spirit:ForceKill( true )
	end
end
-------------------------------------------------------------------------------------------------------------------------------------

modifier_spell_ampl_spirit = class({})

function modifier_spell_ampl_spirit:IsHidden()
	return false
end

function modifier_spell_ampl_spirit:IsPurgable()
	return false
end

function modifier_spell_ampl_spirit:OnCreated()
if IsServer() then
	caster = self:GetCaster()
    player = caster:GetOwner()
	spell_amp_spirits = player:GetSpellAmplification(false) * 100
	end
end

function modifier_spell_ampl_spirit:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_spell_ampl_spirit:GetModifierSpellAmplify_Percentage()
	return spell_amp_spirits
end
