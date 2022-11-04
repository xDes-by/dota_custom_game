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
	else
		self:GetCaster():RemoveModifierByName("modifier_bloodseeker_mist_aura_lua")
	end
end

-------------------------------------------------------------------

modifier_bloodseeker_mist_aura_lua = class({})

function modifier_bloodseeker_mist_aura_lua:IsAura()
	return true
end

function modifier_bloodseeker_mist_aura_lua:GetAuraRadius()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int8") ~= nil then
		return self:GetAbility():GetSpecialValueFor("radius") + 150
	end
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_bloodseeker_mist_aura_lua:OnCreated()
	--self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:StartIntervalThink(0.2)
end

function modifier_bloodseeker_mist_aura_lua:OnIntervalThink()
	if IsServer() then
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str10") ~= nil then 
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
	end
		ApplyDamage({attacker = self:GetParent(), victim = self:GetCaster(), damage = self:GetCaster():GetMaxHealth()/500*self:GetAbility():GetSpecialValueFor("self_hit"), damage_type = DAMAGE_TYPE_PURE, damage_flags = df})
	end	
end

function modifier_bloodseeker_mist_aura_lua:OnDestroy()
	-- ParticleManager:DestroyParticle(self.particle, false)
	-- ParticleManager:ReleaseParticleIndex(self.particle)
end

function modifier_bloodseeker_mist_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_bloodseeker_mist_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_bloodseeker_mist_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_bloodseeker_mist_aura_lua:GetModifierAura()
	return "modifier_bloodseeker_mist_burn_lua"
end

-----------------------------------------------------------

modifier_bloodseeker_mist_burn_lua = class({})

function modifier_bloodseeker_mist_burn_lua:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")/5
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int11") ~= nil then
		self.damage = self.damage + self:GetCaster():GetIntellect()/4
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str_last") ~= nil then
		self.damage = self.damage + self:GetCaster():GetStrength()
	end
		
	-- if self.particle == nil then
		-- self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- end
	self:StartIntervalThink(0.2)
end

function modifier_bloodseeker_mist_burn_lua:OnDestroy()
		if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end	
end

function modifier_bloodseeker_mist_burn_lua:OnIntervalThink()
	if IsServer() then
		ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end
