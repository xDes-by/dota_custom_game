item_book_atributes = class({})

function item_book_atributes:OnSpellStart()
    self:GetCaster():ModifyAgility(5)
    self:GetCaster():ModifyStrength(5)
    self:GetCaster():ModifyIntellect(5)
end