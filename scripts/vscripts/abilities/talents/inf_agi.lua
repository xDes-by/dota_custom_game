LinkLuaModifier("modifier_Increase_agi", "abilities/talents/inf_agi", LUA_MODIFIER_MOTION_NONE)

Increase_agi = class({})

function Increase_agi:GetIntrinsicModifierName()
	return "modifier_Increase_agi"
end

if modifier_Increase_agi == nil then 
    modifier_Increase_agi = class({})
end

function modifier_Increase_agi:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_Increase_agi:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_Increase_agi:GetModifierBonusStats_Agility(params)
    return math.floor(self:GetStackCount() / 5)
end

function modifier_Increase_agi:IsHidden()
	return false
end

function modifier_Increase_agi:IsPurgable()
    return false
end
 
function modifier_Increase_agi:RemoveOnDeath()
    return false
end

function modifier_Increase_agi:OnCreated(kv)
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