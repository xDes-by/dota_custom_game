modifier_enfos_wizard_mana_regen = class({})

function modifier_enfos_wizard_mana_regen:IsHidden() return true end
function modifier_enfos_wizard_mana_regen:IsDebuff() return false end
function modifier_enfos_wizard_mana_regen:IsPurgable() return false end
function modifier_enfos_wizard_mana_regen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_wizard_mana_regen:OnCreated(keys)
	if IsServer() then
		self.current_mana = self:GetParent():GetMana()
		self:StartIntervalThink(0.03)
	end
end

function modifier_enfos_wizard_mana_regen:OnIntervalThink()
	local parent = self:GetParent()
	local base_regen = ENFOS_WIZARD_BASE_MANA_REGEN[EnfosWizard:GetWizardLevel(parent:GetTeam())]
	local winner_multiplier = (parent:HasModifier("modifier_enfos_wizard_winner_boost") and ENFOS_WIZARD_DUEL_VICTORY_BOOST) or 1
	local creep_penalty_multiplier = math.max(0, 1 - ENFOS_WIZARD_CREEP_MANA_REGEN_PENALTY * Enfos:GetCreepCount(parent:GetTeam()))

	self:SetStackCount(100 * base_regen * winner_multiplier * creep_penalty_multiplier)

	parent:SetMana(math.min(parent:GetMana(), self.current_mana + base_regen * winner_multiplier * creep_penalty_multiplier))
	if IsInToolsMode() then parent:SetMana(parent:GetMana() + 10) end
	self.current_mana = parent:GetMana()
end

function modifier_enfos_wizard_mana_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_enfos_wizard_mana_regen:GetModifierConstantManaRegen()
	return 0.01 * self:GetStackCount()
end
