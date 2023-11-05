LinkLuaModifier( "modifier_item_gold_brus", "items/other/gold_brick", LUA_MODIFIER_MOTION_NONE )

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

modifier_item_gold_brus = class({})

function modifier_item_gold_brus:IsHidden()
	return true
end

function modifier_item_gold_brus:IsPurgable()
	return false
end

function modifier_item_gold_brus:RemoveOnDeath()
	return false
end

function modifier_item_gold_brus:OnRefresh()
	if IsServer() then
		print(self:GetAbility():GetCurrentCharges())
	end
end