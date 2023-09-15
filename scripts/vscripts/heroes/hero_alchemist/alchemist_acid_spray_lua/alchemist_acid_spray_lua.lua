LinkLuaModifier( "modifier_alchemist_acid_spray_lua", "heroes/hero_alchemist/alchemist_acid_spray_lua/alchemist_acid_spray_lua", LUA_MODIFIER_MOTION_NONE )

alchemist_acid_spray_lua = class({})

function alchemist_acid_spray_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function alchemist_acid_spray_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function alchemist_acid_spray_lua:GetAbilityDamageType()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int7")	
	if abil ~= nil then 
		return DAMAGE_TYPE_MAGICAL
	end
	return DAMAGE_TYPE_PHYSICAL
end

function alchemist_acid_spray_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor( "duration" )

	CreateModifierThinker( caster, self, "modifier_alchemist_acid_spray_lua", { duration = duration }, point, caster:GetTeamNumber(), false )
end

----------------------------------------------------------------------------------

modifier_alchemist_acid_spray_lua = class({})

function modifier_alchemist_acid_spray_lua:IsHidden()
	return false
end

function modifier_alchemist_acid_spray_lua:IsDebuff()
	return true
end

function modifier_alchemist_acid_spray_lua:IsStunDebuff()
	return false
end

function modifier_alchemist_acid_spray_lua:IsPurgable()
	return false
end

function modifier_alchemist_acid_spray_lua:OnCreated( kv )
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int8")	
	if abil ~= nil then 
		damage = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi7")	
	if abil ~= nil then 
		damage = self:GetCaster():GetAgility()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str7")	
	if abil ~= nil then 
		damage = self:GetCaster():GetStrength()
	end

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end
	
	self.damage_type = DAMAGE_TYPE_PHYSICAL
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int7")	
	if abil ~= nil then 
		self.damage_type = DAMAGE_TYPE_MAGICAL
	end

	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self.damage_type,
		ability = self:GetAbility(),
	}
	self:StartIntervalThink( interval )

	self.sound_cast = "Hero_Alchemist.AcidSpray.Damage"
	
	self:PlayEffects()
end

function modifier_alchemist_acid_spray_lua:OnRefresh( kv )
	
end

function modifier_alchemist_acid_spray_lua:OnRemoved()
end

function modifier_alchemist_acid_spray_lua:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

function modifier_alchemist_acid_spray_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
	return funcs
end

function modifier_alchemist_acid_spray_lua:GetModifierMiss_Percentage()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str11")	
	if abil ~= nil then 
		return 25
	end
	return 0
end

function modifier_alchemist_acid_spray_lua:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str_last")	
	if abil ~= nil then 
		return self.armor * 5
	end
	return self.armor
end

function modifier_alchemist_acid_spray_lua:GetModifierMoveSpeedBonus_Percentage()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str8")	
	if abil ~= nil then 
		return -50
	end
	return 0
end

function modifier_alchemist_acid_spray_lua:OnIntervalThink()
if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		EmitSoundOn( self.sound_cast, enemy )
	end
end

function modifier_alchemist_acid_spray_lua:IsAura()
	return self.thinker
end

function modifier_alchemist_acid_spray_lua:GetModifierAura()
	return "modifier_alchemist_acid_spray_lua"
end

function modifier_alchemist_acid_spray_lua:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_lua:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_alchemist_acid_spray_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_lua:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_lua:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_alchemist_acid_spray_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_alchemist_acid_spray_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
	local sound_cast = "Hero_Alchemist.AcidSpray"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	EmitSoundOn( sound_cast, self:GetParent() )
end