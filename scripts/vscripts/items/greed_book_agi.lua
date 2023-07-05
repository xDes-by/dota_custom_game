LinkLuaModifier("modifier_greed_book_agi", "items/greed_book_agi.lua", LUA_MODIFIER_MOTION_NONE )

item_greed_agi = class({})

function item_greed_agi:GetIntrinsicModifierName()
    return "modifier_greed_book_agi"
end

function item_greed_agi:OnSpellStart()
	local agi = self:GetSpecialValueFor("bonus_stat") * self:GetCurrentCharges()
    self.caster = self:GetCaster()
	self.caster:ModifyAgility(agi)
	if self:GetCurrentCharges() <= 0 then
	    self.caster:RemoveItem(self)
        return
    end
    self:SetCurrentCharges(0)
    self.caster:EmitSound("Item.TomeOfKnowledge")
end

--------------------------------------------------------------------------

modifier_greed_book_agi = class({})

function modifier_greed_book_agi:IsHidden()
    return false
end

function modifier_greed_book_agi:IsDebuff()
    return false
end

function modifier_greed_book_agi:IsPurgable()
    return false
end

function modifier_greed_book_agi:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_greed_book_agi:OnIntervalThink()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local charges = self:GetAbility():GetCurrentCharges()
    local gold = caster:GetGold()
    local gold_bank = caster:FindModifierByName("modifier_gold_bank")
    gold = gold + gold_bank:GetStackCount()
    gold_bank:SetStackCount(0)
    if gold >= 20000 then
        count = ( gold - ( gold % 20000 ) ) / 20000 
        gold = gold % 20000
        caster:SetGold(0 , false) 
        caster:ModifyGoldFiltered( gold, true, 0 )
        ability:SetCurrentCharges(charges + count)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
    end
end