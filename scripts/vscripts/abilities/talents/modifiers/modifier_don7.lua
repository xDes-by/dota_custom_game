modifier_don7 = class({})

function modifier_don7:IsHidden()
	return true
end

function modifier_don7:IsPurgable()
	return false
end

function modifier_don7:RemoveOnDeath()
	return false
end

function modifier_don7:OnCreated( kv )
	if not IsServer() then return end
self:GetCaster():SetPrimaryAttribute(1)
end