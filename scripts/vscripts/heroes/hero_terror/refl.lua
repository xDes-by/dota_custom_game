LinkLuaModifier("modifier_npc_dota_hero_terrorblade_int6", "heroes/hero_terror/refl", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_terrorblade_reflection_lua", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_terrorblade_int6 = class({})

function npc_dota_hero_terrorblade_int6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_terrorblade_int6"
end

if modifier_npc_dota_hero_terrorblade_int6 == nil then 
    modifier_npc_dota_hero_terrorblade_int6 = class({})
end

function modifier_npc_dota_hero_terrorblade_int6:IsHidden()
	return true
end

function modifier_npc_dota_hero_terrorblade_int6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_terrorblade_int6:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_terrorblade_int6:OnCreated(kv)
self:StartIntervalThink(3)
end

function modifier_npc_dota_hero_terrorblade_int6:OnIntervalThink()
local ability = self:GetCaster():FindAbilityByName( "terrorblade_reflection_lua" )
				if ability~=nil and ability:GetLevel()>=1 then
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()

	local radius = 700

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	--for _,enemy in pairs(enemies) do
	enemy = enemies[1]
	if enemy:IsAlive() and not enemy:HasModifier("modifier_terrorblade_reflection_lua") then
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_terrorblade_reflection_lua", -- modifier name
			{ duration = 2 } -- kv
		)
	--end
	end
end
end
