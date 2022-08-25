npc_byorrocktar_spell3 = class({})

function npc_byorrocktar_spell3:OnSpellStart()
    local interval = 1 / self:GetSpecialValueFor("rokets_sec")
    local count = 0
    local max_count = self:GetSpecialValueFor("rokets_count")
    local damage = self:GetSpecialValueFor("damage")
    self.radius = self:GetSpecialValueFor("radius")
    EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage", self:GetCaster())
    Timers:CreateTimer(interval,function()
        if count < max_count then
            count = count + 1 
			self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			if #self.enemies >= 1 then
				for _, enemy in pairs(self.enemies) do
					enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
					
					self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, attach_hitloc, self:GetCaster():GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(self.barrage_particle)
		
					ApplyDamage({
						victim 			= enemy,
						damage 			= damage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
					})
					break
				end
			end
		end
	return interval
    end)
end

