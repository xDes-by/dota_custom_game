item_agi = class({})

function item_agi:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.agi = self:GetSpecialValueFor( "agi" )
		self.caster:SetBaseAgility(self.caster:GetBaseAgility() + self.agi)
	end
end