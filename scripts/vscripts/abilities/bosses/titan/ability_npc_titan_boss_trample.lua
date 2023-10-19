ability_npc_titan_boss_trample = class({})
LinkLuaModifier( "modifier_ability_npc_titan_boss_trample", "abilities/bosses/titan/ability_npc_titan_boss_trample", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function ability_npc_titan_boss_trample:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", context )
end

--------------------------------------------------------------------------------
-- Ability Start
function ability_npc_titan_boss_trample:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ability_npc_titan_boss_trample",{ duration = duration })
end

modifier_ability_npc_titan_boss_trample = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_npc_titan_boss_trample:IsHidden()
	return false
end

function modifier_ability_npc_titan_boss_trample:IsDebuff()
	return false
end

function modifier_ability_npc_titan_boss_trample:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_npc_titan_boss_trample:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.step_distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" )/100

	if not IsServer() then return end

	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()

	-- init data
	self.distance = 0
	self.treshold = 500
	self.currentpos = self.parent:GetOrigin()

	-- Start interval
	self:StartIntervalThink( 0.1 )

	-- Trample
	self:Trample()
end

function modifier_ability_npc_titan_boss_trample:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" )/100
	
end

function modifier_ability_npc_titan_boss_trample:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_ability_npc_titan_boss_trample:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ability_npc_titan_boss_trample:OnIntervalThink()
	local pos = self.parent:GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos

	GridNav:DestroyTreesAroundPoint( pos, self.radius, false )

	if dist>self.treshold then return end

	self.distance = self.distance + dist
	if self.distance > self.step_distance then
		self:Trample()
		self.distance = 0
	end
end

function modifier_ability_npc_titan_boss_trample:Trample()
	local pos = self.parent:GetOrigin()
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),pos,nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)

	local damage = self.base_damage + self.parent:GetAverageTrueAttackDamage(nil)*self.attack_damage

	for _,enemy in pairs(enemies) do
		ApplyDamage({
            victim = enemy,
            attacker = self.parent,
            damage = damage + enemy:GetMaxHealth() * 0.01,
            damage_type = self.abilityDamageType,
            ability = self.ability
        })
		SendOverheadEventMessage(nil,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,enemy,damage,nil)
	end

	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_npc_titan_boss_trample:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_disarm.vpcf"
end

function modifier_ability_npc_titan_boss_trample:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_ability_npc_titan_boss_trample:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", PATTACH_ABSORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )

	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_PrimalBeast.Trample", self.parent )
end