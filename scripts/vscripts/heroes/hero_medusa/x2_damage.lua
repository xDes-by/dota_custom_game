LinkLuaModifier("modifier_npc_dota_hero_medusa_agi6", "heroes/hero_medusa/x2_damage", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_medusa_agi6 = class({})

function npc_dota_hero_medusa_agi6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_medusa_agi6"
end

if modifier_npc_dota_hero_medusa_agi6 == nil then 
    modifier_npc_dota_hero_medusa_agi6 = class({})
end

function modifier_npc_dota_hero_medusa_agi6:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_npc_dota_hero_medusa_agi6:IsHidden()
	return true
end

function modifier_npc_dota_hero_medusa_agi6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_medusa_agi6:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_medusa_agi6:OnCreated(kv)
self.radius = self:GetCaster():Script_GetAttackRange()
self:StartIntervalThink( 0.1 )
end

function modifier_npc_dota_hero_medusa_agi6:OnIntervalThink()
	local ability = self:GetCaster():FindAbilityByName( "medusa_split_shot_lua" )
		if ability~=nil and ability:GetLevel()>=1 then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		if #enemies < 2 then
		damage_red = 100
		else 
		damage_red = 0
		end
	end
end

function modifier_npc_dota_hero_medusa_agi6:GetModifierDamageOutgoing_Percentage(params)
	return damage_red
end