LinkLuaModifier("modifier_greed_book_str", "items/greed_book_str.lua", LUA_MODIFIER_MOTION_NONE )

item_greed_str = class({})

function item_greed_str:GetIntrinsicModifierName()
    return "modifier_greed_book_str"
end

function item_greed_str:OnSpellStart()
	local str = self:GetSpecialValueFor("bonus_stat")
    self.caster = self:GetCaster()
	self.caster:ModifyStrength(str)
    self:SpendCharge()
	if self:GetCurrentCharges() <= 0 then
	     self.caster:RemoveItem(self)
    end
    self.caster:EmitSound("Item.TomeOfKnowledge")
end

------------------------------------------------------------------------------------

modifier_greed_book_str = class({})

function modifier_greed_book_str:IsHidden()
    return false
end

function modifier_greed_book_str:IsDebuff()
    return false
end

function modifier_greed_book_str:IsPurgable()
    return false
end

function modifier_greed_book_str:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_greed_book_str:OnIntervalThink()
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