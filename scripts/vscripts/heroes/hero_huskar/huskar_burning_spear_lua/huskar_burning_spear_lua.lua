-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
huskar_burning_spear_lua = class({})
LinkLuaModifier( "modifier_huskar_burning_spear_lua", "heroes/hero_huskar/huskar_burning_spear_lua/modifier_huskar_burning_spear_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_huskar_burning_spear_lua_stack", "heroes/hero_huskar/huskar_burning_spear_lua/modifier_huskar_burning_spear_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function huskar_burning_spear_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end
function huskar_burning_spear_lua:GetHealthCost()
	return self:GetCaster():GetHealth() / 100 * self:GetSpecialValueFor("health_cost")
end

--------------------------------------------------------------------------------
-- Orb Effects
function huskar_burning_spear_lua:GetProjectileName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end

function huskar_burning_spear_lua:OnOrbFire( params )
	-- health cost
	local damageTable = {
		victim = self:GetCaster(),
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetHealth() / 100 * self:GetSpecialValueFor("health_cost"),
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
	}
	ApplyDamage(damageTable)
end

function huskar_burning_spear_lua:OnOrbImpact( params )
	if params.target:IsBuilding() then return end

	local ApplyEffect = function (target, primary)
			target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_huskar_burning_spear_lua", -- modifier name
			{ duration = self:GetSpecialValueFor("duration"), auto_attack = primary } -- kv
		)
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi8") then
		local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),	-- int, your team number
            params.target:GetOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            150,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
        )
        for _,enemy in pairs(enemies) do
            ApplyEffect(enemy, params.target == enemy)
        end
	else
		ApplyEffect(params.target, true)
	end
	

	-- play effects
	local sound_cast = "Hero_Huskar.Burning_Spear.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Ability Start
function huskar_burning_spear_lua:OnSpellStart()
end