LinkLuaModifier("modifier_npc_dota_hero_sniper_str11", "heroes/hero_sniper/sniper_tank/hp_regen", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_sniper_str11 = class({})

function npc_dota_hero_sniper_str11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_sniper_str11"
end

if modifier_npc_dota_hero_sniper_str11 == nil then 
    modifier_npc_dota_hero_sniper_str11 = class({})
end

function modifier_npc_dota_hero_sniper_str11:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_npc_dota_hero_sniper_str11:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_npc_dota_hero_sniper_str11:GetModifierConstantHealthRegen(params)
    return self:GetStackCount()
end

function modifier_npc_dota_hero_sniper_str11:IsHidden()
	return false
end

function modifier_npc_dota_hero_sniper_str11:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_sniper_str11:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_sniper_str11:OnCreated(kv)
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