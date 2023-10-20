traps_table = {
	 [1] = {2,1,3},
	 [2] = {1,2,2},
	 [3] = {3,1,2},
	 [4] = {1,3,2},
	 [5] = {3,4,5},
	 [6] = {1,3,2},
	 [7] = {4,5,3},
	 [8] = {4,3,5},
	 [9] = {5,4,3},
	 [10] = {6,6,5},
	 [11] = {5,5,4},
	 [12] = {6,5,7},
	 [13] = {6,7,6},
	 [14] = {8,9,8},
	 [15] = {7,7,6},
	 [16] = {8,8,9},
	 [17] = {8,7,7},
	 [18] = {9,8,9},
	 [19] = {9,10,11},
	 [20] = {10,10,9},
	 [21] = {11,9,10},
	 [22] = {10,11,12},
	 [23] = {11,12,10},
	 [24] = {12,12,11},
}



local roll_trap = false
local triggerActive = true

function OnStartTouch(trigger)
	if not roll_trap then
		traps_set = RandomInt(1,3)
		roll_trap = true
	end
	local triggerName = thisEntity:GetName()
	if not triggerActive then
		return
	end
	
	local number = tonumber(string.match(triggerName, "_(%d+)"))
	
	triggerActive = false
	local button_name = 'trap_button_name_'..number
	
	local model = 'trap_model_'..traps_table[tonumber(number)][traps_set]
	local npc = Entities:FindAllByName('trap_npc_'..traps_table[tonumber(number)][traps_set])
	local target = Entities:FindAllByName('trap_target_'..traps_table[tonumber(number)][traps_set])
	
	for k,v in ipairs(npc) do
		local venomTrap = v:FindAbilityByName("breathe_poison")
		v:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 0.5 )
		v:CastAbilityOnPosition(target[k]:GetOrigin(), venomTrap, -1 )
		DoEntFire( model, "SetAnimation", "fang_attack", .0, self, self )
	end

	DoEntFire( button_name, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button_name, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button_name, "SetAnimation", "ancient_trigger001_up", 0.5, self, self )
	DoEntFire( button_name, "SetAnimation", "ancient_trigger001_idle", 0.6, self, self )
end

function ResetButtonModel()
	triggerActive = true
end
