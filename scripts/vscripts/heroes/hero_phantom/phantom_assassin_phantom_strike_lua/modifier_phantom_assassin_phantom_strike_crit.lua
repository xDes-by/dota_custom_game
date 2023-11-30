modifier_phantom_assassin_phantom_strike_crit = class({})

function modifier_phantom_assassin_phantom_strike_crit:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_phantom_assassin_phantom_strike_crit:IsPurgable()
	return false
end


function modifier_phantom_assassin_phantom_strike_crit:OnCreated( kv )
	local caster = self:GetCaster()
	self.crit_chance = 100
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )
	stats = 0
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_str10")
		if abil ~= nil then
		stats = self:GetCaster():GetStrength() * 2
		end
end

function modifier_phantom_assassin_phantom_strike_crit:OnRefresh( kv )
	-- references
	self.crit_chance = 100
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )
end

function modifier_phantom_assassin_phantom_strike_crit:OnDestroy( kv )

end

function modifier_phantom_assassin_phantom_strike_crit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_phantom_assassin_phantom_strike_crit:GetModifierBonusStats_Strength( params )	
	return stats
end

function modifier_phantom_assassin_phantom_strike_crit:GetModifierBonusStats_Agility( params )	
	return stats
end

function modifier_phantom_assassin_phantom_strike_crit:GetModifierBonusStats_Intellect( params )	
	return stats
end

function modifier_phantom_assassin_phantom_strike_crit:GetModifierAttackSpeedBonus_Constant( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi8")
		if abil ~= nil then
		return 200
		else
		return 0
		end
	end
end

function modifier_phantom_assassin_phantom_strike_crit:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:RollChance( self.crit_chance ) then
			self.record = params.record
			return self.crit_bonus
		end
	end
end

function modifier_phantom_assassin_phantom_strike_crit:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_phantom_assassin_phantom_strike_crit:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_phantom_assassin_phantom_strike_crit:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

	-- if target:IsMechanical() then
	-- 	particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	-- 	sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
	-- end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end

