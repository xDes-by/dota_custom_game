LinkLuaModifier( "modifier_magnataur_talent_str12", "heroes/hero_magnataur/magnataur_reverse_polarity_lua/modifier_magnataur_talent_str12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_talent_agi6", "heroes/hero_magnataur/magnataur_reverse_polarity_lua/modifier_magnataur_talent_agi6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_magnataur_str50", "heroes/hero_magnataur/magnataur_reverse_polarity_lua/magnataur_reverse_polarity_lua", LUA_MODIFIER_MOTION_NONE )

magnataur_reverse_polarity_lua = {}

function magnataur_reverse_polarity_lua:OnAbilityPhaseStart()
	local radius = self:GetSpecialValueFor( "pull_radius" )
	local castpoint = self:GetCastPoint()

	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( castpoint, 0, 0 ) )
	ParticleManager:SetParticleControlEnt(effect_cast,3,self:GetCaster(),PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(),true)
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
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
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
	local special_bonus_unique_npc_dota_hero_magnataur_str50 = caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_magnataur_str50")
	if special_bonus_unique_npc_dota_hero_magnataur_str50 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_npc_dota_hero_magnataur_str50", {duration = 90})
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

modifier_special_bonus_unique_npc_dota_hero_magnataur_str50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:RemoveOnDeath()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:DestroyOnExpire()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:GetModifierBonusStats_Strength()
	return 500 * self:GetAbility():GetLevel()
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:GetModifierBonusStats_Agility()
	return 500 * self:GetAbility():GetLevel()
end

function modifier_special_bonus_unique_npc_dota_hero_magnataur_str50:GetModifierBonusStats_Intellect()
	return 500 * self:GetAbility():GetLevel()
end