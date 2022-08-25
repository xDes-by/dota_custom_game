modifier_don8 = class({})

function modifier_don8:IsHidden()
	return true
end

function modifier_don8:IsPurgable()
	return false
end

function modifier_don8:RemoveOnDeath()
	return false
end

function modifier_don8:OnCreated( kv )
	if not IsServer() then return end
self:GetCaster():SetPrimaryAttribute(2)
end