LinkLuaModifier("modifier_npc_dota_hero_treant_int6", "heroes/hero_treant/as", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_treant_int6 = class({})

function npc_dota_hero_treant_int6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_treant_int6"
end

if modifier_npc_dota_hero_treant_int6 == nil then 
    modifier_npc_dota_hero_treant_int6 = class({})
end

function modifier_npc_dota_hero_treant_int6:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_npc_dota_hero_treant_int6:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    --    parent:Heal(10, nil)
    end
end

function modifier_npc_dota_hero_treant_int6:GetModifierAttackSpeedBonus_Constant(params)
    return self:GetStackCount() /2
end

function modifier_npc_dota_hero_treant_int6:IsHidden()
	return true
end

function modifier_npc_dota_hero_treant_int6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_treant_int6:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_treant_int6:OnCreated(kv)
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