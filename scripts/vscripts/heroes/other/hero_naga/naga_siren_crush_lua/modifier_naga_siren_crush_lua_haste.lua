modifier_naga_siren_crush_lua_haste = class({})

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_haste:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_haste:OnCreated( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("crush_extra_slow")
	self.as_slow = self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")
end

function modifier_naga_siren_crush_lua_haste:OnRefresh( kv )
	self.ms_slow = self:GetAbility():GetSpecialValueFor("crush_extra_slow")
	self.as_slow = self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")
end

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_haste:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_naga_siren_crush_lua_haste:GetModifierMoveSpeedBonus_Constant( params )
	return self.ms_slow 
end


function modifier_naga_siren_crush_lua_haste:GetModifierAttackSpeedBonus_Constant( params )
	return self.as_slow 
end

--------------------------------------------------------------------------------
