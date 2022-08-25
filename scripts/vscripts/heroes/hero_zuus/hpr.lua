LinkLuaModifier("modifier_npc_dota_hero_zuus_str10", "heroes/hero_zuus/hpr", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_zuus_str10 = class({})

function npc_dota_hero_zuus_str10:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_zuus_str10"
end

if modifier_npc_dota_hero_zuus_str10 == nil then 
    modifier_npc_dota_hero_zuus_str10 = class({})
end

function modifier_npc_dota_hero_zuus_str10:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_npc_dota_hero_zuus_str10:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
       -- parent:Heal(20, nil)
    end
end

function modifier_npc_dota_hero_zuus_str10:GetModifierConstantHealthRegen(params)
    return self:GetStackCount()*2
end

function modifier_npc_dota_hero_zuus_str10:GetModifierConstantManaRegen(params)
    return self:GetStackCount()
end

function modifier_npc_dota_hero_zuus_str10:IsHidden()
	return false
end

function modifier_npc_dota_hero_zuus_str10:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_zuus_str10:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_zuus_str10:OnCreated(kv)
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