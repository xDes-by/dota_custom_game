tp = class({})

LinkLuaModifier("modifier_other2", "modifiers/modifier_other2", LUA_MODIFIER_MOTION_NONE)

local settings = {
    boss = {item = "item_raid_ticket", place = "raid_out"},
    brewmaster = {item = "item_raid_ticket2", place = "raid2_out"},
    Wyvern = {item = "item_raid_ticket3", place = "raid3_out"},
    Ursa = {item = "item_raid_ticket4", place = "raid4_out"},
    roshan = {item = "item_kristal", place = "roshan_out"},
    traps = {item = "item_trap_ticket", place = "traps_out"},
}

function tp:tp_check_lua(t)
    --DeepPrintTable(t)
    
    local item = settings[ t[ 'type' ] ][ 'item' ] -- название предмета 
    local place = settings[ t[ 'type' ] ][ 'place' ] -- местность
    --делает тп если есть шмотка
    local activator = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    if activator:HasItemInInventory( item ) then
        for i = 0, 8 do
            local current_item = activator:GetItemInSlot(i)
            if current_item and current_item:GetName() == item then
                activator:RemoveItem( current_item )
            end
        end
        activator:AddNewModifier( activator, nil, "modifier_other2", {} )
        local part = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2.vpcf", PATTACH_ABSORIGIN, activator) 
        activator:EmitSound("Portal.Loop_Appear")
        StartAnimation(activator, {duration = 2.5, activity = ACT_DOTA_TELEPORT})
        Timers:CreateTimer({
        endTime = 2.5,
        callback = function()
            ParticleManager:DestroyParticle( part, false )
            ParticleManager:ReleaseParticleIndex( part )
            activator:StopSound("Portal.Loop_Appear")        
            activator:Stop()
            activator:RemoveModifierByName( "modifier_other2")
            local ent = Entities:FindByName( nil, place) 
            local point = ent:GetAbsOrigin()
            FindClearSpaceForUnit(activator, point, false)
            activator:SetAbsOrigin( point ) 
            --local playerID = t.PlayerID:GetPlayerOwnerID() если не будет работать заменить на локалку    
            PlayerResource:SetCameraTarget(t.PlayerID , activator)
            Timers:CreateTimer(0.1, function()
                PlayerResource:SetCameraTarget(t.PlayerID , nil)
            end)
        end})
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "tp_check_js", { successfully = true } )
    else
        --сделай красиво ежи
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "tp_check_js", { successfully = false } )
    end
end