function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	local unit_name = npc:GetUnitName()
	if unit_name ~= "npc_dota_thinker" then
		npc:AddNewModifier(npc, nil, "modifier_damage_controller", nil)
	end
	
	if npc:GetName() == "npc_dota_clinkz_skeleton_archer" then
		
		-- Kill skeletons if they spawned not in proper place
		Timers:CreateTimer(0, function() 
			local owner = npc:GetOwner()
			if Enfos:IsEnfosMode() then
				if BoundEnforcer:EnforceEnfosBounds(npc, npc:GetAbsOrigin(), owner:GetTeam(), false, false) then
					npc:ForceKill(false)
				end
			else
				npc.unit_state = GameMode:GetTeamState(owner:GetTeam())
				if npc.unit_state == TEAM_STATE_ON_BASE or BoundEnforcer:EnforceBounds(npc, owner:GetTeam(), false, false) then
					npc:ForceKill(false)
				end
			end
		end)

		-- this accounts for both burning army and wind walk
		npc:AddNewModifier(npc, nil, "modifier_clinkz_skeletons", {})
		Timers:CreateTimer(20, function()
			if npc and not npc:IsNull() and npc:IsAlive() then npc:ForceKill(false) end
		end)
	end
	
	
	local owner = npc:GetOwner()
	if npc and npc:GetUnitName():find("npc_dota_lone_druid_bear") then
		owner.current_spirit_bear = npc

		if owner:IsTempestDouble() then
			if owner.spiritbear_tempestdouble_items then
				for key, item_name in pairs(owner.spiritbear_tempestdouble_items) do
					npc:AddItemByName(item_name)
				end
			end
			owner.spiritbear_tempestdouble_items = nil
		end

		npc:AddAbility("empty_0")
	end
	
	if owner and (not npc:IsRealHero()) and owner.IsRealHero and (owner:IsRealHero() or owner:IsTempestDouble()) then
		local playerId = npc:GetPlayerOwnerID()
		local owner_curse = owner:FindModifierByName("modifier_loser_curse")
		if owner_curse then
			local debuff = npc:AddNewModifier(npc, nil, "modifier_loser_curse", {})
			debuff:SetStackCount(owner_curse:GetStackCount())
		end

		npc.unit_state = Enfos:IsEnfosMode() and GameMode:GetPlayerState(playerId) or GameMode:GetTeamState(owner:GetTeam())
	end
	
	Timers:CreateTimer(1/30, function()
		Illusions:HandleIllusion(npc)
	end)

--	print("NPC Spawned:", npc:GetUnitName())
	
	Timers:CreateTimer(2, function()
		if IsValidEntity(npc) and npc.IsRealHero and npc:IsRealHero() and npc:GetPlayerID() 
		and (PlayerResource:GetConnectionState(npc:GetPlayerID()) == DOTA_CONNECTION_STATE_NOT_YET_CONNECTED) then
			local playerId = npc:GetPlayerID()
			if(not npc.stopspam) then
				npc.stopspam = true
				CustomGameEventManager:Send_ServerToAllClients("player_show_aegis_init", { playerId = playerId, aegisCount = 2, firstInit = true})
				CustomGameEventManager:Send_ServerToTeam(PlayerResource:GetTeam(playerId), "TeammateSelectHero", {
					playerId = playerId,
					heroName = npc:GetName(),
					state = 1,
				})
			end
--			print("Attempt to add auto attack modifier")
			npc:AddNewModifier(npc, nil, "modifier_auto_attack", {})
			return nil
		end
	end)

	if npc and npc:GetTeam() == DOTA_TEAM_NEUTRALS and Round.overTime and Round.overTime < ROUND_MANAGER_OVERTIME_DURATION then
		Timers:CreateTimer(0.3, function()
			if npc and npc:IsAlive() and (not npc:IsNull()) then
				npc:AddNewModifier(npc, nil, "modifier_creature_berserk", {})
			end
		end)
	end
end
