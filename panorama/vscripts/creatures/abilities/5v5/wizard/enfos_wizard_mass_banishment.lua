enfos_wizard_mass_banishment = class({})

LinkLuaModifier("modifier_mass_banishment_prevention", "creatures/abilities/5v5/wizard/enfos_wizard_mass_banishment", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mass_banishment_freeze", "creatures/abilities/5v5/wizard/enfos_wizard_mass_banishment", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_mass_banishment:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local target_loc = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")

	EmitSoundOnLocationWithCaster(target_loc, "Wizard.MassBanishment.Cast", caster)

	local cast_pfx = ParticleManager:CreateParticle("particles/5v5/enfos_wizard_mass_banishment.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(cast_pfx, 60, Vector(64, 165, 232))
	ParticleManager:SetParticleControl(cast_pfx, 60, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	local unit_counter = 0

	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, target_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		if unit.spawner_team and unit.spawner_team == team and not (unit:HasModifier("modifier_mass_banishment_prevention") or unit:HasModifier("modifier_mass_banishment_freeze")) then
			unit:AddNewModifier(caster, nil, "modifier_mass_banishment_freeze", {team = team, duration = 1.6 + 0.1 * unit_counter})
			unit_counter = unit_counter + 1
		end
	end

	EnfosWizard:CastSpellResult(caster, "mass_banishment")
end

function enfos_wizard_mass_banishment:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



modifier_mass_banishment_prevention = class({})

function modifier_mass_banishment_prevention:IsHidden() return false end
function modifier_mass_banishment_prevention:IsDebuff() return false end
function modifier_mass_banishment_prevention:IsPurgable() return false end
function modifier_mass_banishment_prevention:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_mass_banishment_prevention:GetTexture() return "enfos_wizard_mass_banishment" end



modifier_mass_banishment_freeze = class({})

function modifier_mass_banishment_freeze:IsHidden() return false end
function modifier_mass_banishment_freeze:IsDebuff() return true end
function modifier_mass_banishment_freeze:IsPurgable() return false end
function modifier_mass_banishment_freeze:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_mass_banishment_freeze:GetTexture() return "enfos_wizard_mass_banishment" end

function modifier_mass_banishment_freeze:OnCreated(keys)
	if IsClient() then return end

	self.team = keys.team
	local parent = self:GetParent()
	local pfx_radius = ((parent.is_boss or parent.is_elite) and 20) or 10

	self.delay_pfx = ParticleManager:CreateParticle("particles/vr/teleport/vr_teleport_destination.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(self.delay_pfx, 6, Vector(pfx_radius, 0, 0))
end

function modifier_mass_banishment_freeze:OnDestroy()
	if IsClient() then return end

	local parent = self:GetParent()
	local spawn_position = EnfosSpawner.spawn_points[self.team][RandomInt(1, 2)].position

	if spawn_position and parent:IsAlive() then

		parent:AddNewModifier(parent, nil, "modifier_mass_banishment_prevention", {})

		parent:EmitSound("Wizard.MassBanishment.Teleport")

		local teleport_pfx = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/teleport_team_flair_ground_lvl1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(teleport_pfx, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(teleport_pfx)

		ParticleManager:DestroyParticle(self.delay_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.delay_pfx)

		Timers:CreateTimer(0.1, function()
			FindClearSpaceForUnit(parent, spawn_position, true)
		end)
	end
end


function modifier_mass_banishment_freeze:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
end
