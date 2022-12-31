modifier_aegis_buff_invul = class({})

function modifier_aegis_buff_invul:IsHidden() return false end
function modifier_aegis_buff_invul:IsDebuff() return false end
function modifier_aegis_buff_invul:IsPurgable() return false end
function modifier_aegis_buff_invul:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_aegis_buff_invul:GetTexture()
	return "omniknight_repel"
end

function modifier_aegis_buff_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end

function modifier_aegis_buff_invul:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
	return funcs
end

function modifier_aegis_buff_invul:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_aegis_buff_invul:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_aegis_buff_invul:GetAbsoluteNoDamagePure()
	return 1
end
