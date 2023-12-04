
---------------------------------------------------------------------
-------------------------	Blink Strike	-------------------------
---------------------------------------------------------------------
-- Visible Modifiers:
LinkLuaModifier("modifier_static_link_lua_attribute", "heroes/hero_riki/riki_blink_strike_lua/riki_blink_strike_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blink_strike_lua_thinker", "heroes/hero_riki/riki_blink_strike_lua/modifier_blink_strike_lua_thinker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blink_strike_lua_cmd", "heroes/hero_riki/riki_blink_strike_lua/modifier_blink_strike_lua_cmd.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blink_strike_lua_talent", "heroes/hero_riki/riki_blink_strike_lua/modifier_blink_strike_lua_talent.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_charges", "heroes/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

riki_blink_strike_lua = riki_blink_strike_lua or class({})
function riki_blink_strike_lua:IsHiddenWhenStolen() return false end
function riki_blink_strike_lua:IsRefreshable() return true end
function riki_blink_strike_lua:IsStealable() return true end
function riki_blink_strike_lua:IsNetherWardStealable() return false end

function riki_blink_strike_lua:GetAbilityTextureName()
	return "riki_blink_strike"
end
function riki_blink_strike_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int9") then
		return 0
	end
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
-------------------------------------------

function riki_blink_strike_lua:CastFilterResultTarget(hTarget)
	if hTarget ~= self:GetCaster() then
		return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
	else
		return UF_FAIL_CUSTOM
	end
end

function riki_blink_strike_lua:GetCustomCastErrorTarget(hTarget)
	if hTarget == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function riki_blink_strike_lua:GetCastRange(location , target)
	if IsServer() then
		if self.thinker or self.tMarkedTargets then
			if self.tStoredTargets or self.tMarkedTargets then
				return 25000
			end
		end
	end
	return self.BaseClass.GetCastRange(self,location,target)
end

function riki_blink_strike_lua:OnAbilityPhaseStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		self.hTarget = self:GetCursorTarget()
		local hTarget = self.hTarget
		if self.thinker then
			if not self.thinker:IsNull() then
				self.thinker:Destroy()
			end
			self.thinker = nil
		end
		
		if hTarget == self:GetCaster() then
			return false
		end
		
		local jump_interval_frames = self:GetSpecialValueFor("jump_interval_frames")
		local cast_range = self.BaseClass.GetCastRange(self,hCaster:GetAbsOrigin(),hTarget)
		local current_distance = CalcDistanceBetweenEntityOBB(hCaster, hTarget)
		if (self:GetTalentSpecialValueFor("max_jumps") >= 1) and (current_distance > cast_range) and self.tStoredTargets then
			-- Once you start to begin to cast, the chain is set, and no additional target will be searched nor removed.
			-- This can only be prevented if you get disabled or stop the order
			self.tMarkedTargets = {}
			for _,target_entindex in pairs(self.tStoredTargets) do
				if not (target_entindex.IsCaster or target_entindex.IsTarget) then
					table.insert(self.tMarkedTargets, EntIndexToHScript(target_entindex.entity_index))
				end
			end
		else
			self.tMarkedTargets = nil
		end
		-- Clear the cache
		self.tStoredTargets = nil
		-- Only the trail particle function, lul
		local index = DoUniqueString("index")
		self.index = index
		local counter = 0
		local marked_counter = 1
		local current_target
		local last_position = hCaster:GetAbsOrigin()
		local tMarkedTargets
		if self.tMarkedTargets then
			tMarkedTargets = self.tMarkedTargets
			current_target = tMarkedTargets[marked_counter]
		else
			marked_counter = 0
			current_target = hTarget
		end
		self.trail_pfx = nil
		-- self.trail_pfx = ParticleManager:CreateParticleForTeam("particles/hero/riki/blink_trail.vpcf", PATTACH_ABSORIGIN, hCaster, hCaster:GetTeamNumber())
		-- ParticleManager:SetParticleControl(self.trail_pfx, 0, last_position+Vector(0,0,35))
		Timers:CreateTimer(FrameTime(), function()
			if self.trail_pfx then
				-- To make sure its the same cast
				if (index == self.index and not current_target:IsNull()) then
					ParticleManager:SetParticleControl(self.trail_pfx, 0, last_position+Vector(0,0,35))
					counter = counter + 1
					local target_loc = current_target:GetAbsOrigin()
					local distance = (last_position - target_loc):Length2D()
					local direction = (target_loc - last_position):Normalized()
					last_position = last_position + (direction * (distance/jump_interval_frames) * counter)
					ParticleManager:SetParticleControl(self.trail_pfx, 0, last_position)
					if counter >= jump_interval_frames then
						if (marked_counter == 0) or (marked_counter >= #tMarkedTargets+1) then
							ParticleManager:DestroyParticle(self.trail_pfx, false)
							ParticleManager:ReleaseParticleIndex(self.trail_pfx)
							return false
						else
							counter = 0
							marked_counter = marked_counter + 1
							if marked_counter > #tMarkedTargets then
								current_target = hTarget
							else
								current_target = tMarkedTargets[marked_counter]
							end
						end
					end
				else
					ParticleManager:DestroyParticle(self.trail_pfx, true)
					ParticleManager:ReleaseParticleIndex(self.trail_pfx)
					return false
				end
				return FrameTime()
			else
				return false
			end
		end)
		return true
	end
end

function riki_blink_strike_lua:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.thinker then
			local hCaster = self:GetCaster()
			self.thinker:Destroy()
			self.thinker = nil
			self.tStoredTargets = nil
			self.tMarkedTargets = nil
			ParticleManager:DestroyParticle(self.trail_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.trail_pfx)
			-- Reset this, it gets removed anyways if you do another order
			self.thinker = hCaster:AddNewModifier(hCaster, self, "modifier_blink_strike_lua_thinker", {target = self.hTarget:entindex()})
		end
	end
end

function riki_blink_strike_lua:OnSpellStart()
	if IsServer() then
		self.hCaster = self:GetCaster()
		self.hTarget = self:GetCursorTarget()
		local hTarget = self.hTarget

		if self.hTarget:TriggerSpellAbsorb(self) then return end

		-- Parameters
		self.damage = self:GetSpecialValueFor("bonus_damage") or self:GetSpecialValueFor("damage")
		self.duration = self:GetTalentSpecialValueFor("duration")
		local jump_duration = 0
		local cast_sound = "Hero_Riki.Blink_Strike"
		self.hCaster:Stop()
		if self.tMarkedTargets then
			local tMarkedTargets = self.tMarkedTargets
			self.jump_interval_frames = self:GetSpecialValueFor("jump_interval_frames")
			local jump_interval_time = self.jump_interval_frames * FrameTime()
			jump_duration = #tMarkedTargets * jump_interval_time + jump_interval_time
			self.hCaster:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_cmd", {duration = jump_duration})
			table.insert(tMarkedTargets, hTarget)
			for i = 1, (#tMarkedTargets - 1) do
				Timers:CreateTimer(i*jump_interval_time, function()
					self:DoJumpAttack(tMarkedTargets[i], tMarkedTargets[(i+1)])
				end)
			end
		else
			self.hCaster:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_cmd", {duration = FrameTime()})
		end

		local damage_type = self:GetAbilityDamageType()

		Timers:CreateTimer(jump_duration, function()
			local target_loc_forward_vector = hTarget:GetForwardVector()
			local final_pos = hTarget:GetAbsOrigin() - target_loc_forward_vector * 100
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_ABSORIGIN, self.hCaster)
			ParticleManager:SetParticleControl(particle, 1, final_pos)
			ParticleManager:ReleaseParticleIndex(particle)
			FindClearSpaceForUnit(self.hCaster, final_pos, true)
			self.hCaster:MoveToTargetToAttack(hTarget)
			if (hTarget:GetTeamNumber() ~= self.hCaster:GetTeamNumber()) then
				ApplyDamage({victim = hTarget, attacker = self.hCaster, damage = self.damage, damage_type = damage_type})
				hTarget:AddNewModifier(self.hCaster, self, "modifier_blink_strike_lua_debuff_turn", {duration = self.duration * (1 - hTarget:GetStatusResistance())})
				if self.hCaster:FindAbilityByName("npc_dota_hero_riki_str9") then 
					hTarget:AddNewModifier(self.hCaster, self, "modifier_generic_stunned_lua", {duration = 2})
				end
			end
			self.hCaster:SetForwardVector(target_loc_forward_vector)
			EmitSoundOn("Hero_Riki.Blink_Strike", hTarget)

			-- #1 Talent: Blink Strike now leaves Smokescreen for 1 second after each instance
			-- if self.hCaster:HasTalent("special_bonus_imba_riki_1") then
			-- 	local smokescreen_ability = self.hCaster:FindAbilityByName("imba_riki_smoke_screen")
			-- 	if smokescreen_ability:GetLevel() >=1 then
			-- 		local target_point = final_pos
			-- 		local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"

			-- 		local duration = self.hCaster:FindTalentValue("special_bonus_imba_riki_1")
			-- 		local aoe = smokescreen_ability:GetSpecialValueFor("area_of_effect")
			-- 		local smoke_handler = "modifier_imba_smoke_screen_handler"
			-- 		local smoke_sound = "Hero_Riki.Smoke_Screen"

			-- 		EmitSoundOnLocationWithCaster(target_point, smoke_sound, self.hCaster)

			-- 		local thinker = CreateModifierThinker(self.hCaster, smokescreen_ability, smoke_handler, {duration = duration, target_point_x = target_point.x , target_point_y = target_point.y}, target_point, self.hCaster:GetTeamNumber(), false)

			-- 		local smoke_particle_fx = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, thinker)
			-- 		ParticleManager:SetParticleControl(smoke_particle_fx, 0, thinker:GetAbsOrigin())
			-- 		ParticleManager:SetParticleControl(smoke_particle_fx, 1, Vector(aoe, 0, aoe))

			-- 		Timers:CreateTimer(duration, function()
			-- 			ParticleManager:DestroyParticle(smoke_particle_fx, false)
			-- 			ParticleManager:ReleaseParticleIndex(smoke_particle_fx)
			-- 			smoke_particle_fx = nil
			-- 		end)
			-- 	end
			-- end
		end)
		-- if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi11") and self:GetCaster():FindAbilityByName("riki_tricks_of_the_trade_lua"):GetLevel() > 0 then
		-- 	tricks_of_the_trade = self:GetCaster():FindAbilityByName("riki_tricks_of_the_trade_lua")
		-- 	tricks_of_the_trade:OnAbilityPhaseStart()
		-- 	tricks_of_the_trade:OnSpellStart()
		-- 	tricks_of_the_trade:OnAbilityPhaseInterrupted()
		-- 	tricks_of_the_trade:SetChanneling(true)
		-- end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi11") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_blink_strike_lua_talent", {duration = 5})
		end
		self.tStoredTargets = nil
		self.tMarkedTargets = nil
		self.hTarget = nil
	end
