LinkLuaModifier("modifier_swamp_blast", "abilities/bosses/swamp/swamp_blast", LUA_MODIFIER_MOTION_NONE)

swamp_blast = class({})

function swamp_blast:GetIntrinsicModifierName()
	return "modifier_swamp_blast"
end

----------------------------------------------------------------------------------

modifier_swamp_blast = class({})

function modifier_swamp_blast:IsHidden()
    return true
end

function modifier_swamp_blast:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(self.interval)
end


function modifier_swamp_blast:OnIntervalThink()
if not IsServer() then return end
	local caster_pos = self:GetCaster():GetAbsOrigin()
	if self:GetCaster():IsAlive() then
		self.interval = self:GetAbility():GetSpecialValueFor("interval") - (((100 - self:GetCaster():GetHealthPercent())/10)/2.3)
		
		for i = 1, 3 do
			local angle = RandomInt(0, 360)
			local variance = RandomInt(-self.radius, self.radius)
			local dy = math.sin(angle) * variance
			local dx = math.cos(angle) * variance
			local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
			local blast_delay = 1
			local damage = 10000
			local main_blast_radius = 300
				
			EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Pugna.NetherBlastPreCast", self:GetCaster())

			local particle_pre_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(particle_pre_blast_fx, 0, target_point)
			ParticleManager:SetParticleControl(particle_pre_blast_fx, 1, Vector(main_blast_radius, blast_delay, 1))
			ParticleManager:ReleaseParticleIndex(particle_pre_blast_fx)


			Timers:CreateTimer(blast_delay, function()
				local particle_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
				ParticleManager:SetParticleControl(particle_blast_fx, 0, target_point)
				ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(main_blast_radius, 0, 0))
				ParticleManager:ReleaseParticleIndex(particle_blast_fx)

				EmitSoundOn("Hero_Pugna.NetherBlast", self:GetCaster())
				
				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target_point, nil, main_blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,enemy in pairs(enemies) do
					local damageTable = {
						victim = enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = self:GetCaster(),
					}

					ApplyDamage(damageTable)
				end
			end)
		end
		self:StartIntervalThink(-1)
		self:StartIntervalThink(self.interval)
	end
end