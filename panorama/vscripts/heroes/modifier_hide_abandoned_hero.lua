modifier_hide_abandoned_hero = class({})

function modifier_hide_abandoned_hero:IsHidden() return true end
function modifier_hide_abandoned_hero:IsDebuff() return true end
function modifier_hide_abandoned_hero:IsPurgable() return false end
function modifier_hide_abandoned_hero:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_hide_abandoned_hero:OnCreated(keys)
	if self:GetParent() then self:GetParent():AddNoDraw() end
end

function modifier_hide_abandoned_hero:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_PASSIVES_DISABLED] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_UNTARGETABLE] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true
		}
		return state
	end
end
