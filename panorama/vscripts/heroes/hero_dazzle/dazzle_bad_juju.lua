---@class dazzle_bad_juju_lua:CDOTA_Ability_Lua
dazzle_bad_juju_lua = class({})
LinkLuaModifier("modifier_dazzle_bad_juju_lua", "heroes/hero_dazzle/modifier_dazzle_bad_juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_bad_juju_armor_lua", "heroes/hero_dazzle/modifier_dazzle_bad_juju_armor", LUA_MODIFIER_MOTION_NONE)

function dazzle_bad_juju_lua:GetIntrinsicModifierName()
	return "modifier_dazzle_bad_juju_lua"
end

function dazzle_bad_juju_lua:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local location = caster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("heal_damage")

	local targets = FindUnitsInRadius(team, 
		location, 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		true
	)

	local damage_table = {
		attacker = caster,
		ability = self,
		damage_type = self:GetAbilityDamageType(),
	}

	for _, unit in pairs(targets) do
		local modifier = unit:FindModifierByName("modifier_dazzle_bad_juju_armor_lua")
		if modifier and modifier:GetStackCount() > 0 then
			local amount = damage * modifier:GetStackCount()
			
			if unit:GetTeam() == team then
				unit:Heal(amount, self)
			else
				damage_table.victim = unit
				damage_table.damage = amount
				ApplyDamage(damage_table)
			end

			EmitSoundOn("Hero_Dazzle.BadJuJu.Target", unit)
		end
	end

	EmitSoundOn("Hero_Dazzle.BadJuJu.Cast", caster)
end
