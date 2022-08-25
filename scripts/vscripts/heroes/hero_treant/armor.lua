LinkLuaModifier("modifier_npc_dota_hero_treant_int9", "heroes/hero_treant/armor", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_treant_int9 = class({})

function npc_dota_hero_treant_int9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_treant_int9"
end

if modifier_npc_dota_hero_treant_int9 == nil then 
    modifier_npc_dota_hero_treant_int9 = class({})
end

function modifier_npc_dota_hero_treant_int9:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_npc_dota_hero_treant_int9:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    --    parent:Heal(10, nil)
    end
end

function modifier_npc_dota_hero_treant_int9:GetModifierPhysicalArmorBonus(params)
    return self:GetStackCount() /15
end

function modifier_npc_dota_hero_treant_int9:IsHidden()
	return true
end

function modifier_npc_dota_hero_treant_int9:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_treant_int9:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_treant_int9:OnCreated(kv)
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