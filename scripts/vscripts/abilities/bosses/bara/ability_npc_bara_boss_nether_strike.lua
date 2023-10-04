ability_npc_bara_boss_nether_strike = class({})
LinkLuaModifier( "modifier_spirit_breaker_nether_strike_lua", "abilities/bosses/bara/ability_npc_bara_boss_nether_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spirit_breaker_nether_strike_lua_cast", "abilities/bosses/bara/ability_npc_bara_boss_nether_strike", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function ability_npc_bara_boss_nether_strike:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context )
	PrecacheResource( "particle", "particles/bara_counder_owerhed.vpcf", context )
end

function ability_npc_bara_boss_nether_strike:Spawn()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Ability Start
function ability_npc_bara_boss_nether_strike:OnSpellStart()
	self:GetCursorTarget():AddNewModifier( self:GetCaster(), self, "modifier_spirit_breaker_nether_strike_lua_cast", {duration = 15.5} )
	self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invulnerable", {duration = 15.5})
	self.mod1 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_disarmed", {duration = 15.5})
end

modifier_spirit_breaker_nether_strike_lua_cast = class({})
--Classifications template
function modifier_spirit_breaker_nether_strike_lua_cast:IsHidden()
	return true
end

function modifier_spirit_breaker_nether_strike_lua_cast:IsDebuff()
	return false
end

function modifier_spirit_breaker_nether_strike_lua_cast:IsPurgable()
	return false
end

function modifier_spirit_breaker_nether_strike_lua_cast:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_spirit_breaker_nether_strike_lua_cast:IsStunDebuff()
	return false
end

function modifier_spirit_breaker_nether_strike_lua_cast:RemoveOnDeath()
	return true
end

function modifier_spirit_breaker_nether_strike_lua_cast:DestroyOnExpire()
	return true
end

function modifier_spirit_breaker_nether_strike_lua_cast:OnCreated(data)
	if not IsServer() then return end
	self:GetCaster():StartGesture(ACT_DOTA_TELEPORT)
	self.sounds = {
		"Dota_Boss.nether_strike_precast",
		"Dota_Boss.nether_strike_first",
		"Dota_Boss.nether_strike_second",
		"Dota_Boss.nether_strike_third",
	}
	self.conter = 1
	EmitGlobalSound(self.sounds[self.conter])
	self:StartIntervalThink(self:GetCaster():GetSoundDuration(self.sounds[self.conter], nil))

	local counter = 9
	local p = ParticleManager:CreateParticle("particles/bara_counder_owerhed.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl( p, 1, Vector( 0, counter, 0 ) )
	Timers:CreateTimer(1,function()
		counter = counter - 1
		if counter < 0 then
			ParticleManager:DestroyParticle( p, false )
			return
		end
		ParticleManager:SetParticleControl( p, 1, Vector( 0, counter, 0 ) )
		return 1
	end)
end

function modifier_spirit_breaker_nether_strike_lua_cast:OnDestroy()
	if not IsServer() then
		return
	end
    self:GetCaster():RemoveGesture(ACT_DOTA_TELEPORT)
end

function modifier_spirit_breaker_nether_strike_lua_cast:OnIntervalThink()
	if not self:GetParent():IsAlive() then
		self:GetAbility().mod:Destroy()
		self:GetAbility().mod1:Destroy()
		self:Destroy()
	end
	self.conter = self.conter + 1
	if self.sounds[self.conter] then
		EmitGlobalSound(self.sounds[self.conter])
	end
	if self.conter > #self.sounds then
		self:GetAbility().mod:Destroy()
		self:GetAbility().mod1:Destroy()
		self:Destroy()
		return
	else
		if self.conter ~= 4 then
			self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.6)
		end
		self:StartIntervalThink(self:GetCaster():GetSoundDuration(self.sounds[self.conter], nil))
	end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local damage = target:GetMaxHealth() * 0.5
	local offset = 54
	-- get direction
	local direction = target:GetOrigin()-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	caster:SetForwardVector( direction )
	-- set pos
	local pos = target:GetOrigin() + direction*offset
	caster:SetOrigin( pos )

	-- proc bash
	local mod = caster:FindModifierByName( "modifier_spirit_breaker_greater_bash_lua" )
	if mod and mod:GetAbility():GetLevel()>0 then
		mod:Bash( target, true, true )
	end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	if self.conter == #self.sounds and target:IsAlive() then
		target:Kill(self:GetAbility(), caster)
	end
	FindClearSpaceForUnit( caster, pos, true )
end












modifier_spirit_breaker_nether_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spirit_breaker_nether_strike_lua:IsHidden()
	return true
end

function modifier_spirit_breaker_nether_strike_lua:IsDebuff()
	return true
end

function modifier_spirit_breaker_nether_strike_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spirit_breaker_nether_strike_lua:OnCreated( kv )
	if not IsServer() then return end
end

function modifier_spirit_breaker_nether_strike_lua:OnRefresh( kv )
	
end

function modifier_spirit_breaker_nether_strike_lua:OnRemoved()
end

function modifier_spirit_breaker_nether_strike_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spirit_breaker_nether_strike_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

function modifier_spirit_breaker_nether_strike_lua:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_spirit_breaker_nether_strike_lua:GetModifierProvidesFOWVision()
	return 1
end

