modifier_don4 = class({})

function modifier_don4:IsHidden()
	return true
end

function modifier_don4:IsPurgable()
	return false
end

function modifier_don4:RemoveOnDeath()
	return false
end

function modifier_don4:OnCreated( kv )
    self.parent = self:GetParent()
	self:StartIntervalThink(60)
end

function modifier_don4:OnIntervalThink()
	if IsServer() then
        local g1 = self.parent:GetGold()
        local g2 = self.parent:FindModifierByName("modifier_gold_bank"):GetStackCount()
		self.parent:ModifyGoldFiltered((g1 + g2) * 0.1, true, 0)
	end
end