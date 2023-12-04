LinkLuaModifier("modifier_npc_dota_hero_spectre_str11", "heroes/hero_spectre/hp_boss", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_spectre_str11 = class({})

function npc_dota_hero_spectre_str11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_spectre_str11"
end

if modifier_npc_dota_hero_spectre_str11 == nil then 
    modifier_npc_dota_hero_spectre_str11 = class({})
end

function modifier_npc_dota_hero_spectre_str11:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_spectre_str11:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
        parent:Heal(1000, nil)
    end
end

function modifier_npc_dota_hero_spectre_str11:GetModifierExtraHealthBonus(params)
    return self:GetStackCount() * 1000
end

function modifier_npc_dota_hero_spectre_str11:IsHidden()
	return true
end

function modifier_npc_dota_hero_spectre_str11:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_spectre_str11:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_spectre_str11:OnCreated(kv)
end


all_bosses = {"npc_forest_boss","npc_village_boss","npc_mines_boss","npc_dust_boss","npc_swamp_boss","npc_snow_boss","npc_forest_boss_fake","npc_village_boss_fake","npc_mines_boss_fake","npc_dust_boss_fake","npc_swamp_boss_fake","npc_snow_boss_fake", "npc_boss_magma", "npc_cemetery_boss", "npc_boss_magma_fake", "npc_cemetery_boss_fake" ,"boss_1","boss_2","boss_3","boss_4","boss_5","boss_6","boss_7","boss_8","boss_9","boss_10","boss_11","boss_12","boss_13","boss_14","boss_15","boss_16","boss_17","boss_18","boss_19","boss_20"}


function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
	local attacker = params.attacker
	local unit_name = params.unit:GetUnitName()
	local abil = attacker:FindAbilityByName("npc_dota_hero_spectre_str11")             
	if abil ~= nil then 
		for _,current_name in pairs(all_bosses) do
			if current_name == unit_name and hero == attacker then
				return true
			end
		end
	end
end