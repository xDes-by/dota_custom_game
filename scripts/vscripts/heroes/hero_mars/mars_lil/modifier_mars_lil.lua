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
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_agi11") ~= nil then 
		self.attacks = self.attacks + 5
	end
	
	self:SetStackCount( self.attacks )

	self.records = {}

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
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_agi11") ~= nil then 
		self.attacks = self.attacks + 5
	end
	
	self:SetStackCount( self.attacks )
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_mars_lil:OnRemoved()
end

function modifier_mars_lil:OnDestroy()
	if not IsServer() then return end
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_lil:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_mars_lil:OnAttack( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetStackCount()<=0 then return end

	self.records[params.record] = true

	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )

	if self:GetStackCount()>0 then
		self:DecrementStackCount()
	end
end

function modifier_mars_lil:OnAttackLanded( params )
	if self.records[params.record] then
		params.target:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_mars_lil_debuff", -- modifier name
			{ duration = self.slow } -- kv
		)
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_mars_int50") then
			ApplyDamage( {
				victim = params.target,
				attacker = self:GetCaster(),
				damage = self:GetCaster():GetIntellect() / 2,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE
			})
		end
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int_last") ~= nil and RandomInt(1, 100) <= 10 and params.attacker:FindAbilityByName("mars_gods_rebuke_lua") ~= nil and self:GetCaster():FindModifierByName("modifier_mars_lil") ~= nil then
		if params.attacker:FindAbilityByName("mars_gods_rebuke_lua"):IsTrained() then
			params.attacker:FindAbilityByName("mars_gods_rebuke_lua"):OnSpellStart()
		end
	end
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
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast,3,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,4,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,5,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	self:AddParticle(effect_cast,false,false,-1,false,false)
end