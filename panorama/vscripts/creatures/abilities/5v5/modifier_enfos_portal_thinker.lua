modifier_enfos_portal_thinker = class({})

function modifier_enfos_portal_thinker:IsDebuff() return false end
function modifier_enfos_portal_thinker:IsHidden() return true end
function modifier_enfos_portal_thinker:IsPurgable() return false end
function modifier_enfos_portal_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_portal_thinker:IsAura() return true end
function modifier_enfos_portal_thinker:GetAuraRadius() return self.radius end
function modifier_enfos_portal_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_enfos_portal_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_enfos_portal_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_enfos_portal_thinker:GetModifierAura() return "modifier_enfos_portal" end

function modifier_enfos_portal_thinker:OnCreated(keys)
	if IsServer() then
		self.radius = keys.radius
		self.entry_loc = Vector(keys.in_x, keys.in_y, keys.in_z)
		self.exit_loc = Vector(keys.out_x, keys.out_y, keys.out_z)

		self:StartIntervalThink(0.1)
	end
end

function modifier_enfos_portal_thinker:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}
end

function modifier_enfos_portal_thinker:OnIntervalThink()
	if not IsServer() then return end

	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self.entry_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		local unit_loc = unit:GetAbsOrigin()
		if unit:IsAlive() and unit:HasModifier("modifier_enfos_portal") and (not unit.recently_teleported) then
			local unit_loc = unit:GetAbsOrigin()
			unit.recently_teleported = true

			EmitSoundOnLocationWithCaster(self.entry_loc, "Enfos.CreepPortalSpawn", unit)

			local portal_pfx = ParticleManager:CreateParticle("particles/5v5/custom/teleport_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(portal_pfx, 0, unit_loc)
			ParticleManager:SetParticleControl(portal_pfx, 1, unit_loc)
			ParticleManager:ReleaseParticleIndex(portal_pfx)

			FindClearSpaceForUnit(unit, self.exit_loc, true)
			Camera:SetCameraToOwnHeroPosition(unit:GetPlayerOwner(), 0)

			Timers:CreateTimer(0.1, function()

				EmitSoundOnLocationWithCaster(self.exit_loc, "Enfos.CreepPortalTrigger", unit)

				local portal_pfx = ParticleManager:CreateParticle("particles/5v5/custom/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(portal_pfx, 0, unit:GetAbsOrigin())
				ParticleManager:SetParticleControl(portal_pfx, 1, unit:GetAbsOrigin())
				ParticleManager:SetParticleControl(portal_pfx, 2, Vector(167, 75, 213))
				ParticleManager:SetParticleControl(portal_pfx, 11, Vector(0, 1, 0))
				ParticleManager:ReleaseParticleIndex(portal_pfx)
			end)
		end
	end
end



modifier_enfos_portal = class({})

function modifier_enfos_portal:IsDebuff() return false end
function modifier_enfos_portal:IsHidden() return true end
function modifier_enfos_portal:IsPurgable() return false end
function modifier_enfos_portal:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_portal:OnDestroy()
	if IsServer() then
		self:GetParent().recently_teleported = nil
	end
end
