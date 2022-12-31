creature_rift_pulse = class({})

function creature_rift_pulse:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local radius = self:GetSpecialValueFor("radius")

		if caster:HasModifier("modifier_creature_berserk") then
			radius = radius * 2
		end

		caster:EmitSound("CreatureRiftPulse.Pulse")

		local pulse_pfx = ParticleManager:CreateParticle("particles/creature/rift_pulse.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pulse_pfx, 0, caster_loc + Vector(0, 0, 100))
		ParticleManager:ReleaseParticleIndex(pulse_pfx)

		local enemies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if (not enemy:IsMagicImmune()) then
				local actual_damage = ApplyDamage({victim = enemy, attacker = caster, damage = self:GetSpecialValueFor("pulse_damage"), damage_type = DAMAGE_TYPE_MAGICAL})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, actual_damage, nil)
			end
		end
	end
end
