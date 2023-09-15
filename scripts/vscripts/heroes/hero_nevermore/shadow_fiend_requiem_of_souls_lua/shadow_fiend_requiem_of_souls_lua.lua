shadow_fiend_requiem_of_souls_lua = class({})
LinkLuaModifier( "modifier_shadow_fiend_requiem_of_souls_lua", "heroes/hero_nevermore/shadow_fiend_requiem_of_souls_lua/modifier_shadow_fiend_requiem_of_souls_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_debuff_armor", "heroes/hero_nevermore/shadow_fiend_requiem_of_souls_lua/modifier_debuff_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disarm", "heroes/hero_nevermore/shadow_fiend_requiem_of_souls_lua/modifier_disarm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ally_buff", "heroes/hero_nevermore/shadow_fiend_requiem_of_souls_lua/modifier_ally_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function shadow_fiend_requiem_of_souls_lua:OnAbilityPhaseStart()
	self:PlayEffects1()
	return true -- if success
end
function shadow_fiend_requiem_of_souls_lua:OnAbilityPhaseInterrupted()
	self:StopEffects1( false )
end

function shadow_fiend_requiem_of_souls_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int8") ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect() / 200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function shadow_fiend_requiem_of_souls_lua:GetCooldown(level)
	cd = self.BaseClass.GetCooldown(self, level)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str_last") 
		if abil ~= nil then
		return cd- 60
	 else
		return cd
	 end
end
-- Ability Start
function shadow_fiend_requiem_of_souls_lua:OnSpellStart()
	count = 1
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int11")             
	if abil ~= nil then 
	count = 3
	end

	-- get number of souls
	local lines = count
	local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_shadow_fiend_necromastery_lua", self:GetCaster() )
	if modifier~=nil then
		lines = count
	end

	self:Explode( lines )
end

--------------------------------------------------------------------------------
-- Projectile Hit
function shadow_fiend_requiem_of_souls_lua:OnProjectileHit_ExtraData( hTarget, vLocation, params )
	if hTarget ~= nil then
		-- filter
		pass = false
		if hTarget:GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
			pass = true
		end

		if pass then
			-- check if it is from explode or implode
			if params and params.scepter then

				-- reduce the damage
				damage = self.damage * (self.damage_pct/100)

				-- add to heal calculation
				if hTarget:IsHero() then
					local modifier = self:RetATValue( params.modifier )
					modifier:AddTotalHeal( damage )
				end
			end

			-- damage target
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damage )

			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int7")             
			if abil ~= nil then 
			hTarget:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_shadow_fiend_requiem_of_souls_lua",
				{ duration = 3 }
			)
			end
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi7")             
			if abil ~= nil then 
			hTarget:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_debuff_armor",
				{ duration = 3 }
			)
			end
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str8")             
			if abil ~= nil then 
			hTarget:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_disarm",
				{ duration = 3 }
			)
			end
			
			
		end
	end

	return false
end

-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Helper
function shadow_fiend_requiem_of_souls_lua:Explode( lines )
	local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_shadow_fiend_necromastery_lua", self:GetCaster() )
	self.damage =  self:GetSpecialValueFor("damage") * modifier:GetStackCount() 
	self.duration = self:GetSpecialValueFor("requiem_slow_duration")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int9")             
	if abil ~= nil then 
	self.damage = self.damage * 2
	end
	
	-------------------------------------------------------------------------------------------------------------------
	

	
	------------------------------------------------------------------------------------------------------------------

	-- get projectile
	local particle_line = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
	local line_length = self:GetSpecialValueFor("requiem_radius")
	local width_start = self:GetSpecialValueFor("requiem_line_width_start")
	local width_end = self:GetSpecialValueFor("requiem_line_width_end")
	local line_speed = self:GetSpecialValueFor("requiem_line_speed")

	-- create linear projectile
	local initial_angle_deg = self:GetCaster():GetAnglesAsVector().y
	local delta_angle = 360/lines
	for i=0,lines-1 do
		-- Determine velocity
		local facing_angle_deg = initial_angle_deg + delta_angle * i
		if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
		local facing_angle = math.rad(facing_angle_deg)
		local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
		local velocity = facing_vector * line_speed

		-- create projectile
		local info = {
			Source = self:GetCaster(),
			Ability = self,
			EffectName = particle_line,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fDistance = line_length,
			vVelocity = velocity,
			fStartRadius = width_start,
			fEndRadius = width_end,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bReplaceExisting = false,
			bProvidesVision = false,
		}
		ProjectileManager:CreateLinearProjectile( info )
	end

	-- Play effects
	self:StopEffects1( true )
	self:PlayEffects2( lines )
