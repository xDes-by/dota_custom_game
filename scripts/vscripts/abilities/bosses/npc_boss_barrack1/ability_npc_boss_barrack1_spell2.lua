ability_npc_boss_barrack1_spell2 = class({})

function ability_npc_boss_barrack1_spell2:OnSpellStart()
    local blast_radius = self:GetSpecialValueFor("blast_radius")
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local blast_damage_persent = self:GetSpecialValueFor("blast_damage_persent") * 0.01
	local blast_duration = blast_radius / blast_speed
	local current_loc = self:GetCaster():GetAbsOrigin()

	local debuff_duration	= self:GetSpecialValueFor("debuff_duration")
	local caster	= self:GetCaster()
	local ability	= self
	self:GetCaster():EmitSound("DOTA_Item.ShivasGuard.Activate")

	local blast_pfx = ParticleManager:CreateParticle("particles/econ/events/ti9/shivas_guard_ti9_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(blast_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(blast_pfx)

	local targets_hit = {}
	local current_radius = 0
	local tick_interval = 0.1
	Timers:CreateTimer(tick_interval, function()
		current_radius = current_radius + blast_speed * tick_interval
		current_loc = self:GetCaster():GetAbsOrigin()
		local nearby_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end
			if not enemy_has_been_hit then
				local hit_pfx = ParticleManager:CreateParticle("particles/econ/events/ti9/shivas_guard_ti9_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = blast_damage_persent * enemy:GetMaxHealth(), damage_type = DAMAGE_TYPE_MAGICAL})
				enemy:AddNewModifier(caster, ability, "modifier_sheepstick_debuff", {duration = debuff_duration})

				end
				targets_hit[#targets_hit + 1] = enemy
		end
		if current_radius < blast_radius then
			return tick_interval
		end
	end)
end