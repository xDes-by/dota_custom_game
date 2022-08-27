modifier_mars_lil = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_lil:IsHidden()
	return false
end

function modifier_mars_lil:IsDebuff()
	return false
end

function modifier_mars_lil:IsStunDebuff()
	return false
end

function modifier_mars_lil:IsPurgable()
	return true
end

function modifier_mars_lil:OnCreated( kv )
	self.caster = self:GetCaster()
	self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )

	self.slow = self:GetAbility():GetSpecialValueFor( "loss_duration" )

	if not IsServer() then return end
	
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_mars_agi11")
		if abil ~= nil then 
		self.attacks = self.attacks + 5
		end
	
	self:SetStackCount( self.attacks )

	self.records = {}

	-- play Effects & Sound
	self:PlayEffects()
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_mars_lil:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )

	self.slow = self:GetAbility():GetSpecialValueFor( "loss_duration" )

	if not IsServer() then return end
	
		local abil = self.caster:FindAbilityByName("special_bonus_unique_mars_custom")
		if abil ~= nil and abil:IsTrained()	then 
		self.attacks = self.attacks + 10
		end
	
	self:SetStackCount( self.attacks )

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_mars_lil:OnRemoved()
end

function modifier_mars_lil:OnDestroy()
	if not IsServer() then return end

	-- stop sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_lil:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_mars_lil:OnAttack( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetStackCount()<=0 then return end

	-- record attack
	self.records[params.record] = true

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- decrement stack
	if self:GetStackCount()>0 then
		self:DecrementStackCount()
	end
end

function modifier_mars_lil:OnAttackLanded( params )
	if self.records[params.record] then
		-- add modifier
		params.target:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_mars_lil_debuff", -- modifier name
			{ duration = self.slow } -- kv
		)
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int_last") ~= nil and RandomInt(1, 10) == 1 and params.attacker:FindAbilityByName("mars_gods_rebuke_lua") ~= nil and self:GetCaster():FindModifierByName("modifier_mars_lil") ~= nil then
		if params.attacker:FindAbilityByName("mars_gods_rebuke_lua"):IsTrained() then
			params.attacker:FindAbilityByName("mars_gods_rebuke_lua"):OnSpellStart()
		end
	end
	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Target"
	EmitSoundOn( sound_cast, params.target )
end

function modifier_mars_lil:OnAttackRecordDestroy( params )
	if self.records[params.record] then
		self.records[params.record] = nil

		-- if table is empty and no stack left, destroy
		if next(self.records)==nil and self:GetStackCount()<=0 then
			self:Destroy()
		end
	end
end

function modifier_mars_lil:GetModifierProjectileName()
	if self:GetStackCount()<=0 then return end
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end

function modifier_mars_lil:GetModifierPreAttack_BonusDamage()
	if self:GetStackCount()<=0 then return end
	return self.damage
end

function modifier_mars_lil:GetModifierAttackRangeBonus()
	if self:GetStackCount()<=0 then return end
	return self.range_bonus
end

function modifier_mars_lil:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount()<=0 then return end
	return self.as_bonus
end

function modifier_mars_lil:GetModifierBaseAttackTimeConstant()
	if self:GetStackCount()<=0 then return end
	return self.bat
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_mars_lil:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end