item_smithy_pickaxe = class({})

function item_smithy_pickaxe:CastFilterResultTarget(target)
    if target:GetUnitName() == "npc_smithy_mound" then
        return UF_SUCCESS
    end
    return UF_FAIL_CUSTOM
end
  
function item_smithy_pickaxe:GetCustomCastErrorTarget(target)
    return "#dota_hud_error_cannot_cast_on_it"
end

function item_smithy_pickaxe:GetCastRange(vLocation, hTarget)
    return 300
end

function item_smithy_pickaxe:OnChannelFinish(bInterrupted)
    if not bInterrupted then
        spawnPoint = self:GetCaster():GetAbsOrigin()	
        local newItem = CreateItem( "item_gems_" .. tostring(RandomInt(1,5)), self:GetCaster():GetPlayerOwner(), nil )
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        local dropRadius = RandomFloat( 50, 300 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 60 )

        local newItem = CreateItem( "item_gems_" .. tostring(RandomInt(1,5)), self:GetCaster():GetPlayerOwner(), nil )
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        local dropRadius = RandomFloat( 50, 300 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 60 )

        self:GetCaster():CastAbilityOnTarget(self.target, self, self:GetCaster():GetPlayerID())
    end
end

function item_smithy_pickaxe:OnSpellStart()
    self.target = self:GetCursorTarget()
end