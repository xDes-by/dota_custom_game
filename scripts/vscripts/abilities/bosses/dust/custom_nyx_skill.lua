LinkLuaModifier("modifier_custom_nyx_skill", "abilities/bosses/dust/custom_nyx_skill", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_VERTICAL)

custom_nyx_skill = class({})

function custom_nyx_skill:OnSpellStart()    
	local duration = self:GetSpecialValueFor("duration") 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_nyx_skill", {duration = duration})
end
------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_custom_nyx_skill = class({})

function modifier_custom_nyx_skill:IsHidden()
	return false
end

function modifier_custom_nyx_skill:IsPurgable()
	return false
end

function modifier_custom_nyx_skill:OnCreated( kv )
	self:StartIntervalThink(0.4)
end

function modifier_custom_nyx_skill:OnIntervalThink()	
if not IsServer() then return end	
	EmitSoundOn("Hero_Leshrac.Split_Earth", self:GetCaster())
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local ability = self:GetAbility()
	local range = self:GetAbility():GetSpecialValueFor("range")
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
	
	local angle = RandomInt(0, 360)
	local variance = RandomInt(-range, range)
	local dy = math.sin(angle) * variance
	local dx = math.cos(angle) * variance
	local target_pos = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)

	local particle_blast_fx = ParticleManager:CreateParticle("particles/econ/items/leshrac/leshrac_tormented_staff/leshrac_split_d_tormented.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, target_pos)
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(damage_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)

	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for k, unit in ipairs(units) do
		local damage_table = {
								attacker = caster,
								victim = unit,
								ability = ability,
								damage_type = DAMAGE_TYPE_PURE,
								damage = damage
							}
		ApplyDamage(damage_table)
	end	
end
