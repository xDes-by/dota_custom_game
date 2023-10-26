modifier_talent_increase_agi = class({})

function modifier_talent_increase_agi:IsHidden()
	return false
end

function modifier_talent_increase_agi:IsPurgable()
    return false
end
 
function modifier_talent_increase_agi:RemoveOnDeath()
    return false
end

function modifier_talent_increase_agi:OnCreated(kv)
    self.value = {0.1, 0.15, 0.2, 0.25, 0.3, 0.35}
    self.agi_per_creep = self.value[self:GetStackCount()]
end

function modifier_talent_increase_agi:OnRefresh(kv)
    self.agi_per_creep = self.value[self:GetStackCount()]
end

function modifier_talent_increase_agi:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_talent_increase_agi:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_talent_increase_agi:GetModifierBonusStats_Agility(params)
    return math.floor(self:GetStackCount() * self.agi_per_creep)
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