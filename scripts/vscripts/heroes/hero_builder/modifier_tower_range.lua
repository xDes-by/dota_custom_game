modifier_tower_range = class({})

--------------------------------------------------------------------------------
function modifier_tower_range:IsHidden()
	return true
end

function modifier_tower_range:IsPurgable()
	return false
end

function modifier_tower_range:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_tower_range:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end


function modifier_tower_range:GetModifierAttackRangeBonus()
	return 350
end