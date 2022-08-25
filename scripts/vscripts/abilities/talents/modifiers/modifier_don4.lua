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
self:StartIntervalThink(60)
end

function modifier_don4:OnIntervalThink()
	if IsServer() then
	self:GetCaster():ModifyGold( self:GetCaster():GetGold()*0.1, true, 0 )
	end
end