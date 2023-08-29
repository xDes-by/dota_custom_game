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
	if self:GetCaster():GetPrimaryAttribute() < 3 then
		self:GetCaster():SetPrimaryAttribute(1)
	end
end