item_midas_lua = class({})

LinkLuaModifier("modifier_item_midas_lua", 'items/custom_items/item_midas_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_midas_lua_shareable_gold", 'items/custom_items/item_midas_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_midas_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/item_midas" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_midas" .. level
	end
end

function item_midas_lua:GetIntrinsicModifierName()
    return "modifier_item_midas_lua"
end

function item_midas_lua:OnSpellStart()
    local target = self:GetCursorTarget()
    self.mod = target:AddNewModifier(self:GetCaster(), self, "modifier_item_midas_lua_shareable_gold", {})
end

modifier_item_midas_lua = class({})

--Classifications template
function modifier_item_midas_lua:IsHidden()
    return true
end

function modifier_item_midas_lua:IsDebuff()
    return false
end

function modifier_item_midas_lua:IsPurgable()
    return false
end

function modifier_item_midas_lua:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_midas_lua:IsStunDebuff()
    return false
end

function modifier_item_midas_lua:RemoveOnDeath()
    return false
end

function modifier_item_midas_lua:DestroyOnExpire()
    return false
end

function modifier_item_midas_lua:OnCreated()
    self.parent = self:GetParent()
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_item_midas_lua:OnRefresh()
    self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_item_midas_lua:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetAbility().mod:Destroy()
end

function modifier_item_midas_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_midas_lua:GetModifierAttackSpeedBonus_Constant()
    return self.attack_speed
end

modifier_item_midas_lua_shareable_gold = class({})
--Classifications template
function modifier_item_midas_lua_shareable_gold:IsHidden()
    return false
end

function modifier_item_midas_lua_shareable_gold:IsDebuff()
    return false
end

function modifier_item_midas_lua_shareable_gold:IsPurgable()
    return false
end

function modifier_item_midas_lua_shareable_gold:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_midas_lua_shareable_gold:IsStunDebuff()
    return false
end

function modifier_item_midas_lua_shareable_gold:RemoveOnDeath()
    return false
end

function modifier_item_midas_lua_shareable_gold:DestroyOnExpire()
    return false
end

function modifier_item_midas_lua_shareable_gold:OnCreated()
    self.parent = self:GetParent()
    self.shareable_gold = self:GetAbility():GetSpecialValueFor("shareble_gold") * 0.01
    self.caster = self:GetCaster()
    if not IsServer() then
        return
    end
    ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'SharebleGold'), self)
end

function modifier_item_midas_lua_shareable_gold:SharebleGold(data)
    if not self:GetAbility() then
        self:Destroy()
        return
    end
    local killedUnit = EntIndexToHScript( data.entindex_killed )
	local killerEntity = EntIndexToHScript( data.entindex_attacker )
    if killerEntity == self.parent then
        local bounty = killedUnit:GetGoldBounty()
        if bounty then
            gold = bounty * self.shareable_gold
            killerEntity:ModifyGoldFiltered(gold, true, DOTA_ModifyGold_SharedGold)
        end
    end
end