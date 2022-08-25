sand_stun = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_damage_incoming", "heroes/hero_sand/sand_stun/sand_stun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_caustic_debuff", "heroes/hero_sand/sand_caustic/modifier_sand_caustic_debuff", LUA_MODIFIER_MOTION_NONE )

function sand_stun:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return caster:GetIntellect()
    end
end

function sand_stun:OnSpellStart()
	-- get references
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor( "stomp_damage" )
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int7")
	if abil ~= nil then 
	radius = radius + 750
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_str9")             --- урон на время кола от силы
	if abil ~= nil then 
	damage = self:GetCaster():GetStrength()
	end

	-- find affected units
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- Apply stun debuff
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int_last")             --- урон на время кола от силы
		if abil ~= nil then 
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_sand_damage_incoming", { duration = stun_duration } )
		end
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int10")             --- урон на время кола от силы
		if abil ~= nil then 
		ability2 = self:GetCaster():FindAbilityByName("sand_caustic") 
			if ability2 ~= nil and ability2:IsTrained() then 
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_sand_caustic_debuff", { duration = 5 } )
			end
		end
	end

	-- Play effects
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
	return 30
end