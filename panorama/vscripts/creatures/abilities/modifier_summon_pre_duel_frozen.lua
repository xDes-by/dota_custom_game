modifier_summon_pre_duel_frozen = class({})

function modifier_summon_pre_duel_frozen:IsHidden() return true end
function modifier_summon_pre_duel_frozen:IsDebuff() return true end
function modifier_summon_pre_duel_frozen:IsPurgable() return false end
function modifier_summon_pre_duel_frozen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_summon_pre_duel_frozen:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true
		}
		return state
	end
end
