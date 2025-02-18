mars_gods_rebuke_lua = class({})
LinkLuaModifier( "modifier_mars_gods_rebuke_lua", "heroes/hero_mars/mars_gods_rebuke_lua/modifier_mars_gods_rebuke_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_BOTH )


function mars_gods_rebuke_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

-----------------------------------------------------------
-- Ability Start
function mars_gods_rebuke_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if point:Length2D() == 0 then
		point_caster = self:GetCaster():GetForwardVector():Normalized()
		point = self:GetCaster():GetOrigin() + point_caster * 10
	end
	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- add buff modifier
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_mars_gods_rebuke_lua", -- modifier name
		{  } -- kv
	)

	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)

			local abil =  self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int10")
			if abil ~= nil then
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_generic_stunned_lua", -- modifier name
					{ duration = 3}
					)
			end
			
			if not (enemy:HasModifier( "modifier_mars_spear_of_mars_lua_debuff" ) or enemy:IsAncient()) then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_generic_knockback_lua", -- modifier name
					{
						duration = duration,
						distance = distance,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)
			end

			caught = true
			-- play effects
			self:PlayEffects2( enemy, origin, cast_direction )
		end
	end

	-- destroy buff modifier
	buff:Destroy()

	-- play effects
	self:PlayEffects1( caught, (point-origin):Normalized() )
	
	
	local abil =  self:GetCaster():FindAbilityByName("npc_dota_hero_mars_str7")
		if abil ~= nil then
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_mars_boost", -- modifier name
			{ duration = 3 } -- kv
		)
	end
	
	
	local abil =  self:GetCaster():FindAbilityByName("npc_dota_hero_mars_int9")
		if abil ~= nil then
			local r2 = RandomInt(1,100)
			if r2 <= 50 then
				local sound_cast = "DOTA_Item.Refresher.Activate"
				EmitSoundOn( sound_cast, caster )
				self:EndCooldown()
			end
	end	
end

--------------------------------------------------------------------------------
-- Play Effects
function mars_gods_rebuke_lua:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
	local sound_cast = "Hero_Mars.Shield.Cast"
	if not caught then
		local sound_cast = "Hero_Mars.Shield.Cast.Small"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function mars_gods_rebuke_lua:PlayEffects2( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end