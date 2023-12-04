modifier_talent_increase_int = class({})

LinkLuaModifier("modifier_talent_increase_int_counter", "abilities/talents/modifier_talent_increase_int", LUA_MODIFIER_MOTION_NONE)

function modifier_talent_increase_int:IsHidden()
	return true
end

function modifier_talent_increase_int:IsPurgable()
    return false
end
 
function modifier_talent_increase_int:RemoveOnDeath()
    return false
end

function modifier_talent_increase_int:OnCreated(kv)
    self.value = {0.1, 0.15, 0.2, 0.25, 0.3, 0.35}
    self:SetStackCount(1)
    self.parent = self:GetParent()
    self.creeps_killed = 0
    if not IsServer() then
        return
    end
    self.mod = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_talent_increase_int_counter", {})
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
        self.creeps_killed = self.creeps_killed + 1
        self.mod:SetStackCount(math.floor(self.creeps_killed * self.value[self:GetStackCount()]))
        parent:CalculateStatBonus(true)
    end
end

function modifier_talent_increase_int:GetModifierBonusStats_Intellect(params)
    return math.floor(self.creeps_killed * self.value[self:GetStackCount()])
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

modifier_talent_increase_int_counter = class({})
function modifier_talent_increase_int_counter:GetTexture()
    return "modifier_Increase_int"
end
--Classifications template
function modifier_talent_increase_int_counter:IsHidden()
    return false
end

function modifier_talent_increase_int_counter:IsDebuff()
    return false
end

function modifier_talent_increase_int_counter:IsPurgable()
    return false
end

function modifier_talent_increase_int_counter:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_talent_increase_int_counter:IsStunDebuff()
    return false
end

function modifier_talent_increase_int_counter:RemoveOnDeath()
    return false
end

function modifier_talent_increase_int_counter:DestroyOnExpire()
    return false
end