

if modifier_centaur_ult_hp == nil then 
    modifier_centaur_ult_hp = class({})
end

function modifier_centaur_ult_hp:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_centaur_ult_hp:OnDeath(params)
 if self:GetCaster():HasModifier("modifier_borrowed_time") then
		local parent = self:GetParent()
		if IsMyKilledBadGuys(parent, params) then
			self:IncrementStackCount()
			parent:CalculateStatBonus(true)
			parent:Heal(10, nil)
		end
	end
end

function modifier_centaur_ult_hp:GetModifierExtraHealthBonus(params)
    return self:GetStackCount() * 10
end

function modifier_centaur_ult_hp:IsHidden()
	return false
end

function modifier_centaur_ult_hp:IsPurgable()
    return false
end
 
function modifier_centaur_ult_hp:RemoveOnDeath()
    return false
end

function modifier_centaur_ult_hp:OnCreated(kv)
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