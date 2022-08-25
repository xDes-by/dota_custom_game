modifier_don2 = class({})

function modifier_don2:IsHidden()
	return true
end

function modifier_don2:IsPurgable()
	return false
end

function modifier_don2:RemoveOnDeath()
	return false
end

function modifier_don2:OnCreated( kv )
end

function modifier_don2:OnRefresh( kv )
end
