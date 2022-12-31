
hoodwink_sharpshooter_lua = class({})
LinkLuaModifier( "modifier_hoodwink_sharpshooter_lua", "heroes/hero_hoodwink/hoodwink_sharpshooter", LUA_MODIFIER_MOTION_NONE )

function hoodwink_sharpshooter_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hoodwink.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_target.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
end

function hoodwink_sharpshooter_lua:OnSpellStart()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor( "misfire_time" )

	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if point == caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end

	local sec_ability = caster:FindAbilityByName( "hoodwink_sharpshooter_release_lua" )
	if not sec_ability then
		sec_ability = caster:AddAbility( "hoodwink_sharpshooter_release_lua" )
	end
	sec_ability:SetLevel( self:GetLevel() )

	-- add modifier
	caster:AddNewModifier(caster, self, "modifier_hoodwink_sharpshooter_lua", {duration = duration, x = point.x, y = point.y})
end

function hoodwink_sharpshooter_lua:OnProjectileThink_ExtraData( location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )
	if not sound or sound:IsNull() then return end
	sound:SetOrigin( location )
end

function hoodwink_sharpshooter_lua:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target or target:IsNull() then return end
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	
	-- modifier
	-- it also breaks
	target:AddNewModifier(caster, self, "modifier_hoodwink_sharpshooter_debuff", {duration = ExtraData.duration, x = ExtraData.x, y = ExtraData.y})
	
	-- damage
	local damage_table = {
		victim = target,
		attacker = caster,
		damage = ExtraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	}
	ApplyDamage(damage_table)

	if not target:IsRealHero() then return false end		-- pass through the creeps

	-- particles
	local direction = Vector( ExtraData.x, ExtraData.y, 0 ):Normalized()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Target", target )

	-- overhead damage info
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, ExtraData.damage, caster:GetPlayerOwner())
	
	-- stop projectile sound
	local sound = EntIndexToHScript( ExtraData.sound )
	if sound and not sound:IsNull() then
		StopSoundOn( "Hero_Hoodwink.Sharpshooter.Projectile", sound )
		UTIL_Remove( sound )
	end
	
	return true
end


------------------------------------------------------------------------------------------------------------------------------------------------------------


hoodwink_sharpshooter_release_lua = class({})

function hoodwink_sharpshooter_release_lua:OnSpellStart()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	local mod = caster:FindModifierByName( "modifier_hoodwink_sharpshooter_lua" )
	if not mod or mod:IsNull() then return end
	mod:Destroy()
end


------------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_hoodwink_sharpshooter_lua = class({})

function modifier_hoodwink_sharpshooter_lua:IsHidden() return false end
function modifier_hoodwink_sharpshooter_lua:IsDebuff() return false end
function modifier_hoodwink_sharpshooter_lua:IsStunDebuff() return false end
function modifier_hoodwink_sharpshooter_lua:IsPurgable() return false end

function modifier_hoodwink_sharpshooter_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.team = self.parent:GetTeamNumber()

	if not self.caster or self.caster:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.charge = self.ability:GetSpecialValueFor( "max_charge_time" ) * (1 - self.parent:FindTalentValue("special_bonus_unique_hoodwink_sharpshooter_speed", "pct_change") / 100)
	self.damage = self.ability:GetSpecialValueFor( "max_damage" )
	self.duration = self.ability:GetSpecialValueFor( "max_slow_debuff_duration" )
	self.turn_rate = self.ability:GetSpecialValueFor( "turn_rate" )

	self.recoil_distance = self.ability:GetSpecialValueFor( "recoil_distance" )
	self.recoil_duration = self.ability:GetSpecialValueFor( "recoil_duration" )
	self.recoil_height = self.ability:GetSpecialValueFor( "recoil_height" )

	-- set interval on both cl and sv
	self.interval = 0.03 
	self:StartIntervalThink( self.interval )

	if not IsServer() then return end

	-- references
	self.projectile_speed = self.ability:GetSpecialValueFor( "arrow_speed" ) * (1 + self.parent:FindTalentValue("special_bonus_unique_hoodwink_sharpshooter_speed", "pct_change") / 100)
	self.projectile_range = self.ability:GetSpecialValueFor( "arrow_range" )
	self.projectile_width = self.ability:GetSpecialValueFor( "arrow_width" )
	local projectile_name = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf"

	-- init turn logic
	local vec = Vector( kv.x, kv.y, 0 )
	self:SetDirection( vec )
	self.current_dir = self.target_dir
	self.face_target = true
	self.parent:SetForwardVector( self.current_dir )
	self.turn_speed = self.interval * self.turn_rate

	-- precache projectile
	self.info = {
		Source = self.parent,
		Ability = self.ability,
		-- vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

	    EffectName = projectile_name,
	    fDistance = self.projectile_range,
	    fStartRadius = self.projectile_width,
	    fEndRadius = self.projectile_width,
		-- vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
	}

	-- swap abilities
	self.caster:SwapAbilities( "hoodwink_sharpshooter_lua", "hoodwink_sharpshooter_release_lua", false, true )

	-- Create Particle
	local sharpshooter_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(sharpshooter_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true)
	self:AddParticle(sharpshooter_effect, false, false, -1, false, false)
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Channel", self.parent )

	-- Create Particle for updating
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.parent:GetForwardVector() * self.projectile_range
	self.range_finder_effect = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_range_finder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
	ParticleManager:SetParticleControl( self.range_finder_effect, 0, startpos )
	ParticleManager:SetParticleControl( self.range_finder_effect, 1, endpos )
	self:AddParticle(self.range_finder_effect, false, false, -1, false, false)
