modifier_naga_siren_crush_lua_slow = class({})

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_slow:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_slow:OnCreated( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("crush_extra_slow")
	self.as_slow = self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")
end

function modifier_naga_siren_crush_lua_slow:OnRefresh( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("crush_extra_slow")
	self.as_slow = self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")
end

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_slow:GetModifierMoveSpeedBonus_Constant( params )
	return self.ms_slow * (-1)
end


function modifier_naga_siren_crush_lua_slow:GetModifierAttackSpeedBonus_Constant( params )
	return self.as_slow * (-1)
end

--------------------------------------------------------------------------------
