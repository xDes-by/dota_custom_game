ability_npc_bara_boss_charge = class({})
LinkLuaModifier( "modifier_spirit_breaker_charge_of_darkness_lua", "abilities/bosses/bara/ability_npc_bara_boss_charge", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_spirit_breaker_charge_of_darkness_lua_debuff", "abilities/bosses/bara/ability_npc_bara_boss_charge", LUA_MODIFIER_MOTION_NONE )

function ability_npc_bara_boss_charge:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_spirit_breaker_charge_of_darkness_lua", {target = self:GetCursorTarget():entindex()})
end

modifier_spirit_breaker_charge_of_darkness_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spirit_breaker_charge_of_darkness_lua:IsHidden()
	return false
end

function modifier_spirit_breaker_charge_of_darkness_lua:IsDebuff()
	return false
end

function modifier_spirit_breaker_charge_of_darkness_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spirit_breaker_charge_of_darkness_lua:OnCreated( kv )
	self.parent = self:GetParent()
	EmitSoundOn("Dota_Boss.bara_start_charge", self.parent)

	-- references
	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "bash_radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

	if not IsServer() then return end

	self.target = EntIndexToHScript( kv.target )
	self.direction = self:GetParent():GetForwardVector()
	self.targets = {}

	self.search_radius = 4000
	self.tree_radius = 150
	self.min_dist = 150
	self.offset = 20
	self.interrupted = false

	-- check ability
	self.mod = self.parent:FindModifierByName( "modifier_spirit_breaker_greater_bash_lua" )
	if self.mod and self.mod:GetAbility():GetLevel()<1 then
		self.mod = nil
	end

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	-- set target
	self:SetTarget( self.target )

	-- set ability as inactive
	self:GetAbility():SetActivated( false )

	-- play effects
	-- local sound_cast = "Hero_Spirit_Breaker.ChargeOfDarkness"
	-- EmitSoundOn( sound_cast, self.parent )
end

function modifier_spirit_breaker_charge_of_darkness_lua:OnDestroy()
	if not IsServer() then return end
	StopSoundOn("bara_start_charge", self.parent)
	StopSoundOn("bara_start_charge_alt", self.parent)

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, true )

	self:GetParent():RemoveHorizontalMotionController( self )

	-- remove debuff
	if self.debuff and (not self.debuff:IsNull()) then
		self.debuff:Destroy()
	end

	-- set ability as inactive
	self:GetAbility():SetActivated( true )

	-- start cooldown
	self:GetAbility():UseResources( false, false, false, true )


	if self.interrupted then return end
	
	-- bash
	if self.mod and (not self.mod:IsNull()) then
		self.mod:Bash( self.target, false )
	end

	self.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_stunned", { duration = self.duration })

	if self.target:IsAlive() then
		ExecuteOrderFromTable( {
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.target:entindex(),
		} )
	end

	EmitSoundOn( "Hero_Spirit_Breaker.Charge.Impact", self.target )
end

function modifier_spirit_breaker_charge_of_darkness_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_spirit_breaker_charge_of_darkness_lua:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_spirit_breaker_charge_of_darkness_lua:GetModifierIgnoreMovespeedLimit()
	return 1
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_spirit_breaker_charge_of_darkness_lua:UpdateHorizontalMotion( me, dt )
	-- bash logic
	self:BashLogic()

	-- cancel logic
	self:CancelLogic()

	-- get direction
	local direction = self.target:GetOrigin()-me:GetOrigin()
	local dist = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()

	-- check if near
	if dist<self.min_dist then
		self:Destroy()
		return
	end

	-- set target pos
	local pos = me:GetOrigin() + direction * me:GetIdealSpeed() * dt
	pos = GetGroundPosition( pos, me )

	me:SetOrigin( pos )
	self.direction = direction

	-- face towards
	self.parent:FaceTowards( self.target:GetOrigin() )
end

function modifier_spirit_breaker_charge_of_darkness_lua:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_spirit_breaker_charge_of_darkness_lua:BashLogic()
	-- check modifier
	if (not self.mod) or self.mod:IsNull() then return end

	local loc = self.parent:GetOrigin() + self.direction * self.offset

	-- find units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		loc,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		if not self.targets[enemy] then
			self.targets[enemy] = true

			-- apply bash
			self.mod:Bash( enemy, 0, false )
		end
	end
end

function modifier_spirit_breaker_charge_of_darkness_lua:CancelLogic()
	-- check stun
	local check = self.parent:IsHexed() or self.parent:IsStunned() or self.parent:IsRooted()
	if check then
		self.interrupted = true
		self:Destroy()
	end

	-- check if target is dead
	if not self.target:IsAlive() then
		-- find another valid target
		local enemies = FindUnitsInRadius(
			self.parent:GetTeamNumber(),	-- int, your team number
			self.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		if #enemies<1 then
			self.interrupted = true
			self:Destroy()
			return
		else
			self:SetTarget( enemies[1] )
		end
	end
end

function modifier_spirit_breaker_charge_of_darkness_lua:SetTarget( target )
	if self.debuff and (not self.debuff:IsNull()) then
		self.debuff:Destroy()
	end
	self.target = target
	self.targets[target] = true
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_spirit_breaker_charge_of_darkness_lua:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
end

function modifier_spirit_breaker_charge_of_darkness_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_spirit_breaker_charge_of_darkness_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spirit_breaker_charge_of_darkness_lua_debuff:IsHidden()
	return true
end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:IsDebuff()
	return true
end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spirit_breaker_charge_of_darkness_lua_debuff:OnCreated( kv )
	if not IsServer() then return end
	self:PlayEffects()
end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:OnRefresh( kv )
	
end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:OnRemoved()
end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spirit_breaker_charge_of_darkness_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:OnAttack( params )

end

function modifier_spirit_breaker_charge_of_darkness_lua_debuff:GetModifierProvidesFOWVision()
	return 1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_spirit_breaker_charge_of_darkness_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_spirit_breaker_charge_of_darkness_lua_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )

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