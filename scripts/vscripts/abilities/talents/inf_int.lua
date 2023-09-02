LinkLuaModifier("modifier_Increase_int", "abilities/talents/inf_int", LUA_MODIFIER_MOTION_NONE)

Increase_int = class({})

function Increase_int:GetIntrinsicModifierName()
	return "modifier_Increase_int"
end

function Increase_int:GetAbilityTextureName()
	return "modifier_Increase_int"
end

modifier_Increase_int = class({})

function modifier_Increase_int:IsHidden()
	return false
end

function modifier_Increase_int:IsPurgable()
    return false
end
 
function modifier_Increase_int:RemoveOnDeath()
    return false
end

function modifier_Increase_int:OnCreated(kv)
    self.int_per_creep = self:GetAbility():GetSpecialValueFor("int_per_creep")
end

function modifier_Increase_int:OnRefresh(kv)
    self.int_per_creep = self:GetAbility():GetSpecialValueFor("int_per_creep")
end

function modifier_Increase_int:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_Increase_int:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_Increase_int:GetModifierBonusStats_Intellect(params)
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