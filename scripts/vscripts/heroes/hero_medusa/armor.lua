LinkLuaModifier("modifier_npc_dota_hero_medusa_str8", "heroes/hero_medusa/armor", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_medusa_str8 = class({})

function npc_dota_hero_medusa_str8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_medusa_str8"
end

if modifier_npc_dota_hero_medusa_str8 == nil then 
    modifier_npc_dota_hero_medusa_str8 = class({})
end

function modifier_npc_dota_hero_medusa_str8:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_npc_dota_hero_medusa_str8:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
       -- parent:Heal(20, nil)
    end
end

function modifier_npc_dota_hero_medusa_str8:GetModifierPhysicalArmorBonus(params)
    return self:GetStackCount()/15
end

function modifier_npc_dota_hero_medusa_str8:IsHidden()
	return true
end

function modifier_npc_dota_hero_medusa_str8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_medusa_str8:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_medusa_str8:OnCreated(kv)
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