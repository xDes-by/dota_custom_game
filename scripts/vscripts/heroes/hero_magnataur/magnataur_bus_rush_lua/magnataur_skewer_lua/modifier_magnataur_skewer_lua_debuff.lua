LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
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
modifier_magnataur_skewer_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magnataur_skewer_lua_debuff:IsHidden()
	return true
end

function modifier_magnataur_skewer_lua_debuff:IsDebuff()
	return true
end

function modifier_magnataur_skewer_lua_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_magnataur_skewer_lua_debuff:OnCreated( kv )
	if not IsServer() then return end
	local modifier_bus_rush_unit_lua = self:GetCaster():FindModifierByName("modifier_bus_rush_unit_lua")
	local main_hero = modifier_bus_rush_unit_lua:GetCaster()


	self.ability = self:GetAbility()
	self.dist = self.ability:GetSpecialValueFor( "skewer_radius" )
	self.damage = self.ability:GetSpecialValueFor( "skewer_damage" )
	self.duration = self.ability:GetSpecialValueFor( "slow_duration" )

	local parent = self:GetParent()
	local caster = self:GetCaster()
	local origin = caster:GetOrigin() + caster:GetForwardVector() * 500
	if not parent:IsRealHero() then
		parent:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				target_x = origin.x,
				target_y = origin.y,
				duration = 0.2,
				distance = 0,
				activity = ACT_DOTA_FLAIL,
			} -- kv
		)
	end

	parent:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_magnataur_skewer_lua_slow", -- modifier name
		{
			duration = self.duration
		} -- kv
	)

	local int6 = main_hero:FindAbilityByName("npc_dota_hero_magnataur_int6")
	if int6 ~= nil then 
		local damage_multiplier = int6:GetSpecialValueFor("damage_multiplier")
		self.damage = self.damage * damage_multiplier
		parent:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_magnataur_talent_int6", -- modifier name
		{
			duration = 10,
		}) -- kv
	end
	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = main_hero,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	local sound_cast = "Hero_Magnataur.Skewer.Target"
	EmitSoundOn( sound_cast, self:GetParent() )

	local str11 = main_hero:FindAbilityByName("npc_dota_hero_magnataur_str11")
	if str11 ~= nil then 
		parent:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{
			duration = 1.5
		} -- kv
	)
	end
end
