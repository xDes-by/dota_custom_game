modifier_enfos_wizard_winner_boost = class({})

function modifier_enfos_wizard_winner_boost:IsHidden() return false end
function modifier_enfos_wizard_winner_boost:IsDebuff() return false end
function modifier_enfos_wizard_winner_boost:IsPurgable() return false end
function modifier_enfos_wizard_winner_boost:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_wizard_winner_boost:GetTexture()
	return "crystal_maiden_brilliance_aura"
end
