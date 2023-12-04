
modifier_terrorblade_metamorphosis_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_terrorblade_metamorphosis_lua:IsHidden()
	return false
end

function modifier_terrorblade_metamorphosis_lua:IsDebuff()
	return false
end

function modifier_terrorblade_metamorphosis_lua:IsStunDebuff()
	return false
end

function modifier_terrorblade_metamorphosis_lua:IsPurgable()
	return false
end


function modifier_terrorblade_metamorphosis_lua:OnCreated( kv )
if IsServer() then
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_range" )
	sila = 0 
	if self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_str_last") ~= nil then
		local bonus = self:GetAbility():GetCaster():GetMaxHealth()
		damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + bonus * 0.025
		sila = self:GetCaster():GetStrength()
	else
        damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	end
	self.slow = self:GetAbility():GetSpecialValueFor( "speed_loss" )
	local delay = self:GetAbility():GetSpecialValueFor( "transformation_time" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_str10")
	if abil ~= nil then
		sila = self:GetCaster():GetStrength() * 0.5 + sila
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_terrorblade_str50") then
		sila = sila + self:GetCaster():GetStrength() * 2
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int_last") ~= nil then
		damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) * 5
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_agi7")
	if abil ~= nil then
	damage = self:GetCaster():GetAttackDamage() + damage
	end

	self.projectile = 900

	if not IsServer() then return end

	-- self.attack = self:GetParent():GetAttackCapability()
	-- if self.attack == DOTA_UNIT_CAP_RANGED_ATTACK then

	-- 	self.range = 0
	-- 	self.projectile = 0
	-- end
	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

	-- self:GetAbility():SetContextThink(DoUniqueString( "terrorblade_metamorphosis_lua" ), function()
		
	-- end, FrameTime())
	self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_3 )


	self.stun = true
	--self:StartIntervalThink( delay )

	-- play effects
	self:PlayEffects()
	end
end

function modifier_terrorblade_metamorphosis_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_terrorblade_metamorphosis_lua:OnRemoved()
end

function modifier_terrorblade_metamorphosis_lua:OnDestroy()
	if not IsServer() then return end

	-- return attack cap
	self:GetParent():SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_terrorblade_metamorphosis_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_terrorblade_metamorphosis_lua:GetModifierExtraStrengthBonus()
	return sila
end

function modifier_terrorblade_metamorphosis_lua:GetModifierBaseAttack_BonusDamage()
	return damage
end

function modifier_terrorblade_metamorphosis_lua:GetModifierBaseAttackTimeConstant()
	return self.bat
end

function modifier_terrorblade_metamorphosis_lua:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end

function modifier_terrorblade_metamorphosis_lua:GetModifierProjectileSpeedBonus()
	return self.projectile
end

function modifier_terrorblade_metamorphosis_lua:GetModifierAttackRangeBonus()
	return self.range
end

function modifier_terrorblade_metamorphosis_lua:GetModifierModelChange()
	return "models/heroes/terrorblade/demon.vmdl"
end

function modifier_terrorblade_metamorphosis_lua:GetModifierModelScale()
	return 20
end

function modifier_terrorblade_metamorphosis_lua:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end

function modifier_terrorblade_metamorphosis_lua:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_terrorblade_metamorphosis_lua:GetModifierHealthRegenPercentage()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_terrorblade_str50") then
		return 10
	end
end

--------------------------------------------------------------------------------
--[[ Status Effects
function modifier_terrorblade_metamorphosis_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.stun,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_terrorblade_metamorphosis_lua:OnIntervalThink()
	self.stun = false
end
]]
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_terrorblade_metamorphosis_lua:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_terrorblade_metamorphosis_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_terrorblade_metamorphosis_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf"
	local sound_cast = "Hero_Terrorblade.Metamorphosis"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end