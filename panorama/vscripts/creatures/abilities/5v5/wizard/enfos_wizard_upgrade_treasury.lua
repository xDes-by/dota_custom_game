enfos_wizard_upgrade_treasury = class({})
enfos_wizard_upgrade_treasury_2 = class({})

LinkLuaModifier("modifier_upgrade_treasury", "creatures/abilities/5v5/wizard/enfos_wizard_upgrade_treasury", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_treasury_2", "creatures/abilities/5v5/wizard/enfos_wizard_upgrade_treasury", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_upgrade_treasury:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local treasury = EnfosTreasury.treasuries[team].chest

	EmitAnnouncerSoundForTeam("wizard_upgrade", team)

	if EnfosTreasury:GetTreasuryLevel(team) < 1 then EnfosTreasury:UpgradeTreasury(team) end

	for _, treasury in pairs(EnfosTreasury.treasuries[team]) do
		local upgrade_pfx = ParticleManager:CreateParticle("particles/5v5/upgrade_wizard.vpcf", PATTACH_ABSORIGIN_FOLLOW, treasury.chest)
		ParticleManager:ReleaseParticleIndex(upgrade_pfx)

		treasury.chest:AddNewModifier(treasury.chest, self, "modifier_upgrade_treasury", {})
	end

	EnfosWizard:CastSpellResult(caster, "upgrade_treasury")
end



function enfos_wizard_upgrade_treasury_2:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()

	EmitAnnouncerSoundForTeam("wizard_upgrade", team)

	if EnfosTreasury:GetTreasuryLevel(team) < 2 then EnfosTreasury:UpgradeTreasury(team) end

	for _, treasury in pairs(EnfosTreasury.treasuries[team]) do
		local upgrade_pfx = ParticleManager:CreateParticle("particles/5v5/upgrade_wizard.vpcf", PATTACH_ABSORIGIN_FOLLOW, treasury.chest)
		ParticleManager:ReleaseParticleIndex(upgrade_pfx)

		treasury.chest:AddNewModifier(treasury.chest, self, "modifier_upgrade_treasury_2", {})
	end

	EnfosWizard:CastSpellResult(caster, "upgrade_treasury_2")
end



modifier_upgrade_treasury = class({})

function modifier_upgrade_treasury:IsHidden() return true end
function modifier_upgrade_treasury:IsDebuff() return false end
function modifier_upgrade_treasury:IsPurgable() return false end
function modifier_upgrade_treasury:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_upgrade_treasury:GetEffectName()
	return "particles/5v5/treasury_upgrade_1.vpcf"
end

function modifier_upgrade_treasury:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_upgrade_treasury_2 = class({})

function modifier_upgrade_treasury_2:IsHidden() return true end
function modifier_upgrade_treasury_2:IsDebuff() return false end
function modifier_upgrade_treasury_2:IsPurgable() return false end
function modifier_upgrade_treasury_2:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_upgrade_treasury_2:GetEffectName()
	return "particles/5v5/treasury_upgrade_2.vpcf"
end

function modifier_upgrade_treasury_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
