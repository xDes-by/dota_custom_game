modifier_don6 = class({})

function modifier_don6:IsHidden()
	return true
end

function modifier_don6:IsPurgable()
	return false
end

function modifier_don6:RemoveOnDeath()
	return false
end

function modifier_don6:OnCreated( kv )
	if not IsServer() then return end
	if self:GetCaster():GetPrimaryAttribute() < 3 then
		self:GetCaster():SetPrimaryAttribute(0)
	end
end