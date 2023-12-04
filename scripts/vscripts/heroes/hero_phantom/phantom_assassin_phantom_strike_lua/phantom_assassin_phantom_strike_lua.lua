phantom_assassin_phantom_strike_lua = class({})
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_crit", "heroes/hero_phantom/phantom_assassin_phantom_strike_lua/modifier_phantom_assassin_phantom_strike_crit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_stun_cooldown", "heroes/hero_phantom/phantom_assassin_phantom_strike_lua/phantom_assassin_phantom_strike_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )


function phantom_assassin_phantom_strike_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function phantom_assassin_phantom_strike_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_phantom_assassin_str50") then
		return 0
	end
    return self.BaseClass.GetCooldown( self, level )
end


function phantom_assassin_phantom_strike_lua:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function phantom_assassin_phantom_strike_lua:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

--------------------------------------------------------------------------------
-- Ability Start
function phantom_assassin_phantom_strike_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local origin = caster:GetOrigin()
	
	if target:GetModelName() == "models/items/earthshaker/totem_dragon_wall/fissure_body.vmdl" or target:GetModelName() == "models/source/machinegun.vmdl" or  target:GetModelName() == "models/heroes/warlock/warlock_demon.vmdl" then return end

	-- Stop if blocked by linken
	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb( self ) then
			return
		end
	end

	-- Get data
	local buff_duration = self:GetSpecialValueFor( "duration" )

	-- Generate data
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_str6")
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_phantom_assassin_str50") and abil then
		if not target:HasModifier("modifier_phantom_assassin_stun_cooldown") then
			target:AddNewModifier(self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = buff_duration } )
			target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_stun_cooldown", { duration = 10 } )
			caster:MoveToTargetToAttack(target)
		end
	elseif abil ~= nil then
		target:AddNewModifier(self:GetCaster(), self,"modifier_generic_stunned_lua",{ duration = buff_duration })
		caster:MoveToTargetToAttack(target)
	end
	
	
	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_phantom_assassin_phantom_strike_crit", -- modifier name
			{ duration = buff_duration } -- kv
		)
		caster:MoveToTargetToAttack(target)
	end

	self:PlayEffects( origin )
	
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int7")
					if abil ~= nil	then 
					local abil2 = self:GetCaster():FindAbilityByName("phantom_assassin_knifes")
						if abil2 ~= nil and abil2:GetLevel() > 0 then
						local r2 = RandomInt(1,2)
						if r2 ==1 then
							abil2:OnSpellStart()
						end
					end
				end
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int10")
	if abil ~= nil then
	local r2 = RandomInt(1,4)
		if r2 == 1 then 
		self:EndCooldown()
		end
	end
end

--------------------------------------------------------------------------------
function phantom_assassin_phantom_strike_lua:PlayEffects( origin )
	-- Get Resources
	local particle_cast_start = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf"
	local sound_cast_start = "Hero_PhantomAssassin.Strike.Start"
	local particle_cast_end = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
	local sound_cast_end = "Hero_PhantomAssassin.Strike.End"

	-- Create Particle
	local effect_cast_start = ParticleManager:CreateParticle( particle_cast_start, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_start, 0, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast_start )

	local effect_cast_end = ParticleManager:CreateParticle( particle_cast_end, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_end, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast_end )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_cast_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast_end, self:GetCaster() )
end

modifier_phantom_assassin_stun_cooldown = class({})
--Classifications template
function modifier_phantom_assassin_stun_cooldown:IsHidden()
	return false
end

function modifier_phantom_assassin_stun_cooldown:OnCreated( kv )
	if not IsServer() then return end
	print(kv.duration)
end

function modifier_phantom_assassin_stun_cooldown:IsDebuff()
	return true
end

function modifier_phantom_assassin_stun_cooldown:IsPurgable()
	return false
end

function modifier_phantom_assassin_stun_cooldown:RemoveOnDeath()
	return true
end
