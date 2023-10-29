item_smithy_pickaxe = class({})

LinkLuaModifier( "modifier_item_smithy_pickaxe", "items/other/item_smithy_pickaxe", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_smithy_pickaxe_pasive", "items/other/item_smithy_pickaxe", LUA_MODIFIER_MOTION_NONE )

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

function item_smithy_pickaxe:GetCooldown(iLevel)
    return self.ChannelTime or 0
end

function item_smithy_pickaxe:GetChannelTime()
    return self.ChannelTime
end

function item_smithy_pickaxe:OnChannelFinish()
    self.mod:Destroy()
    self:EndCooldown()
end

function item_smithy_pickaxe:OnSpellStart()
    self.caster = self:GetCaster()
    self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_smithy_pickaxe", {duration = self.ChannelTime})
end

function item_smithy_pickaxe:GetIntrinsicModifierName()
    return "modifier_item_smithy_pickaxe_pasive"
end

modifier_item_smithy_pickaxe_pasive = class({})
--Classifications template
function modifier_item_smithy_pickaxe_pasive:IsHidden()
    return true
end

function modifier_item_smithy_pickaxe_pasive:IsDebuff()
    return false
end

function modifier_item_smithy_pickaxe_pasive:IsPurgable()
    return false
end

function modifier_item_smithy_pickaxe_pasive:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_smithy_pickaxe_pasive:IsStunDebuff()
    return false
end

function modifier_item_smithy_pickaxe_pasive:RemoveOnDeath()
    return false
end

function modifier_item_smithy_pickaxe_pasive:DestroyOnExpire()
    return true
end

function modifier_item_smithy_pickaxe_pasive:OnCreated()
    self.abi = self:GetAbility()
    self:SetDuration(300, true)
    self:StartIntervalThink(0.1)
end

function modifier_item_smithy_pickaxe_pasive:OnIntervalThink()
    self.abi.ChannelTime = self:GetRemainingTime()
end

function modifier_item_smithy_pickaxe_pasive:OnDestroy()
    UTIL_Remove(self:GetAbility())
end

modifier_item_smithy_pickaxe = class({})
--Classifications template
function modifier_item_smithy_pickaxe:IsHidden()
    return false
end

function modifier_item_smithy_pickaxe:IsDebuff()
    return false
end

function modifier_item_smithy_pickaxe:IsPurgable()
    return false
end

function modifier_item_smithy_pickaxe:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_smithy_pickaxe:IsStunDebuff()
    return false
end

function modifier_item_smithy_pickaxe:RemoveOnDeath()
    return true
end

function modifier_item_smithy_pickaxe:DestroyOnExpire()
    return true
end

function modifier_item_smithy_pickaxe:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(5)
end

function modifier_item_smithy_pickaxe:OnIntervalThink()
    spawnPoint = self.parent:GetAbsOrigin()	
    local newItem = CreateItem( "item_gems_" .. tostring(RandomInt(1,5)), self.parent:GetPlayerOwner(), nil )
    local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
    local dropRadius = RandomFloat( 50, 300 )
    newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
    
    local newItem = CreateItem( "item_gems_" .. tostring(RandomInt(1,5)), self.parent:GetPlayerOwner(), nil )
    local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
    local dropRadius = RandomFloat( 50, 300 )
    newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
end