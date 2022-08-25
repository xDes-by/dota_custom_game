modifier_silent = class({})

function modifier_silent:IsHidden()
    return true
end

function modifier_silent:IsPurgable()
    return false
end

function modifier_silent:OnCreated( kv )
	if not IsServer() then return end
	self:GetCaster():SpendMana(11,nil)
end

function modifier_silent:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return state
end

function modifier_silent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_silent:GetModifierModelChange(params)
 return "models/props_gameplay/pig.vmdl"
end

function modifier_silent:GetModifierMoveSpeed_Absolute()
	return 250
end

function modifier_silent:GetModifierIncomingDamage_Percentage()
	return 300
end