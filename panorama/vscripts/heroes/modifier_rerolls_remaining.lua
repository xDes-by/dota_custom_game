modifier_rerolls_remaining = class({})

function modifier_rerolls_remaining:IsHidden()
	if IsClient() then
	    return self:GetParent():GetPlayerOwnerID() ~= GetLocalPlayerID()
	else
		return false
	end
end

function modifier_rerolls_remaining:GetTexture()
	return "rerolls_remaining"
end

function modifier_rerolls_remaining:IsPermanent()
	return true
end

function modifier_rerolls_remaining:IsPurgable()
	return false
end

function modifier_rerolls_remaining:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_rerolls_remaining:OnTooltip()
	return self:GetStackCount()
end
