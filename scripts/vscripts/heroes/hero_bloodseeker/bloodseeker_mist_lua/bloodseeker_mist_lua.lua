bloodseeker_mist_lua = bloodseeker_mist_lua or class({})

LinkLuaModifier("modifier_bloodseeker_mist_aura_lua", "heroes/hero_bloodseeker/bloodseeker_mist_lua/bloodseeker_mist_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_mist_burn_lua", "heroes/hero_bloodseeker/bloodseeker_mist_lua/bloodseeker_mist_lua", LUA_MODIFIER_MOTION_NONE)

function bloodseeker_mist_lua:GetCastRange(location, target)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int8") ~= nil then
		return self:GetSpecialValueFor("radius") + 150
	end
	return self:GetSpecialValueFor("radius")
end

function bloodseeker_mist_lua:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_mist_aura_lua", {})
		self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	else
		self:GetCaster():RemoveModifierByName("modifier_bloodseeker_mist_aura_lua")
	end
end

-------------------------------------------------------------------

modifier_bloodseeker_mist_aura_lua = class({})

function modifier_bloodseeker_mist_aura_lua:IsHidden()
	return true
end

function modifier_bloodseeker_mist_aura_lua:IsPurgable()
	return false
end

function modifier_bloodseeker_mist_aura_lua:OnCreated()
	self.caster = self:GetCaster()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if self.caster:FindAbilityByName("npc_dota_hero_bloodseeker_int8") ~= nil then
		self.radius = self.radius + 150
	end
	self:StartIntervalThink(0.5)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
	self:AddParticle(particle, false, false, -1, false, false)

	local particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_spray_initial.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_2, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle_2, false, false, -1, false, false)
end

function modifier_bloodseeker_mist_aura_lua:OnIntervalThink()
	if IsServer() then
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	if self.caster:FindAbilityByName("npc_dota_hero_bloodseeker_str10") ~= nil then 
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
	end
		ApplyDamage({attacker = self:GetParent(), victim = self.caster, damage = self.caster:GetMaxHealth()/200*self:GetAbility():GetSpecialValueFor("self_hit"), damage_type = DAMAGE_TYPE_PURE, damage_flags = df})
	end	
	
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int11") ~= nil then
		self.damage = self.damage + self:GetCaster():GetIntellect()*0.5
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str_last") ~= nil then
		self.damage = self.damage + self:GetCaster():GetStrength()
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi8") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetBaseDamageMin() * 0.20
	end
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(self.caster, self, "modifier_bloodseeker_mist_burn_lua", {duration = 0.6})
		ApplyDamage({attacker = self.caster, victim = enemy, damage = self.damage/2, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
	end	
end

-----------------------------------------------------------

modifier_bloodseeker_mist_burn_lua = class({})

function modifier_bloodseeker_mist_burn_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_bloodseeker_mist_burn_lua:GetModifierMoveSpeedBonus_Percentage(keys)
	return -25
end