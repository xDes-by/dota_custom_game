item_int = class({})

function item_int:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.int = self:GetSpecialValueFor( "int" )
		self.caster:SetBaseIntellect(self.caster:GetBaseIntellect() + self.int)
	end
end