bristleback_quill_spray_lua = class({})
LinkLuaModifier( "modifier_bristleback_quill_spray_lua", "heroes/hero_bristleback/bristleback_quill_spray_lua/modifier_bristleback_quill_spray_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_quill_spray_lua_stack", "heroes/hero_bristleback/bristleback_quill_spray_lua/modifier_bristleback_quill_spray_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_evasion", "heroes/hero_bristleback/modifier_evasion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_armor", "heroes/hero_bristleback/modifier_armor", LUA_MODIFIER_MOTION_NONE )


function bristleback_quill_spray_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect())
    end
end

function bristleback_quill_spray_lua:OnSpellStart()
	caster = self:GetCaster()
        stack_damage = self:GetSpecialValueFor("quill_stack_damage")
		base_damage = self:GetSpecialValueFor("quill_base_damage")
		max_damage = self:GetSpecialValueFor("max_damage")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_int_last") ~= nil then
		stack_damage = self:GetSpecialValueFor("quill_stack_damage") * 3
		base_damage = self:GetSpecialValueFor("quill_base_damage") * 3
		max_damage = self:GetSpecialValueFor("max_damage") * 3
	end

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local stack_duration = self:GetSpecialValueFor("quill_stack_duration")

		local abil = caster:FindAbilityByName("npc_dota_hero_bristleback_str_last")
		if abil ~= nil and abil:IsTrained()	then 
			base_damage = base_damage * 5
		end

		local abil = caster:FindAbilityByName("special_bonus_unique_brist_custom")
		if abil ~= nil and abil:IsTrained()	then 
		bonus = abil:GetSpecialValueFor( "value" )
		base_damage = base_damage + bonus
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_int10")
		if abil ~= nil then 
		max_damage = self:GetCaster():GetIntellect()
		end

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	damage_type = DAMAGE_TYPE_PHYSICAL
	damage_flags = DOTA_DAMAGE_FLAG_NONE

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_int11")
	if abil ~= nil then 
	damage_type = DAMAGE_TYPE_MAGICAL
	max_damage = 500
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_int7")
	if abil ~= nil then 
	ra = RandomInt(1,100)
		if ra <= 15 then
		local ability = self:GetCaster():FindAbilityByName( "bristleback_viscous_nasal_goo_lua" )
				if ability~=nil then ability:SetLevel(1)
					ability:OnSpellStart()
				end
		end
	end

	local damageTable = {
		attacker = caster,
		damage_type = damage_type,
		damage_flags = damage_flags,
		ability = self, --Optional.
	}
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_str7")
		if abil ~= nil then 
			if not self:IsFullyCastable() then		---------------------------------------------костыль надо менять!!!!!!!!!!!!
				caster:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_armor", -- modifier name
				{ duration = 2 } -- kv
			)
			end
		end

	for _,enemy in pairs(enemies) do
		-- find stack
		local stack = 0
		local modifier = enemy:FindModifierByNameAndCaster( "modifier_bristleback_quill_spray_lua", caster )
		if modifier~=nil then
			stack = modifier:GetStackCount()
		end

		-- damage
		damageTable.victim = enemy
		damageTable.damage = math.min( base_damage + stack*stack_damage, max_damage )
		ApplyDamage( damageTable )

		-- Add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_bristleback_quill_spray_lua", -- modifier name
			{ stack_duration = stack_duration } -- kv
		)
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_str6")
		if abil ~= nil then 
			if not self:IsFullyCastable() then
				enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_evasion", -- modifier name
				{ duration = 2 } -- kv
			)
			end
		end
		-- Effects
		self:PlayEffects2( enemy )
	end

	-- Effects
	self:PlayEffects1()
end

--------------------------------------------------------------------------------
-- Helper
function bristleback_quill_spray_lua:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function bristleback_quill_spray_lua:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function bristleback_quill_spray_lua:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function bristleback_quill_spray_lua:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
	return ret
end

--------------------------------------------------------------------------------
-- Effects
function bristleback_quill_spray_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = ""--"particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
	local sound_cast = "Hero_Bristleback.QuillSpray.Cast"

	-- Create Particle
	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	--local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function bristleback_quill_spray_lua:PlayEffects2( target )
	local particle_cast = ""--"particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf"
	local sound_cast = "Hero_Bristleback.QuillSpray.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end



--------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_bristleback_viscous_nasal_goo_lua", "heroes/hero_bristleback/bristleback_quill_spray_lua/bristleback_quill_spray_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------------------------
bristleback_viscous_nasal_goo_lua = class({})

function bristleback_viscous_nasal_goo_lua:GetBehavior()
	local behavior =  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	return behavior
end

function bristleback_viscous_nasal_goo_lua:OnSpellStart()
	caster = self:GetCaster()

	local projectile_name = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf"
	local projectile_speed = self:GetSpecialValueFor("goo_speed")

	local info = {
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
	}

		local radius = self:GetSpecialValueFor("radius_scepter")
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			info.Target = enemy
			ProjectileManager:CreateTrackingProjectile(info)
		end

	self:PlayEffects1()
end

function bristleback_viscous_nasal_goo_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget == nil or hTarget:IsInvulnerable() then
		return
	end

	if not self:GetCaster():HasScepter() then
		if hTarget:TriggerSpellAbsorb( self ) then
			return
		end
	end

	local stack_duration = self:GetSpecialValueFor("goo_duration")

	-- Add modifier
	hTarget:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_bristleback_viscous_nasal_goo_lua", -- modifier name
		{ duration = stack_duration } -- kv
	)

	self:PlayEffects2( hTarget )
end

function bristleback_viscous_nasal_goo_lua:PlayEffects1()
	local sound_cast = "Hero_Bristleback.ViscousGoo.Cast"

	EmitSoundOn( sound_cast, self:GetCaster() )
end

function bristleback_viscous_nasal_goo_lua:PlayEffects2( target )
	local sound_cast = "Hero_Bristleback.ViscousGoo.Target"

	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

modifier_bristleback_viscous_nasal_goo_lua = class({})

function modifier_bristleback_viscous_nasal_goo_lua:IsHidden()
	return false
end

function modifier_bristleback_viscous_nasal_goo_lua:IsDebuff()
	return true
end

function modifier_bristleback_viscous_nasal_goo_lua:IsStunDebuff()
	return false
end

function modifier_bristleback_viscous_nasal_goo_lua:IsPurgable()
	return true
end

function modifier_bristleback_viscous_nasal_goo_lua:OnCreated( kv )
	self.armor_stack = self:GetAbility():GetSpecialValueFor( "armor_per_stack" )
	self.slow_base = self:GetAbility():GetSpecialValueFor( "base_move_slow" )
	self.slow_stack = self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )

	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_bristleback_viscous_nasal_goo_lua:OnRefresh( kv )
	self.armor_stack = self:GetAbility():GetSpecialValueFor( "armor_per_stack" )
	self.slow_base = self:GetAbility():GetSpecialValueFor( "base_move_slow" )
	self.slow_stack = self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	local max_stack = self:GetAbility():GetSpecialValueFor( "stack_limit" )


	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
end

function modifier_bristleback_viscous_nasal_goo_lua:OnDestroy( kv )

end

function modifier_bristleback_viscous_nasal_goo_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_bristleback_viscous_nasal_goo_lua:GetModifierPhysicalArmorBonus()
	return -self.armor_stack * self:GetStackCount()
end
function modifier_bristleback_viscous_nasal_goo_lua:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow_stack * self:GetStackCount()
end

function modifier_bristleback_viscous_nasal_goo_lua:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

function modifier_bristleback_viscous_nasal_goo_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
