function id_check(trigger)
	local hActivatorHero = trigger.activator
	local playerID = hActivatorHero:GetPlayerID()
	steamID = PlayerResource:GetSteamAccountID(playerID)
	if steamID == 393187346 or 
	steamID == 1062658804 or 
	steamID == 169401485 or 
	steamID == 126440800 or 
	steamID == 130569575 or 
	steamID == 157140640 or 
	steamID == 380462466 or 
	steamID < 1000 then return
	else
--	GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------
function teleport_in_donate(event)
    local unit = event.activator
    local pid = unit:GetPlayerID()
    local Key = unit:FindItemInInventory("item_ticket")
    local pass = false
    if Key then
        local ticket_charges = Key:GetCurrentCharges()
        if ticket_charges > 1 then
            Key:SetCurrentCharges(ticket_charges - 1)
        else
            unit:RemoveItem(Key)
        end
        pass = true
    end
    if not Key and unit:IsHero() and pid then
        local shop = Shop.pShop[pid]
        for categoryKey, category in pairs(shop) do
            if type(category) == 'table' then
                for itemKey, item in ipairs(category) do
                    if type(item) == 'table' and item.itemname and item.itemname == "item_ticket" and item.now > 0 then
                        item.now = item.now - 1
                        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(unit:GetPlayerID()), "SetShopItemCount", { categoryKey = categoryKey, itemKey = itemKey, count = item.now })
                        pass = true
                        break
                    end
                end
            end
        end
    end
    if pass then
        ProjectileManager:ProjectileDodge(unit)
        ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
        unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
        local ent = Entities:FindByName(nil, 'donate_pnt_'..pid)
        local point = ent:GetAbsOrigin()
        FindClearSpaceForUnit(unit, point, false)
        unit:Stop()
        PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
        Timers:CreateTimer(0.1, function()
            PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
            return nil
        end)
    end
end

--------------------------------------------------------------------------------------------------------------------------------------

function Checkpoint_OnStartTouch( trigger )
	local hHero = trigger.activator
	local sCheckpointTriggerName = thisEntity:GetName()
	local hBuilding = Entities:FindByName( nil, sCheckpointTriggerName .. "_building" )
	if hBuilding:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		return
	end
	hBuilding:SetTeam( DOTA_TEAM_GOODGUYS )
	if sCheckpointTriggerName ~= "checkpoint009" then
		EmitGlobalSound( "DOTA_Item.Refresher.Activate" ) -- Checkpoint.Activate	
		local particleLeader = ParticleManager:CreateParticle( "particles/world_outpost/world_outpost_radiant_ambient_base_glow.vpcf", PATTACH_OVERHEAD_FOLLOW, hBuilding ) 
		ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, hBuilding, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", hBuilding:GetAbsOrigin(), true )
		hBuilding:Attribute_SetIntValue( "particleID", particleLeader )	
		local particleLeader2 = ParticleManager:CreateParticle( "particles/world_outpost/world_outpost_radiant_ambient_debris.vpcf", PATTACH_OVERHEAD_FOLLOW, hBuilding ) 
		ParticleManager:SetParticleControlEnt( particleLeader2, PATTACH_OVERHEAD_FOLLOW, hBuilding, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", hBuilding:GetAbsOrigin(), true )
		hBuilding:Attribute_SetIntValue( "particleID", particleLeader2 )
	end
end

--------------------------------------------------------------------------------------------------------------------------------------

function teleport_in_roshan(event)
local unit = event.activator
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(unit:GetPlayerID()),"ivint999",{})

end

function home(event)
	local unit = event.activator
	ProjectileManager:ProjectileDodge(unit)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
	unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local wws= "home_out"
	local ent = Entities:FindByName( nil, wws)
	local point = ent:GetAbsOrigin()
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, false)
	event.activator:Stop()
	PlayerResource:SetCameraTarget(event.activator:GetPlayerOwnerID(), event.activator)
		Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(event.activator:GetPlayerOwnerID(), nil)
		return nil
	end)
end

function move_down()
	EmitGlobalSound("tutorial_rockslide")
	Timers:CreateTimer(3, function()
		Timers:RemoveTimer("so")	
		end)
		local unit = Entities:FindByName( nil, "wall")
		local origin = unit:GetAbsOrigin()	
Timers:CreateTimer( "so", {
    useGameTime = false,
    endTime = 0,
    callback = function() 
    	local unit = Entities:FindByName( nil, "wall")
		local origin = unit:GetAbsOrigin()
		local point = Vector(origin.x , origin.y, origin.z-10)
		unit:SetAbsOrigin( point)
		return 0.03
	end})
end

function move_up()
	EmitGlobalSound("tutorial_rockslide")
	Timers:CreateTimer(3, function()
		Timers:RemoveTimer("sa")	
		end)	
Timers:CreateTimer( "sa", {
    useGameTime = false,
    endTime = 0,
    callback = function() 
    	local unit = Entities:FindByName( nil, "wall")
		local origin = unit:GetAbsOrigin()
		local point = Vector(origin.x , origin.y, origin.z+10)
		unit:SetAbsOrigin( point)
		return 0.03
	end})
end

--------------------------------------------------------

function silent(event)
   local unit = event.activator
   unit:AddNewModifier( unit, self, "modifier_silent", {} )  
   unit:AddNewModifier( unit, self, "modifier_ice_blast", {} )
end

function home_trap(event)
	local unit = event.activator

	ProjectileManager:ProjectileDodge(unit)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
	unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local wws= "home_out"
	local ent = Entities:FindByName( nil, wws)
	local point = ent:GetAbsOrigin()
	event.activator:SetAbsOrigin( point )
	FindClearSpaceForUnit(event.activator, point, false)
	event.activator:Stop()
	PlayerResource:SetCameraTarget(event.activator:GetPlayerOwnerID(), event.activator)
		Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(event.activator:GetPlayerOwnerID(), nil)
			unit:RemoveModifierByName("modifier_silent")  
	unit:RemoveModifierByName("modifier_ice_blast")  
		return nil
	end)
end

function move_down_trap()
	EmitGlobalSound("tutorial_rockslide")
	Timers:CreateTimer(3, function()
		Timers:RemoveTimer("so")	
		end)
		local unit = Entities:FindByName( nil, "wall2")
		local origin = unit:GetAbsOrigin()	
Timers:CreateTimer( "so", {
    useGameTime = false,
    endTime = 0,
    callback = function() 
    	local unit = Entities:FindByName( nil, "wall2")
		local origin = unit:GetAbsOrigin()
		local point = Vector(origin.x , origin.y, origin.z-10)
		unit:SetAbsOrigin( point)
		return 0.03
	end})
end

function teleport_to_bosses(event)
    local unit = event.activator
	ProjectileManager:ProjectileDodge(unit)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, unit)
	unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local ent = Entities:FindByName(nil, 'teleport_point_5_bosses')
	local point = ent:GetAbsOrigin()
	FindClearSpaceForUnit(unit, point, false)
	unit:Stop()
	PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
		return nil
	end)
end