lifestealer_infest_lua = class({})
LinkLuaModifier("modifier_lifestealer_infest_target", "heroes/hero_lifestealer/modifier_lifestealer_infest_target", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lifestealer_infest_caster", "heroes/hero_lifestealer/modifier_lifestealer_infest_caster", LUA_MODIFIER_MOTION_NONE)

function lifestealer_infest_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function lifestealer_infest_lua:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	if not caster:HasScepter() then -- Castable on enemy heroes once scepter is acquired
	if target:IsRealHero() and caster:GetTeamNumber() ~= target:GetTeamNumber() then
		return UF_FAIL_ENEMY
	end
	end

	if target == caster then return UF_FAIL_FRIENDLY end
	if target:IsTempestDouble() then return UF_FAIL_ILLUSION end
	return UF_SUCCESS
end

function lifestealer_infest_lua:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()

	if caster:HasScepter() then
		cooldown = self:GetSpecialValueFor("cooldown_scepter")
	end

	return cooldown
end

function lifestealer_infest_lua:GetCastRange(location, target)
	local cast_range = self.BaseClass.GetCastRange(self, location, target)
	local caster = self:GetCaster()

	if caster:HasScepter() then
		cast_range = self:GetSpecialValueFor("cast_range_scepter")
	end

	return cast_range
end

function lifestealer_infest_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local caster_mod = caster:AddNewModifier(caster, self, "modifier_lifestealer_infest_caster", {})
	local target_mod = target:AddNewModifier(caster, self, "modifier_lifestealer_infest_target", {})

	-- some parts of our setup failed
	-- gotta reset everything and exit
	if not caster_mod then
		if target_mod and not target_mod:IsNull() then
			target_mod:Destroy()
		end
	end

	if not target_mod then
		if caster_mod and not caster_mod:IsNull() then
			caster_mod:Destroy()
		end
	end

	if not target_mod or not caster_mod then return end

	-- If anyone has a smarter way of knowing if the caster is inside an enemy hero, feel free to edit it
	if caster:GetTeam() ~= target:GetTeam() and target:IsHero() then
		caster_mod:SetStackCount(1)
	end

	target_mod.caster_mod = caster_mod
	caster_mod.target_mod = target_mod

	caster:EmitSound("Hero_LifeStealer.Infest")

	local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, target)
	ParticleManager:SetParticleControl(infest_particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(infest_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(infest_particle)

	caster:Purge(true, true, false, false, false)
	ProjectileManager:ProjectileDodge(caster)

	self:SetAbilitiesHiddenState(true)
end

function lifestealer_infest_lua:SetAbilitiesHiddenState(state)
	local caster = self:GetCaster()


	for index = 0, 31 do
		local ability = caster:GetAbilityByIndex(index)
		if ability and not ability:IsNull() and ability ~= self then
			if state then
				if not ability:IsHidden() then
					ability:SetHidden(state)
					ability.infest_hidden = true
				end
			elseif ability.infest_hidden then
				ability:SetHidden(state)
				ability.infest_hidden = nil
			end
		end
	end

	caster:SwapAbilities(self:GetAbilityName(), "lifestealer_eject_lua", not state, state)

	if not state then
		self:UseResources(false, false, true)
	end
end
