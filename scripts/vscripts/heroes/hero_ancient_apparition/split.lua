LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_agi9", "heroes/hero_ancient_apparition/split", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_ancient_apparition_agi9 = class({})

function npc_dota_hero_ancient_apparition_agi9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_ancient_apparition_agi9"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_ancient_apparition_agi9 = class({})

function modifier_npc_dota_hero_ancient_apparition_agi9:IsHidden()
end

function modifier_npc_dota_hero_ancient_apparition_agi9:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_ancient_apparition_agi9:IsPurgable( kv )
	return false
end


function modifier_npc_dota_hero_ancient_apparition_agi9:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

function modifier_npc_dota_hero_ancient_apparition_agi9:OnAttack( keys )
    if not IsServer() then return end
    local attacker = self:GetParent()
  
    if attacker ~= keys.attacker then return end

    if attacker:PassivesDisabled() or attacker:IsIllusion() then return end

    local target = keys.target

	local range_total = attacker:Script_GetAttackRange() + 100
	if attacker == self:GetParent() and target and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown then	
		local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, range_total, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
				if enemy ~= target and enemy:HasModifier("modifier_ancient_apparition_cold_feet_lua_freeze") then
					attacker:PerformAttack(enemy, true, true, true, false, true, false, false)
				end
			end
		end
	end
end