modifier_hero_pre_duel_mini_safety = class({})

function modifier_hero_pre_duel_mini_safety:IsHidden() return true end
function modifier_hero_pre_duel_mini_safety:IsDebuff() return true end
function modifier_hero_pre_duel_mini_safety:IsPurgable() return false end
function modifier_hero_pre_duel_mini_safety:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_hero_pre_duel_mini_safety:CheckState()
	if IsServer() then return {	[MODIFIER_STATE_COMMAND_RESTRICTED] = true } end
end
