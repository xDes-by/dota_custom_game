boss_3_chain_frost = class({})
LinkLuaModifier( "modifier_boss_3_chain_frost", "abilities/bosses/line/boss_3/boss_3_chain_frost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_3_chain_frost_thinker", "abilities/bosses/line/boss_3/boss_3_chain_frost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_tracking_projectile", "heroes/generic/modifier_generic_tracking_projectile", LUA_MODIFIER_MOTION_NONE )

if not tempTable then
	tempTable = {}
	tempTable.table = {}
end

function tempTable:GetATEmptyKey()
	local i = 1
	while self.table[i]~=nil do
		i = i+1
	end
	return i
end

function tempTable:AddATValue( value )
	local i = self:GetATEmptyKey()
	self.table[i] = value
	return i
end

function tempTable:RetATValue( key )
	local ret = self.table[key]
	self.table[key] = nil
	return ret
end

function tempTable:GetATValue( key )
	return self.table[key]
end

function tempTable:Print()
	for k,v in pairs(self.table) do

	end
end



function boss_3_chain_frost:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local castTable = {
		damage = 0,
		scepter = scepter,
		jump = 0,
		jumps = self:GetSpecialValueFor("jumps"),
		jump_range = self:GetSpecialValueFor("jump_range"),
		as_slow = self:GetSpecialValueFor("slow_attack_speed"),
		ms_slow = self:GetSpecialValueFor("slow_movement_speed"),
		slow_duration = self:GetSpecialValueFor("slow_duration"),
	}
	local key = tempTable:AddATValue( castTable )

	-- load projectile
	local projectile_name = "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local projectile_vision = self:GetSpecialValueFor("vision_radius")

	local projectile_info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			key = key,
		}
	}
	projectile_info = self:PlayProjectile( projectile_info )
	castTable.projectile = projectile_info
	ProjectileManager:CreateTrackingProjectile( castTable.projectile )

	-- play effects
	local sound_cast = "Hero_Lich.ChainFrost"
	EmitSoundOn( sound_cast, caster )
end

function boss_3_chain_frost:OnProjectileHit_ExtraData( target, location, kv )
	self:StopProjectile( kv )

	local bounce_delay = 0.2
	local castTable = tempTable:GetATValue( kv.key )

	-- bounce thinker
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_boss_3_chain_frost_thinker", -- modifier name
		{
			key = kv.key,
			duration = bounce_delay,
		} -- kv
	)

	-- apply damage and slow
	if (not target:IsMagicImmune()) and (not target:IsInvulnerable()) then
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = target:GetMaxHealth()/100*self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
		}
		ApplyDamage(damageTable)

		target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_boss_3_chain_frost", -- modifier name
			{
				duration = castTable.slow_duration,
				as_slow = castTable.as_slow,
				ms_slow = castTable.ms_slow,
			} -- kv
		)
	end

	-- play effects
	local sound_target = "Hero_Lich.ChainFrostImpact.Creep"
	if target:IsConsideredHero() then
		sound_target = "Hero_Lich.ChainFrostImpact.Hero"
	end
	EmitSoundOn( sound_target, target )
end

function boss_3_chain_frost:PlayProjectile( info )
	local tracker = info.Target:AddNewModifier(
		info.Source, -- player source
		self, -- ability source
		"modifier_generic_tracking_projectile", -- modifier name
		{ duration = 4 } -- kv
	)
	tracker:PlayTrackingProjectile( info )
	
	info.EffectName = nil
	if not info.ExtraData then info.ExtraData = {} end
	info.ExtraData.tracker = tempTable:AddATValue( tracker )

	return info
end

function boss_3_chain_frost:StopProjectile( kv )
	local tracker = tempTable:RetATValue( kv.tracker )
	if tracker and not tracker:IsNull() then tracker:Destroy() end
end

------------------------------------------------------------------------------------------------------------------------------------------

modifier_boss_3_chain_frost = class({})

function modifier_boss_3_chain_frost:IsHidden()
	return false
end

function modifier_boss_3_chain_frost:IsDebuff()
	return true
end

function modifier_boss_3_chain_frost:IsStunDebuff()
	return false
end

function modifier_boss_3_chain_frost:IsPurgable()
	return true
end

function modifier_boss_3_chain_frost:OnCreated( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value
end

function modifier_boss_3_chain_frost:OnRefresh( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value	
end

function modifier_boss_3_chain_frost:OnDestroy( kv )

end

function modifier_boss_3_chain_frost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_boss_3_chain_frost:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end
function modifier_boss_3_chain_frost:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_boss_3_chain_frost:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

---------------------------------------------------------------------------------

modifier_boss_3_chain_frost_thinker = class({})
--local tempTable = require( "util/tempTable" )

function modifier_boss_3_chain_frost_thinker:IsHidden()
	return false
end

function modifier_boss_3_chain_frost_thinker:IsPurgable()
	return false
end

function modifier_boss_3_chain_frost_thinker:RemoveOnDeath()
	return false
end

function modifier_boss_3_chain_frost_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_boss_3_chain_frost_thinker:OnCreated( kv )
	if IsServer() then
		self.key = kv.key
	end
end

function modifier_boss_3_chain_frost_thinker:OnRefresh( kv )
	
end

function modifier_boss_3_chain_frost_thinker:OnDestroy( kv )
	if IsServer() then
		local castTable = tempTable:GetATValue( self.key )

		-- update values
		if not castTable.scepter then
			castTable.jump = castTable.jump + 1
		end

		if castTable.jump>castTable.jumps then
			-- stop bouncing
			castTable = tempTable:RetATValue( self.key )
			return
		end

		-- add temporary FOV
		AddFOWViewer( castTable.projectile.iVisionTeamNumber, self:GetParent():GetOrigin(), castTable.projectile.iVisionRadius, 0.3, false)

		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			castTable.jump_range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- get random enemy
		local target = nil
		for _,enemy in pairs(enemies) do
			if enemy~=self:GetParent() then
				target = enemy
				break
			end
		end

		if not target then
			-- stop bouncing
			castTable = tempTable:RetATValue( self.key )
			return
		end

		-- bounce to enemy
		castTable.projectile.Target = target
		castTable.projectile.Source = self:GetParent()
		castTable.projectile.EffectName = "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf"
		
		castTable.projectile = self:PlayProjectile( castTable.projectile )
		ProjectileManager:CreateTrackingProjectile( castTable.projectile )
	end
end

function modifier_boss_3_chain_frost_thinker:PlayProjectile( info )
	local tracker = info.Target:AddNewModifier(
		info.Source, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_tracking_projectile", -- modifier name
		{ duration = 4 } -- kv
	)
	local effect_cast = tracker:PlayTrackingProjectile( info )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		info.Source,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	info.EffectName = nil
	if not info.ExtraData then info.ExtraData = {} end
	info.ExtraData.tracker = tempTable:AddATValue( tracker )

	return info
end
