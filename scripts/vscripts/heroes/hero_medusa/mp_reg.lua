LinkLuaModifier("modifier_npc_dota_hero_medusa_int11", "heroes/hero_medusa/mp_reg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_medusa_int11 = class({})

function npc_dota_hero_medusa_int11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_medusa_int11"
end

if modifier_npc_dota_hero_medusa_int11 == nil then 
    modifier_npc_dota_hero_medusa_int11 = class({})
end

function modifier_npc_dota_hero_medusa_int11:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_npc_dota_hero_medusa_int11:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
      --  self:IncrementStackCount()
       -- parent:CalculateStatBonus(true)
		
			parent:GiveMana(parent:GetMaxMana()/1000)
	
	end
end

function modifier_npc_dota_hero_medusa_int11:IsHidden()
	return false
end

function modifier_npc_dota_hero_medusa_int11:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_medusa_int11:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_medusa_int11:OnCreated(kv)
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