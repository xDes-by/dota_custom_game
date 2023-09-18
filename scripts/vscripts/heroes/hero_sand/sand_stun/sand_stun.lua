sand_stun = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_damage_incoming", "heroes/hero_sand/sand_stun/sand_stun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_caustic_debuff", "heroes/hero_sand/sand_caustic/modifier_sand_caustic_debuff", LUA_MODIFIER_MOTION_NONE )

function sand_stun:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function sand_stun:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor( "stomp_damage" )
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int7") ~= nil then 
		radius = radius + 750
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_str9") ~= nil then 
		damage = damage + self:GetCaster():GetStrength()
	end

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		enemy:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )
		if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int10") ~= nil then 
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_sand_damage_incoming", { duration = stun_duration } )
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int_last") ~= nil then 
		ability2 = self:GetCaster():FindAbilityByName("sand_caustic") 
			if ability2 ~= nil and ability2:IsTrained() then 
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_sand_caustic_debuff", { duration = 5 } )
			end
		end
	end

	self:PlayEffects()
end

function sand_stun:PlayEffects()
	-- get particles
	local particle_cast = "particles/sandking.vpcf"
	local sound_cast = "Hero_Leshrac.Split_Earth"

	-- get data
	local radius = self:GetSpecialValueFor("radius")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int7")
	if abil ~= nil then 
	radius = radius + 750
	end


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_L",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hoof_R",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_sand_damage_incoming = {}

function modifier_sand_damage_incoming:IsHidden()
	return true
end

function modifier_sand_damage_incoming:IsDebuff()
	return false
end

function modifier_sand_damage_incoming:IsPurgable()
	return false
end

function modifier_sand_damage_incoming:DeclareFunctions()
	return { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
end

function modifier_sand_damage_incoming:GetModifierIncomingDamage_Percentage()
	return 50
end