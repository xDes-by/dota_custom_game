naga_siren_rip_tide = class({})
LinkLuaModifier("modifier_naga_siren_rip_tide_passive_lua", "heroes/hero_naga_siren/naga_siren_rip_tide", LUA_MODIFIER_MOTION_NONE)

function naga_siren_rip_tide:GetIntrinsicModifierName()
	return "modifier_naga_siren_rip_tide_passive_lua"
end

function naga_siren_rip_tide:Proc(issuer)
	local hero = self:GetCaster()

	if hero:IsAlive() then
		self:Wave(hero)
	end

	local heroes = HeroList:GetAllHeroes()

	for _, unit in pairs(heroes) do
		local illusion_modifier = unit:FindModifierByName("modifier_illusion")
		if unit:IsIllusion() and unit:IsAlive() and illusion_modifier and illusion_modifier:GetCaster() == hero then
			self:Wave(unit)
		end
	end

	issuer:StartGesture(ACT_DOTA_CAST_ABILITY_3)
end

function naga_siren_rip_tide:Wave(unit)
	local caster = self:GetCaster()

	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local damage_table = {
		damage = self:GetSpecialValueFor("damage") + caster:FindTalentValue("special_bonus_unique_naga_siren_2"),
		damage_type = self:GetAbilityDamageType(),
		attacker = caster,
		ability = self,
	}

	local targets = FindUnitsInRadius(
		unit:GetTeam(), 
		unit:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_ALL, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false)

	for _, target in pairs(targets) do
		local debuff = target:FindModifierByName("modifier_naga_siren_rip_tide")

		if not debuff or debuff:GetElapsedTime() > FrameTime() then
			target:AddNewModifier(caster, self, "modifier_naga_siren_rip_tide", {
				duration = target:ApplyStatusResistance(duration)
			})

			damage_table.victim = target
			ApplyDamage(damage_table)
		end

	end

	EmitSoundOn("Hero_NagaSiren.Riptide.Cast", unit)

	local particle_name = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", caster)
	local pFX = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, unit)
	ParticleManager:SetParticleControl(pFX, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(pFX, 3, Vector(1, 1, 1))
end

modifier_naga_siren_rip_tide_passive_lua = class({})

function modifier_naga_siren_rip_tide_passive_lua:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_naga_siren_rip_tide_passive_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_naga_siren_rip_tide_passive_lua:OnCreated(kv)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
end

function modifier_naga_siren_rip_tide_passive_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_naga_siren_rip_tide_passive_lua:GetModifierProcAttack_Feedback(params)
	local modifier = self

	if self.parent:IsIllusion() then
		local hero = PlayerResource:GetSelectedHeroEntity(self.parent:GetPlayerOwnerID())
		
		if hero then
			modifier = hero:FindModifierByName("modifier_naga_siren_rip_tide_passive_lua")
		end
		
		if not modifier then return end
	end

	modifier:IncrementStackCount()

	local hits = self.ability:GetSpecialValueFor("hits")

	if modifier:GetStackCount() >= hits then
		modifier.ability:Proc(self.parent)
		modifier:SetStackCount(0)
	end
end