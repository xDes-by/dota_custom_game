LinkLuaModifier("modifier_wisp_spirits_lua", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_handler", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_spirits_lua_creep_hit", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spell_ampl_spirit", "heroes/hero_wisp/wisp_spirits/wisp_spirits_lua", LUA_MODIFIER_MOTION_NONE )

wisp_spirits_lua = class({})

function wisp_spirits_lua:GetIntrinsicModifierName()
	return "modifier_wisp_spirits_lua"
end

------------------------------

modifier_wisp_spirits_lua = class({})

function modifier_wisp_spirits_lua:IsHidden()
	return true
end

function modifier_wisp_spirits_lua:IsPurgable()
	return false
end

function modifier_wisp_spirits_lua:OnCreated(params)
	if IsServer() then
		self.spirit_summon_interval 	= self:GetAbility():GetSpecialValueFor("spirit_summon_interval")
		self.max_spirits				= self:GetAbility():GetSpecialValueFor("num_spirits")
		self.spirit_min_radius			= self:GetAbility():GetSpecialValueFor("min_range")
		self.spirit_movement_rate 		= self:GetAbility():GetSpecialValueFor("spirit_movement_rate")
		self.spirit_turn_rate			= self:GetAbility():GetSpecialValueFor("spirit_turn_rate")

		self.update_timer 	= 0
		self.time_to_update = 0.5
		self.spirits_movementFactor = 1	
		self.spirits_num_spirits = 0
		self.spirits_spiritsSpawned = {}

		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	
		
		self.start_time = GameRules:GetGameTime()
		self:StartIntervalThink(0.03)
	end
end

function modifier_wisp_spirits_lua:OnRefresh(params)
	if IsServer() then
	
		for k,spirit in pairs( self.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
			end
		end
		self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
	
		self.spirit_summon_interval 	= self:GetAbility():GetSpecialValueFor("spirit_summon_interval")
		self.max_spirits				= self:GetAbility():GetSpecialValueFor("num_spirits")
		self.spirit_min_radius			= self:GetAbility():GetSpecialValueFor("min_range")
		self.spirit_movement_rate 		= self:GetAbility():GetSpecialValueFor("spirit_movement_rate")
		self.spirit_turn_rate			= self:GetAbility():GetSpecialValueFor("spirit_turn_rate")

		self.update_timer 	= 0
		self.time_to_update = 0.5
		self.spirits_movementFactor = 1	
		self.spirits_num_spirits = 0
		self.spirits_spiritsSpawned = {}

		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())	
		
		self.start_time = GameRules:GetGameTime()
		self:StartIntervalThink(0.03)
	end
end

function modifier_wisp_spirits_lua:OnIntervalThink()
	if IsServer() then
		local caster 					= self:GetCaster()
		local caster_position 			= caster:GetAbsOrigin()
		local elapsedTime 				= GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned 	= elapsedTime / self.spirit_summon_interval

		self.update_timer = self.update_timer + FrameTime()

		idealNumSpiritsSpawned 	= math.min(idealNumSpiritsSpawned, self.max_spirits)
		
		if self.spirits_num_spirits < idealNumSpiritsSpawned then
			local newSpirit = CreateUnitByName("npc_spitit_wisp", caster_position, false, caster, caster, caster:GetTeam())
			newSpirit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			
			if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int9") ~= nil then		
				local spr = newSpirit:FindAbilityByName("spirit_arc_lightning")
				spr:SetLevel(self:GetAbility():GetLevel())
				newSpirit:AddNewModifier(newSpirit, nil, "modifier_spell_ampl_spirit",  { }) 
			end

			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			newSpirit.spirit_pfx_silence = pfx

			local spiritIndex = self.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			self.spirits_num_spirits = spiritIndex
			self.spirits_spiritsSpawned[spiritIndex] = newSpirit
			newSpirit:AddNewModifier( caster,  self:GetAbility(),  "modifier_imba_wisp_spirit_handler", {})
		end

		local currentRotationAngle	= elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset	= 360 / self.max_spirits
		local numSpiritsAlive 		= 0

		for k,spirit in pairs( self.spirits_spiritsSpawned ) do
			if not spirit:IsNull() then
				numSpiritsAlive = numSpiritsAlive + 1

				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos 		= Vector(0, self.spirit_min_radius, 0)
				relPos 				= RotatePosition(Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos)
				local absPos 		= GetGroundPosition( relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)
			end
		end

		if self.update_timer > self.time_to_update then 
			self.update_timer = 0
		end
		
		if not caster:IsAlive() then
			for k,spirit in pairs( self.spirits_spiritsSpawned ) do
				if not spirit:IsNull() then
					spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
				end
			end
			self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
		end
	end
end

----------------------------------------------------------------------

modifier_imba_wisp_spirit_handler = class({})

function modifier_imba_wisp_spirit_handler:IsHidden()
	return false
end

function modifier_imba_wisp_spirit_handler:IsPurgable()
	return false
end

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
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.collision_radius = self.ability:GetSpecialValueFor("collision_radius")
		self.creep_damage = self:GetAbility():GetSpecialValueFor("creep_damage")

		if self.caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_wisp_int50") ~= nil then
			self.collision_radius = self.collision_radius + 100
		end

		if self.caster:FindAbilityByName("npc_dota_hero_wisp_int_last") ~= nil then
			self.creep_damage = self.creep_damage + self:GetCaster():GetIntellect()/2
		end
		
		if self.caster:FindAbilityByName("npc_dota_hero_wisp_agi6") ~= nil then
			self.creep_damage = self.creep_damage + self:GetCaster():GetAttackDamage()
		end
		self:StartIntervalThink(0.1)
	end
end



function modifier_imba_wisp_spirit_handler:OnIntervalThink()
	if IsServer() then 
		local spirit = self:GetParent()
		local enemies = FindUnitsInRadius( self.caster:GetTeam(), spirit:GetAbsOrigin(), nil, self.collision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if enemies ~= nil and #enemies > 0 then
			damage_type = DAMAGE_TYPE_PHYSICAL
			if self.caster:FindAbilityByName("npc_dota_hero_wisp_int11") ~= nil then
				damage_type = DAMAGE_TYPE_MAGICAL
			end
			
			for _,enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_wisp_spirits_lua_creep_hit") then
					enemy:AddNewModifier(self.caster, nil, "modifier_wisp_spirits_lua_creep_hit", {duration = 0.25})
					ApplyDamage({ victim = enemy, damage = self.creep_damage, damage_type = damage_type, attacker = self:GetCaster(), ability = self:GetAbility()})
				end
			end	
		end
	end
end

function modifier_imba_wisp_spirit_handler:OnRemoved()
	if IsServer() then
		local spirit = self:GetParent()
		local ability = self:GetAbility()
		
		if spirit.spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
		end
		spirit:ForceKill( true )
	end
end

--------------------------------------------

modifier_wisp_spirits_lua_creep_hit = class({})

function modifier_wisp_spirits_lua_creep_hit:IsHidden()
	return true
end

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
		spell_amp_spirits = self:GetCaster():GetOwner():GetSpellAmplification(false) * 100
	end
end

function modifier_spell_ampl_spirit:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_spell_ampl_spirit:GetModifierSpellAmplify_Percentage()
	return spell_amp_spirits
end
