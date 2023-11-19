LinkLuaModifier("modifier_item_book_atributes", "items/other/item_book_atributes", LUA_MODIFIER_MOTION_NONE )

item_book_atributes = class({})

function item_book_atributes:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_item_book_atributes", {duration = 60 * self:GetCaster():GetCooldownReduction()})
    self:GetCaster():RemoveItem(self)
end

modifier_item_book_atributes = class({})

function modifier_item_book_atributes:GetTexture()
    return "arm"
end
function modifier_item_book_atributes:IsHidden()
    return false
end

function modifier_item_book_atributes:IsDebuff()
    return false
end

function modifier_item_book_atributes:IsPurgable()
    return false
end

function modifier_item_book_atributes:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_book_atributes:IsStunDebuff()
    return false
end

function modifier_item_book_atributes:RemoveOnDeath()
    return false
end

function modifier_item_book_atributes:DestroyOnExpire()
    return false
end

function modifier_item_book_atributes:OnCreated( kv )
    if not IsServer() then
        return
    end
    self:SetStackCount(1)
    self:StartIntervalThink(60 * self:GetCaster():GetCooldownReduction())
end

function modifier_item_book_atributes:OnIntervalThink()
    local time = 60 * self:GetCaster():GetCooldownReduction()
    self:SetDuration(time, true)
    self:IncrementStackCount()
    self:StartIntervalThink(time)
end

function modifier_item_book_atributes:DeclareFunctions()
     local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS ,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
     }
     return funcs
end

function modifier_item_book_atributes:GetModifierBonusStats_Agility()
    return self:GetStackCount() * 5
end
function modifier_item_book_atributes:GetModifierBonusStats_Intellect()
    return self:GetStackCount() * 5
end
function modifier_item_book_atributes:GetModifierBonusStats_Strength()
    return self:GetStackCount() * 5
end