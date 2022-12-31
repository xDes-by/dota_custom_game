void_spirit_aether_remnant_lua = class({})
LinkLuaModifier("modifier_void_spirit_aether_remnant_lua_thinker", "heroes/hero_void_spirit/modifier_void_spirit_aether_remnant_lua_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_aether_remnant_lua_pull", "heroes/hero_void_spirit/modifier_void_spirit_aether_remnant_lua_pull", LUA_MODIFIER_MOTION_NONE)


function void_spirit_aether_remnant_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function void_spirit_aether_remnant_lua:OnSpellStart()
	local caster = self:GetCaster()
	local caster_position = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()

	local position_difference = target_point - caster_position
	local distance = position_difference:Length()
	local direction = position_difference:Normalized()
	direction.z = 0

	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	ProjectileManager:CreateLinearProjectile({
		EffectName = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf",
		Ability = self,
		source = caster,
		vSpawnOrigin = caster_position, 
		fStartRadius = 90.0,
		fEndRadius = 90.0,
		vVelocity = direction * projectile_speed,
		fDistance = distance,
	})

	caster:EmitSound("Hero_VoidSpirit.AetherRemnant.Cast")
end


function void_spirit_aether_remnant_lua:OnProjectileHit(target, location)
	if not self or self:IsNull() then return end
	if not location then return end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	local remnant = CreateModifierThinker(
		caster,
		self,
		"modifier_void_spirit_aether_remnant_lua_thinker",
		{},
		location,
		caster:GetTeamNumber(),
		false
	)
end
