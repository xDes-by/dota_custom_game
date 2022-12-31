enfos_wizard_upgrade_wizard = class({})
enfos_wizard_upgrade_wizard_2 = class({})

LinkLuaModifier("modifier_upgrade_wizard", "creatures/abilities/5v5/wizard/enfos_wizard_upgrade_wizard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_wizard_2", "creatures/abilities/5v5/wizard/enfos_wizard_upgrade_wizard", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_upgrade_wizard:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local wizard = EnfosWizard.wizards[team]

	EmitAnnouncerSoundForTeam("wizard_upgrade", team)

	local upgrade_pfx = ParticleManager:CreateParticle("particles/5v5/upgrade_wizard.vpcf", PATTACH_ABSORIGIN_FOLLOW, wizard)
	ParticleManager:ReleaseParticleIndex(upgrade_pfx)

	if EnfosWizard:GetWizardLevel(team) < 1 then EnfosWizard:UpgradeWizard(team) end

	wizard:AddNewModifier(wizard, self, "modifier_upgrade_wizard", {})

	EnfosWizard:CastSpellResult(caster, "upgrade_wizard")
end



function enfos_wizard_upgrade_wizard_2:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local wizard = EnfosWizard.wizards[team]

	EmitAnnouncerSoundForTeam("wizard_upgrade", team)

	local upgrade_pfx = ParticleManager:CreateParticle("particles/5v5/upgrade_wizard.vpcf", PATTACH_ABSORIGIN_FOLLOW, wizard)
	ParticleManager:ReleaseParticleIndex(upgrade_pfx)

	if EnfosWizard:GetWizardLevel(team) < 2 then EnfosWizard:UpgradeWizard(team) end

	wizard:AddNewModifier(wizard, self, "modifier_upgrade_wizard_2", {})

	EnfosWizard:CastSpellResult(caster, "upgrade_wizard_2")
end



modifier_upgrade_wizard = class({})

function modifier_upgrade_wizard:IsHidden() return true end
function modifier_upgrade_wizard:IsDebuff() return false end
function modifier_upgrade_wizard:IsPurgable() return false end
function modifier_upgrade_wizard:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_upgrade_wizard:GetEffectName()
	return "particles/5v5/wizard_upgrade_1.vpcf"
end

function modifier_upgrade_wizard:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_upgrade_wizard:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
end 

function modifier_upgrade_wizard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS
	}
end 

function modifier_upgrade_wizard:GetModifierExtraManaBonus()
	return self.bonus_mana
end



modifier_upgrade_wizard_2 = class({})

function modifier_upgrade_wizard_2:IsHidden() return true end
function modifier_upgrade_wizard_2:IsDebuff() return false end
function modifier_upgrade_wizard_2:IsPurgable() return false end
function modifier_upgrade_wizard_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_upgrade_wizard_2:GetEffectName()
	return "particles/5v5/wizard_upgrade_2.vpcf"
end

function modifier_upgrade_wizard_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_upgrade_wizard_2:OnCreated()
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
end 

function modifier_upgrade_wizard_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS
	}
end 

function modifier_upgrade_wizard_2:GetModifierExtraManaBonus()
	return self.bonus_mana
end
