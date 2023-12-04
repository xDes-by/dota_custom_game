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
		self.parent:ModifyGoldFiltered((self.parent:GetTotalGold()) * 0.01, true, 0)
	end
end