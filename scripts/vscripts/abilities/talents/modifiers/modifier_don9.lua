modifier_don9 = class({})

function modifier_don9:IsHidden()
	return true
end

function modifier_don9:IsPurgable()
	return false
end

function modifier_don9:RemoveOnDeath()
	return false
end

function modifier_don9:OnCreated( kv )
end


function modifier_don9:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

if IsServer() then
	function modifier_don9:GetModifierIncomingDamage_Percentage(keys)
		damage = (100 - self:GetParent():GetHealthPercent()) / 2 *(-1)
	return damage
	end
end