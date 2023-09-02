item_midas_lua = class({})

item_midas_lua1 = item_midas_lua
item_midas_lua2 = item_midas_lua
item_midas_lua3 = item_midas_lua
item_midas_lua4 = item_midas_lua
item_midas_lua5 = item_midas_lua
item_midas_lua6 = item_midas_lua
item_midas_lua7 = item_midas_lua
item_midas_lua8 = item_midas_lua

item_midas_lua1_gem1 = item_midas_lua
item_midas_lua2_gem1 = item_midas_lua
item_midas_lua3_gem1 = item_midas_lua
item_midas_lua4_gem1 = item_midas_lua
item_midas_lua5_gem1 = item_midas_lua
item_midas_lua6_gem1 = item_midas_lua
item_midas_lua7_gem1 = item_midas_lua
item_midas_lua8_gem1 = item_midas_lua

item_midas_lua1_gem2 = item_midas_lua
item_midas_lua2_gem2 = item_midas_lua
item_midas_lua3_gem2 = item_midas_lua
item_midas_lua4_gem2 = item_midas_lua
item_midas_lua5_gem2 = item_midas_lua
item_midas_lua6_gem2 = item_midas_lua
item_midas_lua7_gem2 = item_midas_lua
item_midas_lua8_gem2 = item_midas_lua

item_midas_lua1_gem3 = item_midas_lua
item_midas_lua2_gem3 = item_midas_lua
item_midas_lua3_gem3 = item_midas_lua
item_midas_lua4_gem3 = item_midas_lua
item_midas_lua5_gem3 = item_midas_lua
item_midas_lua6_gem3 = item_midas_lua
item_midas_lua7_gem3 = item_midas_lua
item_midas_lua8_gem3 = item_midas_lua

item_midas_lua1_gem4 = item_midas_lua
item_midas_lua2_gem4 = item_midas_lua
item_midas_lua3_gem4 = item_midas_lua
item_midas_lua4_gem4 = item_midas_lua
item_midas_lua5_gem4 = item_midas_lua
item_midas_lua6_gem4 = item_midas_lua
item_midas_lua7_gem4 = item_midas_lua
item_midas_lua8_gem4 = item_midas_lua

item_midas_lua1_gem5 = item_midas_lua
item_midas_lua2_gem5 = item_midas_lua
item_midas_lua3_gem5 = item_midas_lua
item_midas_lua4_gem5 = item_midas_lua
item_midas_lua5_gem5 = item_midas_lua
item_midas_lua6_gem5 = item_midas_lua
item_midas_lua7_gem5 = item_midas_lua
item_midas_lua8_gem5 = item_midas_lua

LinkLuaModifier("modifier_item_midas_lua", 'items/custom_items/item_midas_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_midas_lua_shareable_gold", 'items/custom_items/item_midas_lua.lua', LUA_MODIFIER_MOTION_NONE)

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
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_midas_lua:OnRemoved()
    self:GetAbility().mod:Destroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
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
        local gold = killedUnit:GetGoldBounty() * self.shareable_gold
    end
end