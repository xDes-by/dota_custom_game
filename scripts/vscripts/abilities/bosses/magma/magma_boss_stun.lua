magma_boss_stun = class({})

function magma_boss_stun:OnSpellStart()
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 3})
end