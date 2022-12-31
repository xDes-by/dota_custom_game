---@class modifier_dawnbreaker_luminosity_attack_buff_lua:CDOTA_Modifier_Lua
modifier_dawnbreaker_luminosity_attack_buff_lua = class({})

modifier_dawnbreaker_luminosity_attack_buff_lua.heal_effect_name = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity.vpcf"
modifier_dawnbreaker_luminosity_attack_buff_lua.buff_effect_name = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity_attack_buff.vpcf"
function modifier_dawnbreaker_luminosity_attack_buff_lua:IsHidden() return false end
function modifier_dawnbreaker_luminosity_attack_buff_lua:IsPurgable() return false end

function modifier_dawnbreaker_luminosity_attack_buff_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
	}
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:OnCreated()
	if IsClient() then return end

	local caster = self:GetCaster()

	local pfx = ParticleManager:CreateParticle(self.buff_effect_name, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_core_fx", Vector(0,0,0), true)
	self:AddParticle(pfx, false, false, 0 , false, false)
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:GetCritDamage()
	return (self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_dawnbreaker_luminosity_crit")) * 0.01
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:GetModifierPreAttack_CriticalStrike(event)
	self.record = self.record or event.record

	if self.record == event.record then
		return self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_dawnbreaker_luminosity_crit")
	end
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:OnAttackCancelled(event)
	if self.record == event.record then
		self.record = nil
	end
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:GetModifierProcAttack_Feedback(event)
	if self.record ~= event.record then return end

	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local target = event.target

	if not ability then
		self:Destroy()
		return
	end

	local heal = event.damage * ability:GetSpecialValueFor("heal_pct") * 0.01

	if not event.target:IsHero() then
		heal = heal * ability:GetSpecialValueFor("heal_from_creeps") * 0.01
	end

	caster:HealWithParams(heal, ability, true, true, caster, false)

	local pfx = ParticleManager:CreateParticle(self.heal_effect_name, PATTACH_CENTER_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CENTER_FOLLOW, "", Vector(0,0,0), false)
	ParticleManager:ReleaseParticleIndex(pfx)

	heal = heal * ability:GetSpecialValueFor("allied_healing_pct") * 0.01

	local radius = ability:GetSpecialValueFor("heal_radius")
	local allies = FindUnitsInRadius(
		caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false
	)

	for _, unit in pairs(allies) do
		unit:HealWithParams(heal, ability, true, true, caster, false)

		local pfx = ParticleManager:CreateParticle(self.heal_effect_name, PATTACH_CENTER_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CENTER_FOLLOW, "", Vector(0,0,0), false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end

	self:Destroy()
end

function modifier_dawnbreaker_luminosity_attack_buff_lua:OnAttackFail(event)
	if self.record == event.record then 
		self:Destroy()
	end
end
