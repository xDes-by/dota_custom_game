leshrac_pulse_nova_lua = class({})
LinkLuaModifier( "modifier_leshrac_pulse_nova_lua", "heroes/hero_leshrac/leshrac_pulse_nova_lua/modifier_leshrac_pulse_nova_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_burn_lua", "heroes/hero_leshrac/leshrac_pulse_nova_lua/modifier_leshrac_pulse_nova_burn_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_burn2_lua", "heroes/hero_leshrac/leshrac_pulse_nova_lua/modifier_leshrac_pulse_nova_burn_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_pulse_nova_intrinsic_lua", "heroes/hero_leshrac/leshrac_pulse_nova_lua/modifier_leshrac_pulse_nova_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )


function leshrac_pulse_nova_lua:GetIntrinsicModifierName()
	return "modifier_leshrac_pulse_nova_intrinsic_lua"
end

function leshrac_pulse_nova_lua:OnSpellStart()
	local caster = self:GetCaster()
end
function leshrac_pulse_nova_lua:GetManaCost(iLevel)
    return 40 + math.min(65000, self:GetCaster():GetIntellect() / 300)
end
function leshrac_pulse_nova_lua:GetCastRange(vLocation, hTarget)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_str10") then
		return 800
	end
end

function leshrac_pulse_nova_lua:OnToggle(  )
	local caster = self:GetCaster()

	local toggle = self:GetToggleState()

	if toggle then
		-- add modifier
		self.modifier = caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_leshrac_pulse_nova_lua", -- modifier name
			{  } -- kv
		)
	else
		if self.modifier and not self.modifier:IsNull() then
			self.modifier:Destroy()
		end
		self.modifier = nil
	end
end

function leshrac_pulse_nova_lua:Hit(target)
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	self:PlayEffects( target )
	caster = self:GetCaster()
	if caster:FindAbilityByName("npc_dota_hero_leshrac_agi9") and RandomInt(1, 100) <= 50 then
		local leshrac_lightning_storm_lua = caster:FindAbilityByName("leshrac_lightning_storm_lua")
		if leshrac_lightning_storm_lua and leshrac_lightning_storm_lua:GetLevel() > 0 then
			caster:SetCursorCastTarget( target )
			leshrac_lightning_storm_lua:OnSpellStart(1)
		end
	end
end

function leshrac_pulse_nova_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf"
	local sound_cast = "Hero_Leshrac.Pulse_Nova_Strike"

	-- radius
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	-- self:AddParticle(
	-- 	effect_cast,
	-- 	false, -- bDestroyImmediately
	-- 	false, -- bStatusEffect
	-- 	-1, -- iPriority
	-- 	false, -- bHeroEffect
	-- 	false -- bOverheadEffect
	-- )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end