end

function shadow_fiend_requiem_of_souls_lua:Implode( lines, modifier )
	-- get data


	-- create identifier
	local modifierAT = self:AddATValue( modifier )
	modifier.identifier = modifierAT

	-- get projectile
	local particle_line = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
	local line_length = self:GetSpecialValueFor("requiem_radius")
	local width_start = self:GetSpecialValueFor("requiem_line_width_end")
	local width_end = self:GetSpecialValueFor("requiem_line_width_start")
	local line_speed = self:GetSpecialValueFor("requiem_line_speed")

	-- create linear projectile
	local initial_angle_deg = self:GetCaster():GetAnglesAsVector().y
	local delta_angle = 360/lines
	for i=0,lines-1 do
		-- Determine velocity
		local facing_angle_deg = initial_angle_deg + delta_angle * i
		if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
		local facing_angle = math.rad(facing_angle_deg)
		local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
		local velocity = facing_vector * line_speed

		
		-- create projectile
		local info = {
			Source = self:GetCaster(),
			Ability = self,
			EffectName = particle_line,
			vSpawnOrigin = self:GetCaster():GetOrigin() + facing_vector * line_length,
			fDistance = line_length,
			vVelocity = -velocity,
			fStartRadius = width_start,
			fEndRadius = width_end,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bReplaceExisting = false,
			bProvidesVision = false,
			ExtraData = {
				scepter = true,
				modifier = modifierAT,
			}
		}
		ProjectileManager:CreateLinearProjectile( info )
	end
end

--------------------------------------------------------------------------------
-- Effects
function shadow_fiend_requiem_of_souls_lua:PlayEffects1()
	-- Get Resources
	local particle_precast = "particles/units/heroes/hero_nevermore/nevermore_wings.vpcf"
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"

	-- Create Particles
	self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )	

	-- Play Sounds
	EmitSoundOn(sound_precast, self:GetCaster())
end
function shadow_fiend_requiem_of_souls_lua:StopEffects1( success )
	-- Get Resources
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"

	-- Destroy Particles
	if not success then
		ParticleManager:DestroyParticle( self.effect_precast, true )
		StopSoundOn(sound_precast, self:GetCaster())
	end

	ParticleManager:ReleaseParticleIndex( self.effect_precast )
end

function shadow_fiend_requiem_of_souls_lua:PlayEffects2( lines )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
	local sound_cast = "Hero_Nevermore.RequiemOfSouls"

	-- Create Particles
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( lines, 0, 0 ) )	-- Lines
	ParticleManager:SetParticleControlForward( effect_cast, 2, self:GetCaster():GetForwardVector() )		-- initial direction
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Play Sounds
	EmitSoundOn(sound_cast, self:GetCaster())
end

--------------------------------------------------------------------------------
-- Helper: Ability Table (AT)
function shadow_fiend_requiem_of_souls_lua:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function shadow_fiend_requiem_of_souls_lua:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function shadow_fiend_requiem_of_souls_lua:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function shadow_fiend_requiem_of_souls_lua:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	return ret
end

function shadow_fiend_requiem_of_souls_lua:DelATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
end