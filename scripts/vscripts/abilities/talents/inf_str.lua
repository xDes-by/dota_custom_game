LinkLuaModifier("modifier_Increase_str", "abilities/talents/inf_str", LUA_MODIFIER_MOTION_NONE)

Increase_str = class({})

function Increase_str:GetIntrinsicModifierName()
	return "modifier_Increase_str"
end

function Increase_str:GetAbilityTextureName()
	return "modifier_Increase_str"
end


if modifier_Increase_str == nil then 
    modifier_Increase_str = class({})
end

function modifier_Increase_str:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_Increase_str:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_Increase_str:GetModifierBonusStats_Strength(params)
    return math.floor(self:GetStackCount() / 5)
end

function modifier_Increase_str:IsHidden()
	return false
end

function modifier_Increase_str:IsPurgable()
    return false
end
 
function modifier_Increase_str:RemoveOnDeath()
    return false
end

function modifier_Increase_str:OnCreated(kv)
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