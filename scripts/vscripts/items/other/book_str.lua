item_str = class({})

function item_str:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.str = self:GetSpecialValueFor( "str" )
		self.caster:SetBaseStrength(self.caster:GetBaseStrength() + self.str)
	end
end