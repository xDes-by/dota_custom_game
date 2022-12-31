modifier_creature_pre_round_frozen = class({})

function modifier_creature_pre_round_frozen:IsHidden() return true end
function modifier_creature_pre_round_frozen:IsDebuff() return true end
function modifier_creature_pre_round_frozen:IsPurgable() return false end
function modifier_creature_pre_round_frozen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_creature_pre_round_frozen:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	}
	return state
end
