modifier_dazzle_poison_touch_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dazzle_poison_touch_lua:IsHidden()
	return false
end

function modifier_dazzle_poison_touch_lua:IsDebuff()
	return true
end

function modifier_dazzle_poison_touch_lua:IsStunDebuff()
	return false
end

function modifier_dazzle_poison_touch_lua:IsPurgable()
	return true
end

function modifier_dazzle_poison_touch_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dazzle_poison_touch_lua:OnCreated( kv )
	if IsClient() then
		return
	end
	self.caster = self:GetCaster()
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	self.duration = kv.duration

	damage_type = DAMAGE_TYPE_PHYSICAL
	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_int6") ~= nil then 
		damage_type = DAMAGE_TYPE_MAGICAL
		damage_flags = DOTA_DAMAGE_FLAG_NONE
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str11") ~= nil	then 
		damage = self:GetCaster():GetMaxHealth()*0.02
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str_last") ~= nil then
		damage = damage + math.floor(self:GetCaster():GetMaxHealth()*0.05)
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dazzle_str50") ~= nil then
		damage = damage + math.floor(self:GetCaster():GetMaxHealth()*0.08)
	end
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = damage_type,
		ability = self:GetAbility(), --Optional.
		damage_flags = damage_flags,
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 1 )
	self:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dazzle_poison_touch_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_dazzle_poison_touch_lua:OnAttackLanded( params )
	if not IsServer() then return end
	if params.target~=self:GetParent() then return end

	-- refresh duration
	self:SetDuration( self.duration, true )
end

function modifier_dazzle_poison_touch_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_dazzle_poison_touch_lua:GetModifierDamageOutgoing_Percentage()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_agi10")
	if abil ~= nil	then 
		return -20
	end
	return 0
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dazzle_poison_touch_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )

	-- Play effects
	local sound_cast = "Hero_Dazzle.Poison_Tick"
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dazzle_poison_touch_lua:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf"
end

function modifier_dazzle_poison_touch_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dazzle_poison_touch_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_dazzle_copy.vpcf"
end

-- function modifier_dazzle_poison_touch_lua:PlayEffects()
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
-- 	local sound_cast = "string"

-- 	-- Get Data

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
-- 	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
-- 	ParticleManager:SetParticleControlEnt(
-- 		effect_cast,
-- 		iControlPoint,
-- 		hTarget,
-- 		PATTACH_NAME,
-- 		"attach_name",
-- 		vOrigin, -- unknown
-- 		bool -- unknown, true
-- 	)
-- 	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
-- 	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- buff particle
-- 	self:AddParticle(
-- 		effect_cast,
-- 		false, -- bDestroyImmediately
-- 		false, -- bStatusEffect
-- 		-1, -- iPriority
-- 		false, -- bHeroEffect
-- 		false -- bOverheadEffect
-- 	)

-- 	-- Create Sound
-- 	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
-- 	EmitSoundOn( sound_target, target )
-- end