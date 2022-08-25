LinkLuaModifier("modifier_boss_6_armor", "abilities/bosses/line/boss_6/boss_6_armor", LUA_MODIFIER_MOTION_NONE)

boss_6_armor = class({})

function boss_6_armor:GetIntrinsicModifierName()
	return "modifier_boss_6_armor"
end

---------------------------------------------

modifier_boss_6_armor = class({})

function modifier_boss_6_armor:IsHidden()
	return true
end

function modifier_boss_6_armor:IsDebuff()
	return false
end

function modifier_boss_6_armor:IsPurgable()
	return false
end

function modifier_boss_6_armor:AllowIllusionDuplicate()
	return true
end

function modifier_boss_6_armor:OnCreated( kv )
	self.parent = self:GetParent()
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_cleanse" )
	self.reset = self:GetAbility():GetSpecialValueFor( "damage_reset_interval" )

	if not IsServer() then return end
	self.damage = 0
end

function modifier_boss_6_armor:OnRefresh( kv )
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_cleanse" )
	self.reset = self:GetAbility():GetSpecialValueFor( "damage_reset_interval" )
end

function modifier_boss_6_armor:OnRemoved()
end

function modifier_boss_6_armor:OnDestroy()
end


function modifier_boss_6_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_boss_6_armor:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self.parent then return end
	if self.parent:PassivesDisabled() then return end

	if not params.attacker:GetPlayerOwner() then return end

	self:StartIntervalThink( self.reset )

	self.damage = self.damage + params.damage
	if self.damage < self.purge then return end
	self.damage = 0

	self.parent:Purge( false, true, false, true, true )

	self:PlayEffects()
end


function modifier_boss_6_armor:OnIntervalThink()
	self:StartIntervalThink( -1 )
	self.damage = 0
end


function modifier_boss_6_armor:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf"
	local sound_cast = "Hero_Tidehunter.KrakenShell"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self.parent )
end