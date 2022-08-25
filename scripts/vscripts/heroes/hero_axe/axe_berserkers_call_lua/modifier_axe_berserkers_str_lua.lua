modifier_axe_berserkers_str_lua = class({})

--------------------------------------------------------------------------------
function modifier_axe_berserkers_str_lua:IsHidden()
	return false
end

function modifier_axe_berserkers_str_lua:IsDebuff()
	return false
end

function modifier_axe_berserkers_str_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
function modifier_axe_berserkers_str_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	damage_try =  self.caster:GetStrength()
end

function modifier_axe_berserkers_str_lua:OnRefresh( kv )
end

function modifier_axe_berserkers_str_lua:OnRemoved()
end

function modifier_axe_berserkers_str_lua:OnDestroy()
end

--------------------------------------------------------------------------------
function modifier_axe_berserkers_str_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_axe_berserkers_str_lua:GetModifierPreAttack_BonusDamage()
	return damage_try
end