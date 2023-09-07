modifier_talent_increase_int = class({})

function modifier_talent_increase_int:IsHidden()
	return false
end

function modifier_talent_increase_int:IsPurgable()
    return false
end
 
function modifier_talent_increase_int:RemoveOnDeath()
    return false
end
modifier_talent_increase_int.value = {0.1, 0.15, 0.2, 0.25, 0.3, 0.35}
function modifier_talent_increase_int:OnCreated(kv)
    self.int_per_creep = self.value[self:GetStackCount()]
end

function modifier_talent_increase_int:OnRefresh(kv)
    self.int_per_creep = self.value[self:GetStackCount()]
end

function modifier_talent_increase_int:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_talent_increase_int:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_talent_increase_int:GetModifierBonusStats_Intellect(params)
    return math.floor(self:GetStackCount() * self.int_per_creep)
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