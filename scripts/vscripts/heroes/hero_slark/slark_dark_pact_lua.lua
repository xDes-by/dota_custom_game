slark_dark_pact_lua = class({})
LinkLuaModifier( "modifier_slark_dark_pact_lua", "heroes/hero_slark/slark_dark_pact_lua", LUA_MODIFIER_MOTION_NONE )


function slark_dark_pact_lua:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int6")
	if abil ~= nil	then 
	return math.min(65000, self:GetCaster():GetIntellect()/2)
	end
	return math.min(65000, self:GetCaster():GetIntellect())
end

function slark_dark_pact_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_dark_pact_lua", -- modifier name
		{} -- kv
	)
end


modifier_slark_dark_pact_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_dark_pact_lua:IsHidden()
	return true
end

function modifier_slark_dark_pact_lua:IsDebuff()
	return false
end

function modifier_slark_dark_pact_lua:IsPurgable()
	return false
end

function modifier_slark_dark_pact_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_dark_pact_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	if _G.slarkdelay ~= 0 then
		self.delay_time = self:GetAbility():GetSpecialValueFor( "delay" )
	else
		self.delay_time = 0
	end
	self.pulse_duration = self:GetAbility():GetSpecialValueFor( "pulse_duration" )
	self.total_pulses = self:GetAbility():GetSpecialValueFor( "total_pulses" )
	self.total_damage = self:GetAbility():GetSpecialValueFor( "total_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str10")
		if abil ~= nil	then 
		self.total_damage = self:GetCaster():GetHealth()/2
		end

	local try_damage = self.total_damage

	self.delay = true
	self.count = 0
	self.damage = try_damage/self.total_pulses
	
	damage_type = DAMAGE_TYPE_MAGICAL
	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int10")
		if abil ~= nil	then 
		damage_flags = DOTA_DAMAGE_FLAG_NONE
		end
		
	-- Start interval
	if IsServer() then
		-- Precache damageTable	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = damage_type,
			damage_flags = damage_flags,
			ability = self:GetAbility(), --Optional.
		}

		-- begin delay
		self:StartIntervalThink( self.delay_time )

		-- play effects
		self:PlayEffects1()
	end
	_G.slarkdelay = nil 
end

function modifier_slark_dark_pact_lua:OnRefresh( kv )
	self.caster = self:GetCaster()
	if _G.slarkdelay ~= 0 then
		self.delay_time = self:GetAbility():GetSpecialValueFor( "delay" )
	else
		self.delay_time = 0
	end
	self.pulse_duration = self:GetAbility():GetSpecialValueFor( "pulse_duration" )
	self.total_pulses = self:GetAbility():GetSpecialValueFor( "total_pulses" )
	self.total_damage = self:GetAbility():GetSpecialValueFor( "total_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str10")
		if abil ~= nil	then 
		self.total_damage = self:GetCaster():GetHealth()/2
		end

	local try_damage = self.total_damage

	self.delay = true
	self.count = 0
	self.damage = try_damage/self.total_pulses
	
	damage_type = DAMAGE_TYPE_MAGICAL
	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int10")
		if abil ~= nil	then 
		damage_flags = DOTA_DAMAGE_FLAG_NONE
		end
		
	-- Start interval
	if IsServer() then
		-- Precache damageTable	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = damage_type,
			damage_flags = damage_flags,
			ability = self:GetAbility(), --Optional.
		}

		-- begin delay
		self:StartIntervalThink( self.delay_time )

		-- play effects
		self:PlayEffects1()
	end
end

function modifier_slark_dark_pact_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_slark_dark_pact_lua:OnIntervalThink()
	if self.delay then
		self.delay = false
		-- start pulse
		self:StartIntervalThink( self.pulse_duration/self.total_pulses )

		-- play effects
		self:PlayEffects2()
	else
		-- Find Units in Radius
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		damage_type = DAMAGE_TYPE_MAGICAL
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int10")
		if abil ~= nil	then 
		damage_flags = DOTA_DAMAGE_FLAG_NONE
		end

		self.damageTable.damage = self.damage
		self.damageTable.damage_flags = damage_flags
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end

		-- Purge
		self:GetParent():Purge( false, true, false, true, true )

		-- self damage
		self.damageTable.damage = self.damage/2
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		self.damageTable.victim = self:GetParent()
		ApplyDamage( self.damageTable )

		-- Counter
		self.count = self.count + 1
		if self.count>=self.total_pulses then
			self:StartIntervalThink( -1 )
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_dark_pact_lua:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf"
	local sound_cast = "Hero_Slark.DarkPact.PreCast"

	-- play particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitoc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetParent() )
end

function modifier_slark_dark_pact_lua:PlayEffects2()
	local sound_cast = "Hero_Slark.DarkPact.Cast"
	local particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end