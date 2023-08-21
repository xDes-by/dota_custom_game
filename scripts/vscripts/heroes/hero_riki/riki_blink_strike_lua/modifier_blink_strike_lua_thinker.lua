modifier_blink_strike_lua_thinker = modifier_blink_strike_lua_thinker or class({})
function modifier_blink_strike_lua_thinker:IsDebuff() return false end
function modifier_blink_strike_lua_thinker:IsHidden() return true end
function modifier_blink_strike_lua_thinker:IsPurgable() return false end
function modifier_blink_strike_lua_thinker:IsPurgeException() return false end
function modifier_blink_strike_lua_thinker:IsStunDebuff() return false end
-------------------------------------------
function modifier_blink_strike_lua_thinker:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_ORDER
		}
	return decFuns
end

function modifier_blink_strike_lua_thinker:OnOrder(params)
	if IsServer() then
		if params.unit == self:GetCaster() and self.created_flag then
			local activity = params.unit:GetCurrentActiveAbility()
			if activity then
				if not (activity:GetName() == "imba_riki_blink_strike") then
					self.hAbility.tStoredTargets = nil
					self.hAbility.tMarkedTargets = nil
					self.hAbility.hTarget = nil
					self.hAbility.thinker = nil
					self:Destroy()
				end
			end
		end
	end
end

function modifier_blink_strike_lua_thinker:OnCreated(params)
	if IsServer() then
		self.hCaster = self:GetCaster()
		if params.target then
			self.hTarget = EntIndexToHScript(params.target)
		else
			self:Destroy()
		end
		self.hAbility = self:GetAbility()
		-- Parameters
		self.jump_range = self.hAbility:GetSpecialValueFor("jump_range") + GetCastRangeIncrease(self.hCaster)
		self.max_jumps = self.hAbility:GetTalentSpecialValueFor("max_jumps")
		self.jump_interval_time = self.hAbility:GetSpecialValueFor("jump_interval_time")
		self.lagg_threshold = self.hAbility:GetSpecialValueFor("lagg_threshold")
		self.cast_range = self.hAbility.BaseClass.GetCastRange(self.hAbility,self.hCaster:GetAbsOrigin(),self.hTarget) + GetCastRangeIncrease(self.hCaster)
		self.max_range = self.cast_range + self.max_jumps * self.jump_range
		Timers:CreateTimer(FrameTime(), function()
			self.created_flag = true
		end)
		-- Run this instantly, not after 1 Frame delay
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_blink_strike_lua_thinker:OnIntervalThink()
	if IsServer() then
		-- If already found a chain, don't recheck (They are "marked", thus will always get hit like Sleight of fist)
		if (not self.hAbility.tStoredTargets) then
			local current_distance = CalcDistanceBetweenEntityOBB(self.hCaster, self.hTarget)
			-- No need for calculations if they already exceed max-range
			if (current_distance <= self.max_range) or (current_distance < self.cast_range) then
				local tJumpableUnits = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil, self.max_range, self.hAbility:GetAbilityTargetTeam(), self.hAbility:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
				-- Creating nodes for A*, a 2D-graph for calculations, using x and y coordinates
				local graph = {}
				local caster_index
				local target_index
				-- Making a table suitable for the A*-algorithm, adding a lagg-threshold to ensure mass units affect performance (e.g. Broodmother)
				for i=1,math.min(#tJumpableUnits,self.lagg_threshold) do
					local pos = tJumpableUnits[i]:GetAbsOrigin()
					graph[i] = {}
					graph[i].x = pos.x
					graph[i].y = pos.y
					graph[i].entity_index = tJumpableUnits[i]:entindex()
					if (tJumpableUnits[i] == self.hCaster) then
						caster_index = i
						graph[i].IsCaster = true
					elseif (tJumpableUnits[i] == self.hTarget) then
						target_index = i
						graph[i].IsTarget = true
					end
				end
				-- If it exceed the lagg-limit, check if both caster and target are in it, else add them
				if not caster_index then
					local pos = self.hCaster:GetAbsOrigin()
					caster_index = 0
					graph[caster_index] = {}
					graph[caster_index].x = pos.x
					graph[caster_index].y = pos.y
					graph[caster_index].IsCaster = true
				end
				if not target_index then
					local pos = self.hTarget:GetAbsOrigin()
					target_index = self.lagg_threshold + 1
					graph[target_index] = {}
					graph[target_index].x = pos.x
					graph[target_index].y = pos.y
					graph[target_index].IsTarget = true
				end
				
				-- if astar can't be found in the global scope try requiring the library again
				if not astar then
					astar = require('libraries/astar')
				end
				-- This are the parameters for the A-star.
				local valid_node_func = function ( node, neighbor )
					
					if (node.IsCaster and (astar.distance(node.x,node.y,neighbor.x,neighbor.y ) < self.cast_range)) or
						(astar.distance(node.x,node.y,neighbor.x,neighbor.y ) < self.jump_range) then
						return true
					end
					return false
				end
				-- This is the call for the algorithm. Returns nil if no valid path was found
				local path = astar.path(graph[caster_index],graph[target_index],graph,true,valid_node_func)
				if path then
					if (#path <= self.max_jumps+2) and (not (#path == 2)) then
						self.hAbility.tStoredTargets = path
						-- No need to re-run anymore, thinker gets destroyed if it parsed all variables.
						self:StartIntervalThink(-1)
					end
				end
			else
				-- If there are unforseen circumstances this will bre resetted. Optimaly this will never run.
				self.hAbility.tStoredTargets = nil
			end
		end
	end
end