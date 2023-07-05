LinkLuaModifier("modifier_weird_potion", "items/weird_potion.lua", LUA_MODIFIER_MOTION_NONE )

item_weird_potion = class({})

function item_weird_potion:GetIntrinsicModifierName()
    return "modifier_weird_potion"
end

function item_weird_potion:OnSpellStart()
	local stat = self:GetSpecialValueFor("bonus_stat") * self:GetCurrentCharges()
    self.caster = self:GetCaster()
	self.caster:ModifyAgility(stat)
    self.caster:ModifyStrength(stat)
    self.caster:ModifyIntellect(stat)
	if self:GetCurrentCharges() <= 0 then
	    self.caster:RemoveItem(self)
        return
    end
    self:SetCurrentCharges(0)
    self.caster:EmitSound("Bottle.Drink")
end

--------------------------------------------------------------------------

modifier_weird_potion = class({})

function modifier_weird_potion:IsHidden()
    return false
end

function modifier_weird_potion:IsDebuff()
    return false
end

function modifier_weird_potion:IsPurgable()
    return false
end

function modifier_weird_potion:OnCreated()
    self:StartIntervalThink(0.45)
end

function modifier_weird_potion:OnIntervalThink()
if not IsServer() then return end
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local charges = self:GetAbility():GetCurrentCharges()
    local gold = caster:GetGold()
    local gold_bank = caster:FindModifierByName("modifier_gold_bank")
    gold = gold + gold_bank:GetStackCount()
    gold_bank:SetStackCount(0)
    if gold >= 72000 then
        count = ( gold - ( gold % 72000 ) ) / 72000 
        gold = gold % 72000
        caster:SetGold(0 , false) 
        caster:ModifyGoldFiltered( gold, true, 0 )
        ability:SetCurrentCharges(charges + count)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
    end
    self:StartIntervalThink(0.45)
end