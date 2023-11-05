LinkLuaModifier("modifier_item_book_atributes", "items/item_book_atributes", LUA_MODIFIER_MOTION_NONE )

item_book_atributes = class({})

function item_book_atributes:OnSpellStart()
    print("OnSpellStart")
    -- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_book_atributes", {})
    -- self:GetCaster():RemoveItem(self)
end

modifier_item_book_atributes = class({})

function modifier_item_book_atributes:IsDebuff()
    return false
end

function modifier_item_book_atributes:IsPurgable()
    return false
end

function modifier_item_book_atributes:RemoveOnDeath()
    return false
end

function modifier_item_book_atributes:OnCreated( kv )
    if not IsServer() return end
    self:StartIntervalThink(60)
    self:OnIntervalThink()
end

function modifier_item_book_atributes:OnIntervalThink()
    self:IncrementStackCount()
    local cooldown = 60
    local cooldownReduction = self:GetCaster():GetCooldownReduction()
    self:StartIntervalThink(cooldown * cooldownReduction)
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