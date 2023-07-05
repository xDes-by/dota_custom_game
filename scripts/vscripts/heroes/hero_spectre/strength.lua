LinkLuaModifier("modifier_npc_dota_hero_spectre_str8", "heroes/hero_spectre/strength", LUA_MODIFIER_MOTION_NONE)
npc_dota_hero_spectre_str8 = class({})

function npc_dota_hero_spectre_str8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_spectre_str8"
end

modifier_npc_dota_hero_spectre_str8 = class({})

function modifier_npc_dota_hero_spectre_str8:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_npc_dota_hero_spectre_str8:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_npc_dota_hero_spectre_str8:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end