end

function riki_blink_strike_lua:DoJumpAttack(hTarget, hNextTarget)
	self.hCaster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	self.hCaster:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
	EmitSoundOn("Hero_Riki.Blink_Strike", hTarget)
	local target_loc = hTarget:GetAbsOrigin()
	local next_target_loc = hNextTarget:GetAbsOrigin()

	-- #1 Talent: Blink Strike now leaves Smokescreen for 1 second after each instance
	-- if self.hCaster:HasTalent("special_bonus_imba_riki_1") then
	-- 	local smokescreen_ability = self.hCaster:FindAbilityByName("imba_riki_smoke_screen")
	-- 	if smokescreen_ability:GetLevel() >=1 then
	-- 		local target_point = target_loc
	-- 		local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"

	-- 		local duration = self.hCaster:FindTalentValue("special_bonus_imba_riki_1")
	-- 		local aoe = smokescreen_ability:GetSpecialValueFor("area_of_effect")
	-- 		local smoke_handler = "modifier_imba_smoke_screen_handler"
	-- 		local smoke_sound = "Hero_Riki.Smoke_Screen"

	-- 		EmitSoundOnLocationWithCaster(target_point, smoke_sound, self.hCaster)

	-- 		local thinker = CreateModifierThinker(self.hCaster, smokescreen_ability, smoke_handler, {duration = duration, target_point_x = target_point.x , target_point_y = target_point.y}, target_point, self.hCaster:GetTeamNumber(), false)

	-- 		local smoke_particle_fx = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, thinker)
	-- 		ParticleManager:SetParticleControl(smoke_particle_fx, 0, thinker:GetAbsOrigin())
	-- 		ParticleManager:SetParticleControl(smoke_particle_fx, 1, Vector(aoe, 0, aoe))

	-- 		Timers:CreateTimer(duration, function()
	-- 			ParticleManager:DestroyParticle(smoke_particle_fx, false)
	-- 			ParticleManager:ReleaseParticleIndex(smoke_particle_fx)
	-- 			smoke_particle_fx = nil
	-- 		end)
	-- 	end
	-- end

	local direction = (target_loc - next_target_loc):Normalized()
	if (hTarget:GetTeamNumber() == self.hCaster:GetTeamNumber()) then
		self.hCaster:SetForwardVector(direction)
		local start_loc = target_loc + Vector(0,0,100)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_ABSORIGIN, self.hCaster)
		ParticleManager:SetParticleControl(particle, 1, start_loc)
		ParticleManager:ReleaseParticleIndex(particle)
		local distance = 200 / self.jump_interval_frames
		self.hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
		for i=1, (self.jump_interval_frames - 1) do
			Timers:CreateTimer(FrameTime()*i, function()
				local location = (start_loc - direction * distance * i)
				self.hCaster:SetAbsOrigin(location)
				self.hCaster:SetForwardVector(direction)
			end)
		end
	else
		self.hCaster:SetForwardVector(direction)
		local location = target_loc - (hTarget:GetForwardVector()*100)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_ABSORIGIN, self.hCaster)
		ParticleManager:SetParticleControl(particle, 1, location)
		ParticleManager:ReleaseParticleIndex(particle)
		self.hCaster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.5)
		self.hCaster:PerformAttack(hTarget, true, true, true, false, false, false, false)
		ApplyDamage({victim = hTarget, attacker = self.hCaster, damage = self.damage, damage_type = self:GetAbilityDamageType()})
		hTarget:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_debuff_turn", {duration = self.duration * (1 - hTarget:GetStatusResistance())})
		self.hCaster:SetAbsOrigin(location)
	end
end

riki_blink_strike_723_lua			= riki_blink_strike_lua