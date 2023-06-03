-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Break behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
huskar_life_break_lua = class({})
LinkLuaModifier( "modifier_huskar_life_break_lua", "heroes/hero_huskar/huskar_life_break_lua/modifier_huskar_life_break_lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function huskar_life_break_lua:GetHealthCost()
	return self:GetCaster():GetHealth() / 100 * self:GetSpecialValueFor("health_cost_percent")
end

--------------------------------------------------------------------------------
-- Ability Start
function huskar_life_break_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	print(target)
	-- add modifiers
	-- local tgt = tempTable:AddATValue( target )
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_huskar_life_break_lua", -- modifier name
		{
			entindex = target:entindex(),
		} -- kv
	)

	-- play effects
	local sound_cast = "Hero_Huskar.Life_Break"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- function huskar_life_break_lua:PlayEffects()
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
-- 	local sound_cast = "string"

-- 	-- Get Data

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
-- 	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
-- 	ParticleManager:SetParticleControlEnt(
-- 		effect_cast,
-- 		iControlPoint,
-- 		hTarget,
-- 		PATTACH_NAME,
-- 		"attach_name",
-- 		vOrigin, -- unknown
-- 		bool -- unknown, true
-- 	)
-- 	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
-- 	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- Create Sound
-- 	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
-- 	EmitSoundOn( sound_target, target )
-- end