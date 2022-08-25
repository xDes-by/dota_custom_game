LinkLuaModifier("modifier_boss_6_torrent", "abilities/bosses/line/boss_6/boss_6_torrent", LUA_MODIFIER_MOTION_NONE)

boss_6_torrent = class({})

function boss_6_torrent:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_boss_6_torrent", -- modifier name
			{ duration = self:GetSpecialValueFor("duration") } -- kv
		)
end	
----------------------------------------------------------------------------------

modifier_boss_6_torrent = class({})

function modifier_boss_6_torrent:IsHidden()
    return true
end

function modifier_boss_6_torrent:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(self.interval)
end


function modifier_boss_6_torrent:OnIntervalThink()
if not IsServer() then return end
	local caster_pos = self:GetCaster():GetAbsOrigin()
	for i = 1, 3 do
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-self.radius, self.radius)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
		local blast_delay = self:GetAbility():GetSpecialValueFor("delay")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local main_blast_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
			

			local particle_blast_fx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(particle_blast_fx, 0, target_point)
			ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(main_blast_radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(particle_blast_fx)

			EmitSoundOn("Ability.Torrent", self:GetCaster())
			
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

	end
	self:StartIntervalThink(-1)
	self:StartIntervalThink(self.interval)
end