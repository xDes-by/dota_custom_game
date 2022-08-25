LinkLuaModifier("modifier_npc_dota_hero_medusa_str6", "heroes/hero_medusa/regen", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_medusa_str6 = class({})

function npc_dota_hero_medusa_str6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_medusa_str6"
end

if modifier_npc_dota_hero_medusa_str6 == nil then 
    modifier_npc_dota_hero_medusa_str6 = class({})
end

function modifier_npc_dota_hero_medusa_str6:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_npc_dota_hero_medusa_str6:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
       -- parent:Heal(20, nil)
    end
end

function modifier_npc_dota_hero_medusa_str6:GetModifierConstantManaRegen(params)
    return self:GetStackCount()/2
end

function modifier_npc_dota_hero_medusa_str6:IsHidden()
	return true
end

function modifier_npc_dota_hero_medusa_str6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_medusa_str6:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_medusa_str6:OnCreated(kv)
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