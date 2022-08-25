modifier_agi_boost = class({})

--------------------------------------------------------------------------------

function modifier_agi_boost:IsHidden()
	return true
end

function modifier_agi_boost:IsPurgable()
	return false
end

function modifier_agi_boost:OnCreated( kv )
bonus = self:GetCaster():GetStrength()*0.2
end

function modifier_agi_boost:OnRefresh( kv )
end

function modifier_agi_boost:OnDestroy( kv )
end

function modifier_agi_boost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function modifier_agi_boost:GetModifierBonusStats_Agility( params )
return bonus
end
