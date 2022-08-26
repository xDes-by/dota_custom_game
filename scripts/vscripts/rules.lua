if Rules == nil then
	Rules = class({})
end

LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )

function donate_modifier(unit)
	if diff_wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
end	

function Rules:tower_hp()
	local towers={"npc_dota_custom_tower", "npc_dota_custom_tower2", "npc_dota_custom_tower3"}

	for key,value in ipairs(towers) do
		local tower = Entities:FindByName( nil, value)
		ApplyDamage({ victim = tower, attacker = tower, damage = 6800, damage_type = DAMAGE_TYPE_PHYSICAL })
		tower:AddNewModifier( tower, nil, "modifier_attack_immune", {} )
	end
end

timer_spawn_time_donate = 15

function Rules:spawn_creeps_donate()
	Timers:CreateTimer(function()
		local hRelay = Entities:FindByName( nil, "spawn_stack_donate" )
		hRelay:Trigger(nil,nil)
	  return timer_spawn_time_donate
	end)
end

function Rules:spawn_sheep()
t_sheep = {"sheep_point_1","sheep_point_2","sheep_point_3","sheep_point_4"}
local ent = t_sheep[RandomInt(1,#t_sheep)]
local point = Entities:FindByName(nil,ent):GetAbsOrigin()
local sheep = CreateUnitByName("sheep", point, false, nil, nil, DOTA_TEAM_GOODGUYS)
sheep:AddNewModifier( sheep, nil, "modifier_invulnerable", { } )
sheep:AddNewModifier( sheep, nil, "modifier_hide_on_minimap", { } )
end

function Rules:spawn_lina()
t_lina = {"lina_point_1","lina_point_2","lina_point_3","lina_point_4","lina_point_5","lina_point_6","lina_point_7"}
local ent = t_lina[RandomInt(1,#t_lina)]
local point = Entities:FindByName(nil,ent):GetAbsOrigin()
local lina = CreateUnitByName("lina", point, false, nil, nil, DOTA_TEAM_GOODGUYS)
lina:AddNewModifier( lina, nil, "modifier_invulnerable", { } )
lina:AddNewModifier( lina, nil, "modifier_hide_on_minimap", { } )


t_key = {"key_point_1","key_point_2","key_point_3","key_point_4","key_point_5"}
local ent = t_key[RandomInt(1,#t_key)]
local point = Entities:FindByName(nil,ent):GetAbsOrigin()
local newItem = CreateItem( "item_key", nil, nil )
local drop = CreateItemOnPositionForLaunch( point, newItem )
invulnerable()
end	


function invulnerable()
	local unit = Entities:FindByName(nil,"npc_boss_plague_squirrel")
	unit:AddNewModifier( unit, nil, "modifier_invulnerable", {} )
	unit:AddNewModifier( unit, nil, "modifier_medusa_stone_gaze_stone", {} )
	unit:AddNewModifier( unit, nil, "modifier_magic_immune", {} )
	-- Rules:Dummy()
end

function invulnerable_off()
	local unit = Entities:FindByName(nil,"npc_boss_plague_squirrel")
	unit:RemoveModifierByName( "modifier_invulnerable")
	unit:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unit:RemoveModifierByName("modifier_magic_immune")
	_G.Activate_belka = true
	creep_spawner:spawn_farm_zones()
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Rules:Dummy()
	local point = Entities:FindByName(nil,"dummy_point"):GetAbsOrigin()
	local hDummy = CreateUnitByName( "npc_dota_hero_target_dummy", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	
	local angle = hDummy:GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,180,0))
	hDummy:SetAngles(new_angle[1], new_angle[2], new_angle[3])
	
	hDummy:SetAbilityPoints( 0 )
	hDummy:Hold()
	hDummy:SetIdleAcquire( false )
	hDummy:SetAcquisitionRange( 0 )
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

_G.necronomicon = 1

function Rules:global_event()
	Timers:CreateTimer(1, function()
		--start_event()
	end)
end


-- global_event_points_1 = {"forest_spawn_2","forest_spawn_5","quest_line_3","forest_spawn_10"}
-- global_event_points_2 = {"forest_spawn_2","forest_spawn_5","quest_line_3","forest_spawn_10","village_spawn_2","village_spawn_4"}
-- global_event_points_3 = {"forest_spawn_2","forest_spawn_5","quest_line_3","forest_spawn_10","village_spawn_2","village_spawn_4","mines_spawn_3","mines_spawn_7","mines_spawn_9"}
-- global_event_points_4 = {"forest_spawn_2","forest_spawn_5","quest_line_3","forest_spawn_10","village_spawn_2","village_spawn_4","mines_spawn_3","mines_spawn_7","mines_spawn_9","dust_spawn_2","dust_spawn_4","dust_spawn_5"}
-- global_event_points_5 = {"forest_spawn_2","forest_spawn_5","quest_line_3","forest_spawn_10","village_spawn_2","village_spawn_4","mines_spawn_3","mines_spawn_7","mines_spawn_9","dust_spawn_2","dust_spawn_4","dust_spawn_5","swamp_spawn_1","swamp_spawn_6"}

-- function start_event()
	-- Timers:CreateTimer(660,function()
		-- local forest = Entities:FindByName( nil, "forest_dummy" )
		-- local village = Entities:FindByName( nil, "village_dummy" )
		-- local mines = Entities:FindByName( nil, "mines_dummy" )
		-- local cemetery = Entities:FindByName( nil, "cemetery_dummy" )
		
		-- spawn_events = 0
		
		-- if forest == nil then 
		-- spawn_events = 1
		-- end
		-- if village == nil then 
		-- spawn_events = 2
		-- end
		-- if mines == nil then 
		-- spawn_events = 3
		-- end
		-- if cemetery == nil then 
		-- spawn_events = 4
		-- end
		
		-- if spawn_events == 0 then 
			-- local ent = global_event_points_1[RandomInt(1,#global_event_points_1)]
			-- local point = Entities:FindByName(nil,ent):GetAbsOrigin()
			-- local RS = RandomInt(1,3)
				-- if RS == 1 then 
					-- spawn_gold(point)
				-- end
				-- if RS == 2 then 
					-- spawn_babka(point)
				-- end
				-- if RS == 3 then 
					-- spawn_roshan(point)
			-- end
		-- end

		-- if spawn_events == 1 then 
			-- local RS = RandomInt(1,3)
			-- local ent = global_event_points_2[RandomInt(1,#global_event_points_2)]
			-- local point = Entities:FindByName(nil,ent):GetAbsOrigin()
				-- if RS == 1 then 
					-- spawn_gold(point)
				-- end
				-- if RS == 2 then 
					-- spawn_babka(point)
				-- end
				-- if RS == 3 then 
					-- spawn_roshan(point)
				-- end
		-- end
		
		-- if spawn_events == 2 then 
			-- local RS = RandomInt(1,3)
			-- local ent = global_event_points_3[RandomInt(1,#global_event_points_3)]
			-- local point = Entities:FindByName(nil,ent):GetAbsOrigin()
				-- if RS == 1 then 
					-- spawn_gold(point)
				-- end
				-- if RS == 2 then 
					-- spawn_babka(point)
				-- end
				-- if RS == 3 then 
					-- spawn_roshan(point)
				-- end
		-- end
		
		-- if spawn_events == 3 then  
			-- local RS = RandomInt(1,3)
			-- local ent = global_event_points_4[RandomInt(1,#global_event_points_4)]
			-- local point = Entities:FindByName(nil,ent):GetAbsOrigin()
				-- if RS == 1 then 
					-- spawn_gold(point)
				-- end
				-- if RS == 2 then 
					-- spawn_babka(point)
				-- end
				-- if RS == 3 then 
					-- spawn_roshan(point)
				-- end
		-- end
		
		-- if spawn_events == 4 then  
			-- local RS = RandomInt(1,3)
			-- local ent = global_event_points_5[RandomInt(1,#global_event_points_5)]
			-- local point = Entities:FindByName(nil,ent):GetAbsOrigin()
				-- if RS == 1 then 
					-- spawn_gold(point)
				-- end
				-- if RS == 2 then 
					-- spawn_babka(point)
				-- end
				-- if RS == 3 then 
					-- spawn_roshan(point)
				-- end
		-- end
		-- return RandomInt(480,660)
	-- end)
-- end

-- function spawn_gold(point)
	-- local gd =  {"dragon_knight_drag_lasthit_04","dragon_knight_dragon_respawn_04","dragon_knight_drag_move_09"}
	-- EmitGlobalSound	(gd[RandomInt(1, #gd)])
	-- CustomGameEventManager:Send_ServerToAllClients( "global_event_dragon_show", {} )
	-- local creep = CreateUnitByName("GoldenDragon", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	-- creep:SetBaseDamageMin(set_damage_boss/2)
	-- creep:SetBaseDamageMax(set_damage_boss/2)
	-- creep:SetPhysicalArmorBaseValue(set_armor_boss/2)
	-- creep:SetBaseMagicalResistanceValue(set_mag_resist_boss/2)
	-- creep:SetMaxHealth(set_health_boss/2)
	-- creep:SetBaseMaxHealth(set_health_boss/2)
	-- creep:SetHealth(set_health_boss/2)		
	-- creep:SetDeathXP(xp*3)
	
	-- local mg_resist = creep:GetBaseMagicalResistanceValue()
		-- if mg_resist >= 90 then creep:SetBaseMagicalResistanceValue(90)
		-- end
	
	-- local total_hp = creep:GetMaxHealth()
	-- local porog_hp = 20000000
	-- local stack_modifier = math.floor(total_hp/porog_hp)
	
	-- if total_hp >= porog_hp then
	-- total_hp = porog_hp
	-- creep:SetBaseMaxHealth(total_hp)
	-- creep:SetMaxHealth(total_hp)
	-- creep:SetHealth(total_hp)
	-- creep:AddNewModifier(creep, nil, "modifier_health", nil):SetStackCount(stack_modifier)
	-- end      

	-- creep:AddNewModifier(creep, nil, "modifier_attack_speed", nil):SetStackCount(wave * 2)
	-- creep:AddNewModifier(creep, nil, "modifier_spell_ampl_creep", nil):SetStackCount(wave * 2)
	-- donate_modifier(creep)
-- end

-- function spawn_babka(point)
	-- local gd =  {"warlock_warl_incant_17","warlock_warl_incant_25"}
	-- EmitGlobalSound	(gd[RandomInt(1, #gd)])
	-- CustomGameEventManager:Send_ServerToAllClients( "global_event_warlock_show", {} )
	-- local creep = CreateUnitByName("Babka", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	-- creep:SetBaseDamageMin(set_damage_boss/2)
	-- creep:SetBaseDamageMax(set_damage_boss/2)
	-- creep:SetPhysicalArmorBaseValue(set_armor_boss/2)
	-- creep:SetBaseMagicalResistanceValue(set_mag_resist_boss/2)
	-- creep:SetMaxHealth(set_health_boss/2)
	-- creep:SetBaseMaxHealth(set_health_boss/2)
	-- creep:SetHealth(set_health_boss/2)		
	-- creep:SetDeathXP(xp*3)
	
	-- local mg_resist = creep:GetBaseMagicalResistanceValue()
		-- if mg_resist >= 90 then creep:SetBaseMagicalResistanceValue(90)
		-- end
	
	-- local total_hp = creep:GetMaxHealth()
	-- local porog_hp = 20000000
	-- local stack_modifier = math.floor(total_hp/porog_hp)
	
	-- if total_hp >= porog_hp then
	-- total_hp = porog_hp
	-- creep:SetBaseMaxHealth(total_hp)
	-- creep:SetMaxHealth(total_hp)
	-- creep:SetHealth(total_hp)
	-- creep:AddNewModifier(creep, nil, "modifier_health", nil):SetStackCount(stack_modifier)
	-- end      
	
	-- creep:AddNewModifier(creep, nil, "modifier_attack_speed", nil):SetStackCount(wave * 2)
	-- creep:AddNewModifier(creep, nil, "modifier_spell_ampl_creep", nil):SetStackCount(wave * 2)
	-- donate_modifier(creep)
-- end

-- function spawn_roshan(point)
	-- local gd =  {"techies_tech_setmine_52","techies_tech_setmine_14"}
	-- EmitGlobalSound	(gd[RandomInt(1, #gd)])
	-- CustomGameEventManager:Send_ServerToAllClients( "global_event_roshan_show", {} )
	-- local creep = CreateUnitByName("npc_treasure_chest", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	-- Timers:CreateTimer(60,function()	
		-- if creep:IsAlive() then
		-- creep:ForceKill(false)
		-- end
	-- end)	
-- end