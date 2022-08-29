boss_3_frost_blast = class({})
LinkLuaModifier( "modifier_boss_3_frost_blast", "abilities/bosses/line/boss_3/boss_3_frost_blast", LUA_MODIFIER_MOTION_NONE )

function boss_3_frost_blast:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function boss_3_frost_blast:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetDuration()
	local damage_aoe = self:GetSpecialValueFor("aoe_damage")
	local radius = self:GetSpecialValueFor("radius")

	-- get enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damageTable = {
		attacker = caster,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
	}

	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		damageTable.damage = enemy:GetMaxHealth()*damage_aoe/100
		ApplyDamage( damageTable )
		
		self:PlayEffects( enemy, radius )
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_boss_3_frost_blast", -- modifier name
			{ duration = duration } -- kv
		)
	end	
end

function boss_3_frost_blast:PlayEffects( target, radius )
	local particle_cast = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
	local sound_target = "Ability.FrostNova"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_target, target )
end


----------------------------------------------------------------------------------------

modifier_boss_3_frost_blast = class({})

function modifier_boss_3_frost_blast:IsHidden()
	return false
end

function modifier_boss_3_frost_blast:IsDebuff()
	return true
end

function modifier_boss_3_frost_blast:IsPurgable()
	return true
end

function modifier_boss_3_frost_blast:OnCreated( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_boss_3_frost_blast:OnRefresh( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_boss_3_frost_blast:OnDestroy( kv )

end

function modifier_boss_3_frost_blast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_boss_3_frost_blast:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end
function modifier_boss_3_frost_blast:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_boss_3_frost_blast:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end