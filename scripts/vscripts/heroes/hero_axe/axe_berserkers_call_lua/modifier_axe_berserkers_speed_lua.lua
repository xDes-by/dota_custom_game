modifier_axe_berserkers_speed_lua = class({})

--------------------------------------------------------------------------------
function modifier_axe_berserkers_speed_lua:IsHidden()
	return false
end

function modifier_axe_berserkers_speed_lua:IsDebuff()
	return false
end

function modifier_axe_berserkers_speed_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
function modifier_axe_berserkers_speed_lua:OnCreated( kv )
end

function modifier_axe_berserkers_speed_lua:OnRefresh( kv )
end

function modifier_axe_berserkers_speed_lua:OnRemoved()
end

function modifier_axe_berserkers_speed_lua:OnDestroy()
end

--------------------------------------------------------------------------------
function modifier_axe_berserkers_speed_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_axe_berserkers_speed_lua:GetModifierAttackSpeedBonus_Constant()
	return 250
end