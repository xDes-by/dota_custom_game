bloodseeker_mist_lua = bloodseeker_mist_lua or class({})

LinkLuaModifier("modifier_bloodseeker_mist_aura_lua", "heroes/hero_bloodseeker/bloodseeker_mist_lua/bloodseeker_mist_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_mist_debuff", "heroes/hero_bloodseeker/bloodseeker_mist_lua/bloodseeker_mist_lua", LUA_MODIFIER_MOTION_NONE)

function bloodseeker_mist_lua:GetCastRange(location, target)
	local radius = self:GetSpecialValueFor("radius")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int8") ~= nil then
		radius = radius + 150
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bloodseeker_str50") ~= nil then
		radius = radius + 200
	end
	return radius
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

function modifier_bloodseeker_mist_aura_lua:IsDebuff()			
	return false 
end

function modifier_bloodseeker_mist_aura_lua:IsHidden() 			
	return false 
end

function modifier_bloodseeker_mist_aura_lua:IsPurgable() 			
	return false 
end

function modifier_bloodseeker_mist_aura_lua:IsPurgeException() 	
	return false 
end

function modifier_bloodseeker_mist_aura_lua:IsAura() 
	return true 
end

function modifier_bloodseeker_mist_aura_lua:GetModifierAura() 
	return "modifier_bloodseeker_mist_debuff" 
end

function modifier_bloodseeker_mist_aura_lua:GetAuraRadius()
	local radius = self:GetSpecialValueFor("radius")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int8") ~= nil then
		radius = radius + 150
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bloodseeker_str50") ~= nil then
		radius = radius + 200
	end
	return radius
end

function modifier_bloodseeker_mist_aura_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_bloodseeker_mist_aura_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_bloodseeker_mist_aura_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_bloodseeker_mist_aura_lua:OnCreated()
	self.caster = self:GetCaster()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if self.caster:FindAbilityByName("npc_dota_hero_bloodseeker_int8") ~= nil then
		self.radius = self.radius + 150
	end
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
	self:AddParticle(particle, false, false, -1, false, false)

	local particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_spray_initial.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_2, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle_2, false, false, -1, false, false)
	EmitSoundOn( "Hero_Boodseeker.Bloodmist", self:GetParent() )
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick"))
end

function modifier_bloodseeker_mist_aura_lua:OnIntervalThink()
	local df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	-- if self.caster:FindAbilityByName("npc_dota_hero_bloodseeker_str10") ~= nil then 
	-- 	df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
	-- end
	local damage = self.caster:GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("self_hit") * self:GetAbility():GetSpecialValueFor("tick")
	ApplyDamage({attacker = self:GetParent(), victim = self.caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = df})
end

function modifier_bloodseeker_mist_aura_lua:OnDestroy()
	if IsServer() then
		if self:GetAbility():GetToggleState() then
			self:GetAbility():ToggleAbility()
		end
	end
end

modifier_bloodseeker_mist_debuff = class({})

function modifier_bloodseeker_mist_debuff:IsDebuff()			
	return true 
end

function modifier_bloodseeker_mist_debuff:IsHidden() 			
	return false 
end

function modifier_bloodseeker_mist_debuff:IsPurgable() 		
	return false 
end

function modifier_bloodseeker_mist_debuff:IsPurgeException() 	
	return false 
end

function modifier_bloodseeker_mist_debuff:OnCreated()
	if IsServer() then
		self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agility_dmg")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int11") ~= nil then
			self.damage = self.damage + self:GetCaster():GetIntellect() * 0.75
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str_last") ~= nil then
			self.damage = self.damage + self:GetCaster():GetStrength() * 1.75
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi8") ~= nil then 
			self.damage = self.damage + self:GetCaster():GetAgility() * 0.5
		end
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick"))
	end
end

function modifier_bloodseeker_mist_debuff:OnIntervalThink()
	ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = self.damage / 5, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end

function modifier_bloodseeker_mist_debuff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return decFuncs
end

function modifier_bloodseeker_mist_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -25
end