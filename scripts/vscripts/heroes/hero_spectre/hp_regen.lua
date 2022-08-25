LinkLuaModifier("npc_dota_hero_spectre_agi8", "heroes/hero_spectre/hp_regen", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_spectre_str7 = class({})

function npc_dota_hero_spectre_str7:GetIntrinsicModifierName()
	return "npc_dota_hero_spectre_agi8"
end

if npc_dota_hero_spectre_agi8 == nil then 
    npc_dota_hero_spectre_agi8 = class({})
end

function npc_dota_hero_spectre_agi8:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function npc_dota_hero_spectre_agi8:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
       -- parent:Heal(20, nil)
    end
end

function npc_dota_hero_spectre_agi8:GetModifierConstantHealthRegen(params)
    return self:GetStackCount() / 2
end

function npc_dota_hero_spectre_agi8:IsHidden()
	return true
end

function npc_dota_hero_spectre_agi8:IsPurgable()
    return false
end
 
function npc_dota_hero_spectre_agi8:RemoveOnDeath()
    return false
end

function npc_dota_hero_spectre_agi8:OnCreated(kv)
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