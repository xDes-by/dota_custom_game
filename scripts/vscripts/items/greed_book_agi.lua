LinkLuaModifier("modifier_greed_book_agi", "items/greed_book_agi.lua", LUA_MODIFIER_MOTION_NONE )

item_greed_agi = class({})

function item_greed_agi:GetIntrinsicModifierName()
    return "modifier_greed_book_agi"
end

function item_greed_agi:OnSpellStart()
	local agi = self:GetSpecialValueFor("bonus_stat")
    self.caster = self:GetCaster()
	self.caster:ModifyAgility(agi)
    self:SpendCharge()
	if self:GetCurrentCharges() <= 0 then
	     self.caster:RemoveItem(self)
    end
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
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local charges = self:GetAbility():GetCurrentCharges()
    local gold = caster:GetGold()
    if  gold >= 20000 and gold < 40000 then
        parent:ModifyGoldFiltered(-20000, true, 0)
        ability:SetCurrentCharges(charges + 1)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
        elseif  gold >= 40000 and gold < 60000  then
        parent:ModifyGoldFiltered(-40000, true, 0)
        ability:SetCurrentCharges(charges + 2)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
        elseif gold >= 60000 and gold < 80000 then 
        parent:ModifyGoldFiltered(-60000, true, 0)
        ability:SetCurrentCharges(charges + 3)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
        elseif gold >= 80000 then
        parent:ModifyGoldFiltered(-80000, true, 0)
        ability:SetCurrentCharges(charges + 4)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
    end
end