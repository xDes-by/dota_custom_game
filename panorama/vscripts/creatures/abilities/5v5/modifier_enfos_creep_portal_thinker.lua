modifier_enfos_creep_portal_thinker = class({})

function modifier_enfos_creep_portal_thinker:IsDebuff() return false end
function modifier_enfos_creep_portal_thinker:IsHidden() return true end
function modifier_enfos_creep_portal_thinker:IsPurgable() return false end
function modifier_enfos_creep_portal_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_creep_portal_thinker:OnCreated(keys)
	if IsServer() then
		self.portal_location = Vector(keys.x, keys.y, keys.z)
		self.portal_max_y = self.portal_location.y
		self.portal_min_y = self.portal_location.y - 250

		self:StartIntervalThink(0.1)
	end
end

function modifier_enfos_creep_portal_thinker:CheckState()
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

function modifier_enfos_creep_portal_thinker:OnIntervalThink()
	if not IsServer() then return end

	local units = FindUnitsInLine(DOTA_TEAM_NEUTRALS, self.portal_location + Vector(0, -250, 0), self.portal_location, nil, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD)
	for _, unit in pairs(units) do
		local unit_loc = unit:GetAbsOrigin()
		if unit:IsAlive() and unit_loc.y >= self.portal_min_y and unit_loc.y <= self.portal_max_y and unit.spawner_team and (not unit:HasModifier("modifier_enfos_creep_portal_reached")) then
			EmitSoundOnLocationWithCaster(self.portal_location, "Enfos.CreepPortalTrigger", unit)

			local knockback_center = unit_loc + 100 * (unit_loc - self.portal_location):Normalized()
			unit:FaceTowards(self.portal_location)

			local knockback_table = {
				center_x = knockback_center.x,
				center_y = knockback_center.y,
				center_z = knockback_center.z,
				knockback_duration = 0.3,
				knockback_distance = 400,
				knockback_height = 140,
				should_stun = 1,
				duration = 0.3
			}
			unit:RemoveModifierByName("modifier_knockback")
			unit:AddNewModifier(unit, nil, "modifier_knockback", knockback_table)

			Enfos:LoseLife(unit)

			unit:AddNewModifier(unit, nil, "modifier_enfos_creep_portal_reached", {})

			Timers:CreateTimer(0.18, function()
				unit_loc = unit:GetAbsOrigin()

				local unit_pfx = ParticleManager:CreateParticle("particles/5v5/custom/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(unit_pfx, 0, unit_loc)
				ParticleManager:SetParticleControl(unit_pfx, 1, unit_loc)
				ParticleManager:SetParticleControl(unit_pfx, 2, Vector(167, 75, 213))
				ParticleManager:SetParticleControl(unit_pfx, 11, Vector(0, 1, 0))
				ParticleManager:ReleaseParticleIndex(unit_pfx)

				local portal_pfx = ParticleManager:CreateParticle("particles/5v5/custom/creep_portal_flash.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(portal_pfx, 0, self.portal_location + Vector(0, -64, 192))
				ParticleManager:SetParticleControl(portal_pfx, 1, self.portal_location + Vector(0, -64, 192))
				ParticleManager:SetParticleControlOrientation(portal_pfx, 1, Vector(0, 1, 0), Vector(-1, 0, 0), Vector(0, 0, 1))
				ParticleManager:ReleaseParticleIndex(portal_pfx)

				unit:ForceKill(false)
				unit:AddNoDraw()
			end)
		end
	end
end



modifier_enfos_creep_portal_reached = class({})

function modifier_enfos_creep_portal_reached:IsDebuff() return false end
function modifier_enfos_creep_portal_reached:IsHidden() return true end
function modifier_enfos_creep_portal_reached:IsPurgable() return false end
function modifier_enfos_creep_portal_reached:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_creep_portal_reached:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	return state
end

function modifier_enfos_creep_portal_reached:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_enfos_creep_portal_reached:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_enfos_creep_portal_reached:GetModifierModelScale()
	return -90
end
