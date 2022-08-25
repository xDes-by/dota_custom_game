modifier_wraith_king_reincarnation_lua_buff = class({})

function modifier_wraith_king_reincarnation_lua_buff:IsHidden()
	return false
end

function modifier_wraith_king_reincarnation_lua_buff:IsDebuff()
	return false
end

function modifier_wraith_king_reincarnation_lua_buff:IsPurgable()
	return false
end

function modifier_wraith_king_reincarnation_lua_buff:OnCreated( kv )
end

function modifier_wraith_king_reincarnation_lua_buff:OnRefresh( kv )
end

function modifier_wraith_king_reincarnation_lua_buff:OnDestroy( kv )
end

function modifier_wraith_king_reincarnation_lua_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
	}

	return funcs
end

function modifier_wraith_king_reincarnation_lua_buff:GetModifierDamageOutgoing_Percentage()
	return 300
end