if modifier_normal == nil then
	modifier_normal = class({})
end

function modifier_normal:IsHidden()
	return false
end

function modifier_normal:IsPurgable()
	return false
end

function modifier_normal:RemoveOnDeath()
	return false
end

function modifier_normal:OnCreated()	    
end

function modifier_normal:GetTexture()
    return "normal"
end