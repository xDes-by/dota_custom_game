modifier_enfos_duel_creep_freeze = class({})

function modifier_enfos_duel_creep_freeze:IsHidden() return true end
function modifier_enfos_duel_creep_freeze:IsDebuff() return false end
function modifier_enfos_duel_creep_freeze:IsPurgable() return false end

function modifier_enfos_duel_creep_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end
