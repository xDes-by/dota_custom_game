LinkLuaModifier("modifier_weird_potion", "items/weird_potion.lua", LUA_MODIFIER_MOTION_NONE )

item_weird_potion = class({})

function item_weird_potion:GetIntrinsicModifierName()
    return "modifier_weird_potion"
end

function item_weird_potion:OnSpellStart()
	local stat = self:GetSpecialValueFor("bonus_stat")
    self.caster = self:GetCaster()
	self.caster:ModifyAgility(stat)
    self.caster:ModifyStrength(stat)
    self.caster:ModifyIntellect(stat)
    self:SpendCharge()
	if self:GetCurrentCharges() <= 0 then
	     self.caster:RemoveItem(self)
    end
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
    if  gold >= 72000 then
        parent:ModifyGoldFiltered(-72000, true, 0)
        ability:SetCurrentCharges(charges + 1)
        caster:EmitSound("DOTA_Item.Hand_Of_Midas")
    end
end