item_gold_brus = class({})

function item_gold_brus:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
			self.caster:EmitSound("DOTA_Item.Hand_Of_Midas")
			self.caster:ModifyGoldFiltered( 5000, true, 0 )
			self:SpendCharge()
			local new_charges = self:GetCurrentCharges()
			if new_charges <= 0 then
			self.caster:RemoveItem(self)
		end
	end
end