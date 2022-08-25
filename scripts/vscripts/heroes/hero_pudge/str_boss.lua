LinkLuaModifier("modifier_npc_dota_hero_pudge_str_last", "heroes/hero_pudge/str_boss", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_pudge_str_last = class({})

function npc_dota_hero_pudge_str_last:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_pudge_str_last"
end

if modifier_npc_dota_hero_pudge_str_last == nil then 
    modifier_npc_dota_hero_pudge_str_last = class({})
end

function modifier_npc_dota_hero_pudge_str_last:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_npc_dota_hero_pudge_str_last:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys2(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_npc_dota_hero_pudge_str_last:GetModifierBonusStats_Strength(params)
    return self:GetStackCount() * 40
end

function modifier_npc_dota_hero_pudge_str_last:IsHidden()
	return true
end

function modifier_npc_dota_hero_pudge_str_last:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_pudge_str_last:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_pudge_str_last:OnCreated(kv)
end

all_bosses = {"npc_forest_boss","npc_village_boss","npc_mines_boss","npc_dust_boss","npc_swamp_boss","npc_snow_boss","npc_forest_boss_fake","npc_village_boss_fake","npc_mines_boss_fake","npc_dust_boss_fake","npc_swamp_boss_fake","npc_snow_boss_fake","boss_1","boss_2","boss_3","boss_4","boss_5","boss_6","boss_7","boss_8","boss_9","boss_10","boss_11","boss_12","boss_13","boss_14","boss_15","boss_16","boss_17","boss_18","boss_19","boss_20"}


function IsMyKilledBadGuys2(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
	local attacker = params.attacker
	local unit_name = params.unit:GetUnitName()
	local abil = attacker:FindAbilityByName("npc_dota_hero_pudge_str_last")             
	if abil ~= nil then 
		for _,current_name in pairs(all_bosses) do
			if current_name == unit_name and hero == attacker then
				return true
			end
		end
	end
end
