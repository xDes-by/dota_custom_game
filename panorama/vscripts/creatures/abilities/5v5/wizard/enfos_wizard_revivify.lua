enfos_wizard_revivify = class({})

function enfos_wizard_revivify:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:EmitSound("Wizard.Revivify")

	target:Heal(target:GetMaxHealth(), nil)
	target:GiveMana(target:GetMaxMana())

	local heal_pfx = ParticleManager:CreateParticle('particles/5v5/enfos_wizard_revivify.vpcf', PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(heal_pfx, 1, Vector(450, 0, 0))
	ParticleManager:ReleaseParticleIndex(heal_pfx)

	EnfosWizard:CastSpellResult(caster, "revivify")
end
