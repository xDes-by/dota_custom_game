modifier_talent_increase_str = class({})

LinkLuaModifier("modifier_talent_increase_str_counter", "abilities/talents/modifier_talent_increase_str", LUA_MODIFIER_MOTION_NONE)

function modifier_talent_increase_str:IsHidden()
	return true
end

function modifier_talent_increase_str:IsPurgable()
    return false
end
 
function modifier_talent_increase_str:RemoveOnDeath()
    return false
end

function modifier_talent_increase_str:OnCreated(kv)
    self.value = {0.1, 0.15, 0.2, 0.25, 0.3, 0.35}
    self:SetStackCount(1)
    self.parent = self:GetParent()
    self.creeps_killed = 0
    if not IsServer() then
        return
    end
    self.mod = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_talent_increase_str_counter", {})
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
        self.creeps_killed = self.creeps_killed + 1
        self.mod:SetStackCount(math.floor(self.creeps_killed * self.value[self:GetStackCount()]))
        parent:CalculateStatBonus(true)
    end
end

function modifier_talent_increase_str:GetModifierBonusStats_Strength(params)
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

modifier_talent_increase_str_counter = class({})
function modifier_talent_increase_str_counter:GetTexture()
    return "modifier_Increase_str"
end
--Classifications template
function modifier_talent_increase_str_counter:IsHidden()
    return false
end

function modifier_talent_increase_str_counter:IsDebuff()
    return false
end

function modifier_talent_increase_str_counter:IsPurgable()
    return false
end

function modifier_talent_increase_str_counter:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_talent_increase_str_counter:IsStunDebuff()
    return false
end

function modifier_talent_increase_str_counter:RemoveOnDeath()
    return false
end

function modifier_talent_increase_str_counter:DestroyOnExpire()
    return false
end