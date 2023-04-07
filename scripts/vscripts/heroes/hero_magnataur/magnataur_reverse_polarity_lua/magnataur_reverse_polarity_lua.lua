LinkLuaModifier( "modifier_magnataur_talent_str12", "heroes/hero_magnataur/magnataur_reverse_polarity_lua/modifier_magnataur_talent_str12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_talent_agi6", "heroes/hero_magnataur/magnataur_reverse_polarity_lua/modifier_magnataur_talent_agi6", LUA_MODIFIER_MOTION_NONE )

magnataur_reverse_polarity_lua = {}

function magnataur_reverse_polarity_lua:OnAbilityPhaseStart()
	local radius = self:GetSpecialValueFor( "pull_radius" )
	local castpoint = self:GetCastPoint()

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self:GetCaster()
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( castpoint, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(),
		true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, self:GetCaster():GetForwardVector() )

	self.effect_cast = effect_cast

	EmitSoundOn( "Hero_Magnataur.ReversePolarity.Anim", self:GetCaster() )

	return true
end

function magnataur_reverse_polarity_lua:GetCooldown( level )
	local int8 = self:GetCaster():FindAbilityByName("npc_dota_hero_magnataur_int8")
	if int8 ~= nil and 50 >= RandomInt(1, 100) then
		return 0
	end
	return self.BaseClass.GetCooldown( self, level )
end

function magnataur_reverse_polarity_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect()*3)
    end
end

function magnataur_reverse_polarity_lua:OnAbilityPhaseInterrupted()
	self:StopEffects( true )
end

function magnataur_reverse_polarity_lua:OnSpellStart()
	self:StopEffects( false )

	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor( "pull_radius" )
	local damage = self:GetSpecialValueFor( "polarity_damage" )
	local duration = self:GetSpecialValueFor( "hero_stun_duration" )
	local range = 150

	local agi7 = caster:FindAbilityByName("npc_dota_hero_magnataur_agi7")
	if agi7 ~= nil then
		duration = duration + 1.2
	end
	local int8 = caster:FindAbilityByName("npc_dota_hero_magnataur_int8")
	if int8 ~= nil then
		damage = damage * 1.15
	end
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		local origin = enemy:GetOrigin()
		-- if not enemy:IsRealHero() then
		-- 	local pos = caster:GetOrigin() + caster:GetForwardVector() * range
		-- 	FindClearSpaceForUnit( enemy, pos, true )
		-- end

		enemy:AddNewModifier(
			caster,
			self,
			"modifier_stunned",
			{ duration = duration }
		)

		damageTable.victim = enemy
		ApplyDamage( damageTable )


		local effect_cast = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf",
			PATTACH_ABSORIGIN_FOLLOW,
			enemy
		)
		ParticleManager:SetParticleControl( effect_cast, 1, origin )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		EmitSoundOn( "Hero_Magnataur.ReversePolarity.Stun", enemy )
	end

	EmitSoundOn( "Hero_Magnataur.ReversePolarity.Cast", caster )

	local str12 = caster:FindAbilityByName("npc_dota_hero_magnataur_str_last")
	if str12 ~= nil then
		caster:AddNewModifier(caster, self, "modifier_magnataur_talent_str12", {duration = 30})
	end
	local agi6 = caster:FindAbilityByName("npc_dota_hero_magnataur_agi6")
	if agi6 ~= nil then
		caster:AddNewModifier(caster, self, "modifier_magnataur_talent_agi6", {
			duration = duration,
			chance = 40,
			perc_crit = 160,
		})
	end
end

function magnataur_reverse_polarity_lua:StopEffects( interrupted )
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	StopSoundOn( "Hero_Magnataur.ReversePolarity.Anim", self:GetCaster() )
end