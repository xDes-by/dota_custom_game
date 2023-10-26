modifier_vengeful_tempest_double_str30 = class({})

function modifier_vengeful_tempest_double_str30:IsHidden()
	return true
end

function modifier_vengeful_tempest_double_str30:IsPurgable()
	return false
end

function modifier_vengeful_tempest_double_str30:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vengeful_tempest_double_str30:OnCreated( kv )
	self.max = self:GetParent():GetMaxHealth() * 5
end

function modifier_vengeful_tempest_double_str30:DeclareFunctions()
	return { 
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
	}
end

function modifier_vengeful_tempest_double_str30:GetModifierIncomingDamageConstant( event )
    if IsClient() then
        if event.report_max then
            return self.max
        else
            return self:GetStackCount()
        end
    end
	local stackCount = self:GetStackCount()
    if self:GetParent():IsRealHero() then
        if stackCount >= event.damage then
            self:SetStackCount(stackCount - event.damage)
			return -event.damage
		elseif stackCount > 0 then
			self:SetStackCount(0)
			return -stackCount
		end
    end
end