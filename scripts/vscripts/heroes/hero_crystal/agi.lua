npc_dota_hero_crystal_maiden_agi8 = class({})

LinkLuaModifier("modifier_npc_dota_hero_crystal_maiden_agi8", "heroes/hero_crystal/agi", LUA_MODIFIER_MOTION_NONE)


function npc_dota_hero_crystal_maiden_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_crystal_maiden_agi8"
end

if modifier_npc_dota_hero_crystal_maiden_agi8 == nil then  modifier_npc_dota_hero_crystal_maiden_agi8 = class({})
end

function modifier_npc_dota_hero_crystal_maiden_agi8:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_npc_dota_hero_crystal_maiden_agi8:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_npc_dota_hero_crystal_maiden_agi8:GetModifierBonusStats_Agility(params)
    return math.floor(self:GetStackCount()*1)
end

function modifier_npc_dota_hero_crystal_maiden_agi8:IsHidden()
	return false
end

function modifier_npc_dota_hero_crystal_maiden_agi8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_crystal_maiden_agi8:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_crystal_maiden_agi8:OnCreated(kv)
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