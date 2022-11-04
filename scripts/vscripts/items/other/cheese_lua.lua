item_cheese_lua = class({})

function item_cheese_lua:Spawn()
	self.all = self:GetSpecialValueFor( "all" ) * _G.rsh
end

function item_cheese_lua:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.caster:SetBaseStrength(self.caster:GetBaseStrength() + self.all)
		self.caster:SetBaseAgility(self.caster:GetBaseAgility() + self.all)
		self.caster:SetBaseIntellect(self.caster:GetBaseIntellect() + self.all)
		self.caster:RemoveItem(self)
	end
end