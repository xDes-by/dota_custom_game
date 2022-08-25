status_resist = class({})
LinkLuaModifier( "modifier_status_resist", "abilities/status", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function status_resist:GetIntrinsicModifierName()
	return "modifier_status_resist"
end

-------------------------------------------------------------------------------

modifier_status_resist = class({})

--------------------------------------------------------------------------------

function modifier_status_resist:IsHidden()
	return false
end


function modifier_status_resist:IsPurgable()
    return false
end

function modifier_status_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}
	return funcs
end

function modifier_status_resist:GetModifierStatusResistance()
	return 50
end