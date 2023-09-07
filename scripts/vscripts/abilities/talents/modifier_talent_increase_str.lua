modifier_talent_increase_str = class({})

function modifier_talent_increase_str:IsHidden()
	return false
end

function modifier_talent_increase_str:IsPurgable()
    return false
end
 
function modifier_talent_increase_str:RemoveOnDeath()
    return false
end
modifier_talent_increase_str.value = {0.1, 0.15, 0.2, 0.25, 0.3, 0.35}
function modifier_talent_increase_str:OnCreated(kv)
    self.str_per_creep = self.value[self:GetStackCount()]
end

function modifier_talent_increase_str:OnRefresh(kv)
    self.str_per_creep = self.value[self:GetStackCount()]
end


function modifier_talent_increase_str:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_talent_increase_str:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_talent_increase_str:GetModifierBonusStats_Strength(params)
    return math.floor(self:GetStackCount() * self.str_per_creep)
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