modifier_str_boost = class({})

--------------------------------------------------------------------------------

function modifier_str_boost:IsHidden()
	return true
end

function modifier_str_boost:IsPurgable()
	return false
end

function modifier_str_boost:OnCreated( kv )
bonus = self:GetCaster():GetStrength()*0.2
end

function modifier_str_boost:OnRefresh( kv )
end

function modifier_str_boost:OnDestroy( kv )
end

function modifier_str_boost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}

	return funcs
end

function modifier_str_boost:GetModifierBonusStats_Strength( params )
return bonus
end
