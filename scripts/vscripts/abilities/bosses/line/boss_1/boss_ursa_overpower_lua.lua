boss_ursa_overpower_lua = class({})
LinkLuaModifier( "modifier_boss_ursa_overpower_lua", "abilities/bosses/line/boss_1/boss_ursa_overpower_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_ursa_overpower_lua:OnSpellStart()
	-- get references
	local bonus_duration = self:GetDuration()

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_boss_ursa_overpower_lua",
		{ duration = bonus_duration }
	)

	-- Play effects
	self:PlayEffects()
end

function boss_ursa_overpower_lua:PlayEffects()
	-- get resources
	local sound_cast = "Hero_Ursa.Overpower"

	-- play particles

	-- play sounds
	EmitSoundOn(sound_cast, self:GetCaster())
end

----------------------------------------------------------------------------------------------

modifier_boss_ursa_overpower_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_ursa_overpower_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_ursa_overpower_lua:OnCreated( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

	-- Increase stack

	if IsServer() then
		self:SetStackCount(self.max_attacks)

		self:AddEffects()
	end
end

function modifier_boss_ursa_overpower_lua:OnRefresh( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

	-- Increase stack
	if IsServer() then
		self:SetStackCount(self.max_attacks)
	end
end

function modifier_boss_ursa_overpower_lua:OnDestroy( kv )
	if IsServer() then
		self:RemoveEffects()
	end
end
--------------------------------------------------------------------------------

function modifier_boss_ursa_overpower_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_ursa_overpower_lua:GetModifierAttackSpeedBonus_Constant()
	return self.bonus
end

function modifier_boss_ursa_overpower_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- decrement stack
		self:DecrementStackCount()

		-- destroy if reach zero
		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_boss_ursa_overpower_lua:AddEffects()
	-- get resources
	local particle_buff = "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"

	-- Create particle
	self.effect_cast = ParticleManager:CreateParticle( particle_buff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt( self.effect_cast, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
	
	-- Apply particle
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end

function modifier_boss_ursa_overpower_lua:RemoveEffects()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end