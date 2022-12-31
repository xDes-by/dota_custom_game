modifier_multicast_grow = class({})

function modifier_multicast_grow:GetTexture()
	return "ogre_magi_multicast"
end

function modifier_multicast_grow:IsPurgable() 
	return false 
end

function modifier_multicast_grow:IsHidden()
	return false
end

function modifier_multicast_grow:IsPermanent()
	return true
end

function modifier_multicast_grow:RemoveOnDeath()
	return false
end

function modifier_multicast_grow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,					-- GetModifierModelScale
		MODIFIER_PROPERTY_TOOLTIP, 						--OnTooltip
	}
end

function modifier_multicast_grow:GetModifierModelScale()
	return 15 * self:GetStackCount()-1
end

function modifier_multicast_grow:OnTooltip()
	return self:GetStackCount()
end
