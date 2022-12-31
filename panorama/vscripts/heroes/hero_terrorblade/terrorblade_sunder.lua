---@class terrorblade_sunder_lua:CDOTA_Ability_Lua
terrorblade_sunder_lua = class({})

if IsServer() then
	function terrorblade_sunder_lua:CastFilterResultTarget(target)
		if target == self:GetCaster() then return UF_FAIL_CUSTOM end

		local team = self:GetAbilityTargetTeam()
		local type = self:GetAbilityTargetType()
		local flags = self:GetAbilityTargetFlags()
		return UnitFilter(target, team, type, flags, self:GetTeam())
	end
end

function terrorblade_sunder_lua:GetCustomCastErrorTarget(target)
	return "#dota_hud_error_cant_cast_on_self"
end

function terrorblade_sunder_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_terrorblade")
end

function terrorblade_sunder_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local hit_point_minimum_pct = self:GetSpecialValueFor( "hit_point_minimum_pct") * 0.01
	local caster_max_health = caster:GetMaxHealth()
	local target_max_health = target:GetMaxHealth()
	local caster_health_percent = caster:GetHealth() / caster_max_health
	local target_health_percent = target:GetHealth() / target_max_health

	-- Swap the HP of the caster
	if target_health_percent <= hit_point_minimum_pct then
		caster:SetHealth(caster_max_health * hit_point_minimum_pct)
	else
		caster:SetHealth(caster_max_health * target_health_percent)
	end

	-- Swap the HP of the target
	if caster_health_percent <= hit_point_minimum_pct then
		target:SetHealth(target_max_health * hit_point_minimum_pct)
	else
		target:SetHealth(target_max_health * caster_health_percent)
	end

	caster:EmitSound("Hero_Terrorblade.Sunder.Cast")
	target:EmitSound("Hero_Terrorblade.Sunder.Target")

	-- Show the particle caster-> target
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )

	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	-- Show the particle target-> caster
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end