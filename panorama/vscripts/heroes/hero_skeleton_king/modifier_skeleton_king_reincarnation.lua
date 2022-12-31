---@class modifier_skeleton_king_reincarnation_lua:CDOTA_Modifier_Lua
modifier_skeleton_king_reincarnation_lua = class({})

function modifier_skeleton_king_reincarnation_lua:IsHidden() return true end
function modifier_skeleton_king_reincarnation_lua:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

-- Only for modifier with highest priority ReincarnateTime() func will be called
function modifier_skeleton_king_reincarnation_lua:GetPriority()
	local ability = self:GetAbility()

	if ability:IsOwnersManaEnough() and ability:IsCooldownReady() then
		return MODIFIER_PRIORITY_ULTRA
	end
end

function modifier_skeleton_king_reincarnation_lua:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_skeleton_king_reincarnation_lua:OnCreated()
	local ability = self:GetAbility()

	self.reincarnate_time = ability:GetSpecialValueFor("reincarnate_time")       
	self.slow_radius = ability:GetSpecialValueFor("slow_radius")
	self.slow_duration = ability:GetSpecialValueFor("slow_duration")
end

function modifier_skeleton_king_reincarnation_lua:ReincarnateTime()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if caster:IsRealHero() and ability:IsOwnersManaEnough() and ability:IsCooldownReady() then
		self.reincarnation_death = true

		ability:UseResources(true, false, true)

		AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetCurrentVisionRange(), self.reincarnate_time, true)

		local heroes = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			self.slow_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false
		)

		local hellfire_blast = caster:FindAbilityByName("skeleton_king_hellfire_blast")
		local cast_hellfire_blact = caster:HasTalent("special_bonus_unique_wraith_king_4") and hellfire_blast and hellfire_blast:IsTrained()

		for _, hero in pairs(heroes) do
			if cast_hellfire_blact then
				caster:SetCursorCastTarget(hero)
				hellfire_blast:OnSpellStart()
			else
				hero:AddNewModifier(caster, ability, "modifier_skeleton_king_reincarnate_slow", { duration = self.slow_duration })
			end
		end

		local pfx_name = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", caster)
		local particle_death_fx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
		ParticleManager:SetParticleControl(particle_death_fx, 0,caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(self.reincarnate_time, 0, 0))
		ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_death_fx)
		
		return self.reincarnate_time
	end
end

function modifier_skeleton_king_reincarnation_lua:GetActivityTranslationModifiers()
	if self.reincarnation_death then
		return "reincarnate"
	end
end
