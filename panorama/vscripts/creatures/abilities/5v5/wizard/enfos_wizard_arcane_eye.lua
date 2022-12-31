enfos_wizard_arcane_eye = class({})

LinkLuaModifier("modifier_arcane_eye_thinker", "creatures/abilities/5v5/wizard/enfos_wizard_arcane_eye", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcane_eye_truesight", "creatures/abilities/5v5/wizard/enfos_wizard_arcane_eye", LUA_MODIFIER_MOTION_NONE)



function enfos_wizard_arcane_eye:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	EmitSoundOnLocationWithCaster(target_loc, "Wizard.ArcaneEye", caster)

	CreateModifierThinker(caster, self, "modifier_arcane_eye_thinker", {radius = radius, duration = duration}, target_loc, caster:GetTeam(), false)

	self:CreateVisibilityNode(target_loc, radius, duration)

	EnfosWizard:CastSpellResult(caster, "arcane_eye")
end

function enfos_wizard_arcane_eye:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



modifier_arcane_eye_thinker = class({})

function modifier_arcane_eye_thinker:IsAura() return true end
function modifier_arcane_eye_thinker:GetAuraRadius() return self.radius end
function modifier_arcane_eye_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_arcane_eye_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_arcane_eye_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_arcane_eye_thinker:GetModifierAura() return "modifier_arcane_eye_truesight" end

function modifier_arcane_eye_thinker:OnCreated(keys)
	if IsClient() then return end

	self.radius = keys.radius

	self.truesight_pfx = ParticleManager:CreateParticle('particles/5v5/truesight_aura_wizard.vpcf', PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(self.truesight_pfx, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl(self.truesight_pfx, 1, Vector(keys.radius, keys.radius, keys.radius))
end 

function modifier_arcane_eye_thinker:OnDestroy()
	if not self.truesight_pfx then return end 

	ParticleManager:DestroyParticle(self.truesight_pfx, false)
	ParticleManager:ReleaseParticleIndex(self.truesight_pfx)
end



modifier_arcane_eye_truesight = class({})

function modifier_arcane_eye_truesight:IsHidden() return true end
function modifier_arcane_eye_truesight:IsDebuff() return true end
function modifier_arcane_eye_truesight:IsPurgable() return false end
function modifier_arcane_eye_truesight:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_arcane_eye_truesight:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = false
	}
end 

function modifier_arcane_eye_truesight:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_arcane_eye_truesight:GetModifierInvisibilityLevel()
	return 0
end
