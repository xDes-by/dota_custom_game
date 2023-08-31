LinkLuaModifier("modifier_boss_5_bolt", "abilities/bosses/line/boss_5/boss_5_bolt", LUA_MODIFIER_MOTION_NONE)

boss_5_bolt = class({})

function boss_5_bolt:OnSpellStart()
	self.mod_caster = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_5_bolt", { duration = self:GetSpecialValueFor("count")})
end

-----------------------------------------------------------------------------------------------------------
modifier_boss_5_bolt = class({})

function modifier_boss_5_bolt:IsHidden()	
	return false
end

function modifier_boss_5_bolt:IsPurgable()
	return false
end

function modifier_boss_5_bolt:OnCreated()	
if not IsServer() then return end
	local count = self:GetAbility():GetSpecialValueFor("count")
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	self.move = radius / count
	self.range = 0	
	self.range = self.range + self.move
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * self.range
	local rotation_rate = 360 / 6
	self:StartIntervalThink(1)
end

function modifier_boss_5_bolt:OnIntervalThink()
if not IsServer() then return end
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local count = self:GetAbility():GetSpecialValueFor("count")
	self.range = self.range + self.move
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * self.range
	local rotation_rate = 360 / 6
	for i = 1, 6 do
		line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, 0), line_pos)
		self:createbolt(line_pos)
	end		
end

function modifier_boss_5_bolt:createbolt(target_point)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
	z_pos = 950
	ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
	ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
	ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt")
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target_point, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,enemy in pairs(enemies) do
			local damage = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = enemy:GetMaxHealth() * 0.15,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}
			ApplyDamage( damage )
		end
end
