modifier_armor_boost = class({})

--------------------------------------------------------------------------------

function modifier_armor_boost:IsHidden()
	return false
end

function modifier_armor_boost:IsPurgable()
	return false
end

function modifier_armor_boost:OnCreated( kv )
end

function modifier_armor_boost:OnRefresh( kv )
end

function modifier_armor_boost:OnDestroy( kv )
end

function modifier_armor_boost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_armor_boost:GetModifierPhysicalArmorBonus( params )
return 100
end

function modifier_armor_boost:GetModifierMagicalResistanceBonus( params )
return 50
end