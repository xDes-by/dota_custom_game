LinkLuaModifier("modifier_npc_dota_hero_arc_warden_agi11", "heroes/hero_arc/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_arc_warden_agi11 = class({})

function npc_dota_hero_arc_warden_agi11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_arc_warden_agi11"
end

modifier_npc_dota_hero_arc_warden_agi11 = class({})

function modifier_npc_dota_hero_arc_warden_agi11:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_npc_dota_hero_arc_warden_agi11:GetModifierPreAttack_BonusDamage(params)
    return 5 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_arc_warden_agi11:IsHidden()
	return true
end

function modifier_npc_dota_hero_arc_warden_agi11:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_arc_warden_agi11:RemoveOnDeath()
    return false
end