end

function modifier_hoodwink_sharpshooter_lua:OnDestroy()
	if not IsServer() then return end

	-- calculate direction
	local direction = self.current_dir

	-- calculate percentage
	local pct = math.min(self:GetElapsedTime(), self.charge) / self.charge

	-- Launch projectile
	self.info.vSpawnOrigin = self.parent:GetOrigin()
	self.info.vVelocity = direction * self.projectile_speed

	-- Create thinker for sound
	local sound = CreateModifierThinker(self.caster, self, "", {}, self.caster:GetOrigin(), self.team, false)
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Projectile", sound )

	self.info.ExtraData = {
		damage = self.damage * pct,
		duration = self.duration * pct,
		x = direction.x,
		y = direction.y,
		sound = sound:entindex(),
	}
	ProjectileManager:CreateLinearProjectile( self.info )

	local knockback_origin = self.parent:GetOrigin() + 100 * direction
	local knockback_table = {
		center_x = knockback_origin.x,
		center_y = knockback_origin.y,
		center_z = knockback_origin.z,
		knockback_duration = self.recoil_duration,
		knockback_distance = self.recoil_distance,
		knockback_height = self.recoil_height,
		duration = self.recoil_duration,
	}
	local knockback_modifier = self.caster:AddNewModifier(self.caster, self, "modifier_knockback", knockback_table)

	-- swap abilities
	self.caster:SwapAbilities( "hoodwink_sharpshooter_lua", "hoodwink_sharpshooter_release_lua", true, false )

	-- Create Particle
	if knockback_modifier then
		local force_staff_effect = ParticleManager:CreateParticle( "particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		knockback_modifier:AddParticle(force_staff_effect, false, false, -1, false, false)
	end
	
	StopSoundOn( "Hero_Hoodwink.Sharpshooter.Channel", self.caster )
	EmitSoundOn( "Hero_Hoodwink.Sharpshooter.Cast", self.caster )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_hoodwink_sharpshooter_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_hoodwink_sharpshooter_lua:OnOrder( params )
	if params.unit ~= self.parent then return end
	
	if 	params.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type == DOTA_UNIT_ORDER_MOVE_TO_DIRECTION then	-- point right click
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or params.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then	-- targetted right click
		self:SetDirection( params.target:GetOrigin() )
	end
end

function modifier_hoodwink_sharpshooter_lua:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_hoodwink_sharpshooter_lua:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_hoodwink_sharpshooter_lua:GetModifierDisableTurning()
	return 1
end

function modifier_hoodwink_sharpshooter_lua:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_hoodwink_sharpshooter_lua:OnIntervalThink()
	if not IsServer() then
		-- only update stack percentage on client to reduce traffic
		local pct = math.min(self:GetElapsedTime(), self.charge) / self.charge
		pct = math.floor(pct * 100)
		self:SetStackCount(pct)
		return
	end

	-- turning logic
	self:TurnLogic()

	-- max charge sound
	if not self.charged and self:GetElapsedTime() > self.charge then
		self.charged = true
		EmitSoundOnClient( "Hero_Hoodwink.Sharpshooter.MaxCharge", self.parent:GetPlayerOwner() )
	end

	-- timer particle
	local remaining = self:GetRemainingTime()
	local seconds = math.ceil( remaining )
	local is_half = (seconds - remaining) > 0.5
	if is_half then seconds = seconds - 1 end

	if self.half ~= is_half then
		self.half = is_half

		local mid = 1
		if is_half then mid = 8 end

		local len = 2
		if seconds < 1 then
			len = 1
			if not is_half then return end
		end

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
	end

	-- update paticle
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range
	ParticleManager:SetParticleControl( self.range_finder_effect, 0, startpos )
	ParticleManager:SetParticleControl( self.range_finder_effect, 1, endpos )
end

function modifier_hoodwink_sharpshooter_lua:SetDirection( vec )
	self.target_dir = ((vec - self.parent:GetOrigin()) * Vector(1,1,0)):Normalized()
	self.face_target = false
end

function modifier_hoodwink_sharpshooter_lua:TurnLogic()
	-- only rotate when target changed
	if self.face_target then return end

	local current_angle = VectorToAngles( self.current_dir ).y
	local target_angle = VectorToAngles( self.target_dir ).y
	local angle_diff = AngleDiff( current_angle, target_angle )

	local sign = -1
	if angle_diff < 0 then sign = 1 end

	if math.abs( angle_diff ) < 1.1 * self.turn_speed then
		-- end rotating
		self.current_dir = self.target_dir
		self.face_target = true
	else
		-- rotate
		self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign * self.turn_speed, 0), self.current_dir )
	end

	-- set facing when not motion controlled
	local a = self.parent:IsCurrentlyHorizontalMotionControlled()
	local b = self.parent:IsCurrentlyVerticalMotionControlled()
	if not (a or b) then
		self.parent:SetForwardVector( self.current_dir )
	end
end

function modifier_hoodwink_sharpshooter_lua:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_6
end

function modifier_hoodwink_sharpshooter_lua:GetOverrideAnimationRate()
	return 1.0
end

function modifier_hoodwink_sharpshooter_lua:GetActivityTranslationModifiers()
	return "mouse_sharpshooter_static_charge"
end

