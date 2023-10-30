modifier_dawnbreaker_starbreaker_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dawnbreaker_starbreaker_lua:IsHidden()
	return false
end

function modifier_dawnbreaker_starbreaker_lua:IsDebuff()
	return false
end

function modifier_dawnbreaker_starbreaker_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_dawnbreaker_starbreaker_lua:OnCreated( kv )
	self.parent = self:GetParent()

	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	-- references
	self.swipe_radius = self:GetAbility():GetSpecialValueFor( "swipe_radius" )
	self.swipe_damage = self:GetAbility():GetSpecialValueFor( "swipe_damage" )
	self.swipe_duration = self:GetAbility():GetSpecialValueFor( "sweep_stun_duration" )

	self.smash_radius = self:GetAbility():GetSpecialValueFor( "smash_radius" )
	self.smash_damage = self:GetAbility():GetSpecialValueFor( "smash_damage" )
	self.smash_duration = self:GetAbility():GetSpecialValueFor( "smash_stun_duration" )
	self.smash_distance = self:GetAbility():GetSpecialValueFor( "smash_distance_from_hero" )

	self.selfstun = self:GetAbility():GetSpecialValueFor( "self_stun_duration" )
	self.attacks = self:GetAbility():GetSpecialValueFor( "total_attacks" )
	self.speed = self:GetAbility():GetSpecialValueFor( "movement_speed" )

	self.tree_radius = 100
	self.arc_height = 90
	self.arc_duration = 0.4

	if not IsServer() then return end

	self.forward = Vector( kv.x, kv.y, 0 )
	self.bonus = self.swipe_damage
	self.ctr = 0
	local interval = self.duration/(self.attacks-1)
	
	self.parent:SetForwardVector(self.forward)
	self.parent:FaceTowards( self.forward)
	-- apply forward motion
	self:ApplyHorizontalMotionController()

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_dawnbreaker_starbreaker_lua:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
end

function modifier_dawnbreaker_starbreaker_lua:RecalculateDirection(point)
	local direction = point-self.parent:GetOrigin()
	if direction:Length2D() < 1 then
		direction = self.parent:GetForwardVector()
	else
		direction.z = 0
		direction = direction:Normalized()
	end
	self.forward = direction
	self.parent:SetForwardVector(self.forward)
	self.parent:FaceTowards( self.forward)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dawnbreaker_starbreaker_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SUPPRESS_CLEAVE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_dawnbreaker_starbreaker_lua:GetOverrideAnimation( params )
	return ACT_DOTA_OVERRIDE_ABILITY_1
end

function modifier_dawnbreaker_starbreaker_lua:GetModifierPreAttack_BonusDamage()
	if not IsServer() then return 0 end
	return self.bonus
end

function modifier_dawnbreaker_starbreaker_lua:GetSuppressCleave()
	return 1
end

function modifier_dawnbreaker_starbreaker_lua:OnOrder(data)
	if data.unit~=self.parent then return end
	if data.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or DOTA_UNIT_ORDER_MOVE_TO_DIRECTION then
		self:RecalculateDirection(data.new_pos)
	elseif data.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or DOTA_UNIT_ORDER_ATTACK_TARGET then
		self:RecalculateDirection(data.target:GetOrigin())
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_dawnbreaker_starbreaker_lua:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dawnbreaker_starbreaker_lua:OnIntervalThink()
	-- if stunned, destroy
	if self.parent:IsStunned() then
		self:Destroy()
		return
	end

	self.ctr = self.ctr + 1
	if self.ctr>=self.attacks then
		self:Smash()
	else
		self:Swipe()
	end
end

function modifier_dawnbreaker_starbreaker_lua:Swipe()
	-- find enemies
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),self.parent:GetOrigin(),nil,self.swipe_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

	for _,enemy in pairs(enemies) do
		-- attack
		-- self.bonus = self.swipe_damage
		self.parent:PerformAttack( enemy, true, true, true, true, false, false, true )

		-- slow
		if not enemy:IsMagicImmune() then
			enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_dawnbreaker_starbreaker_lua_slow", { duration = self.swipe_duration })
		end
	end

	-- increment luminosity stack
	if #enemies>0 then
		local mod1 = self.parent:FindModifierByName( "modifier_dawnbreaker_luminosity_lua" )
		if mod1 then
			mod1:Increment()
		end
	end

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_dawnbreaker_starbreaker_lua:Smash()
	local center = self.parent:GetOrigin() + self.forward*self.smash_distance

	-- find enemies
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),center,nil,self.smash_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

	for _,enemy in pairs(enemies) do
		-- attack
		-- self.bonus = self.smash_damage
		self.parent:PerformAttack( enemy, true, true, true, true, false, false, true )

		-- stun
		if not enemy:IsMagicImmune() then
			enemy:AddNewModifier(self.parent,self:GetAbility(),"modifier_generic_stunned_lua",{ duration = self.smash_duration })
			enemy:AddNewModifier(self.parent,self:GetAbility(),"modifier_generic_arc_lua",{duration = self.arc_duration,height = self.arc_height,activity = ACT_DOTA_FLAIL,})
		end
	end

	self.parent:AddNewModifier(self.parent,self:GetAbility(),"modifier_generic_stunned_lua",{ duration = self.selfstun })

	-- increment luminosity stack
	if #enemies>0 then
		local mod1 = self.parent:FindModifierByName( "modifier_dawnbreaker_luminosity_lua" )
		if mod1 then
			mod1:Increment()
		end
	end

	-- play effects
	self:PlayEffects3( center )
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_dawnbreaker_starbreaker_lua:UpdateHorizontalMotion( me, dt )
	-- get forward pos
    local pos = me:GetOrigin() + self.forward * self.speed * dt

    -- if not traversable, stop
    if not GridNav:IsTraversable( pos ) then return end

    -- destroy trees
    GridNav:DestroyTreesAroundPoint( me:GetOrigin(), self.tree_radius, true )

    pos = GetGroundPosition( pos, me )
    me:SetOrigin( pos )
end

function modifier_dawnbreaker_starbreaker_lua:OnHorizontalMotionInterrupted()
	self:ApplyHorizontalMotionController()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dawnbreaker_starbreaker_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_cast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_dawnbreaker_starbreaker_lua:PlayEffects2()
	local forward = RotatePosition( Vector(0,0,0), QAngle( 0, -120, 0 ), self.forward )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(effect_cast,1,self.parent,PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)
	ParticleManager:SetParticleControlForward( effect_cast, 0, forward )

	-- buff particle
	self:AddParticle(effect_cast,false,false,-1,false,false)

	-- Create Sound
	EmitSoundOn( "Hero_Dawnbreaker.Fire_Wreath.Sweep", self.parent )
end

function modifier_dawnbreaker_starbreaker_lua:PlayEffects3( center )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf", PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, center )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( "Hero_Dawnbreaker.Fire_Wreath.Smash", self.parent )
end