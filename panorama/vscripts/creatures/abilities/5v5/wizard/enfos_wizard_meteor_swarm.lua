enfos_wizard_meteor_swarm = class({})

function enfos_wizard_meteor_swarm:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local mana_boost = 0.01 * EnfosWizard:GetMana(team)
	local duration = mana_boost * self:GetSpecialValueFor("duration")
	local damage = 0.01 * mana_boost * self:GetSpecialValueFor("damage")
	local meteor_radius = self:GetSpecialValueFor("meteor_radius")
	local meteor_frequency = self:GetSpecialValueFor("meteor_frequency")

	EmitGlobalSound("wizard_meteor_swarm_cast")

	local elapsed_duration = 0
	local current_target = false

	Timers:CreateTimer(meteor_frequency, function()
		current_target = false

		local enemy_creeps = table.shuffle(Enfos.current_creeps[team])
		for _, enemy_creep in pairs(enemy_creeps) do
			if enemy_creep:IsAlive() then
				current_target = enemy_creep
				break
			end
		end

		-- Actual meteor
		if current_target then
			local target_pos = current_target:GetAbsOrigin()

			EmitSoundOnLocationWithCaster(target_pos, "Wizard.MeteorSwarm.Hit", current_target)

			local meteor_pfx = ParticleManager:CreateParticle("particles/5v5/meteor_shower.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(meteor_pfx, 0, target_pos)
			ParticleManager:SetParticleControl(meteor_pfx, 1, Vector(meteor_radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(meteor_pfx)

			local enemies = FindUnitsInRadius(team, target_pos, nil, meteor_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				ApplyDamage({victim = enemy, attacker = caster, damage = damage * enemy:GetMaxHealth(), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end
		end

		elapsed_duration = elapsed_duration + meteor_frequency
		if elapsed_duration < duration then return meteor_frequency end
	end)

	EnfosWizard:CastSpellResult(caster, "meteor_swarm")
end
