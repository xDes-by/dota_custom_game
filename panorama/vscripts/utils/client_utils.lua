-- Has Aghanim's Shard
function C_DOTA_BaseNPC:HasShard()
	 return self:HasModifier("modifier_item_aghanims_shard")
end

function C_DOTA_BaseNPC:HasTalent(talent_name)
    if not self or self:IsNull() then return end

    local talent = self:FindAbilityByName(talent_name)
    if talent and talent:GetLevel() > 0 then return true end
end

function C_DOTA_BaseNPC:FindTalentValue(talent_name, key)
    if self:HasTalent(talent_name) then
        local value_name = key or "value"
        return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
    end
    return 0
end

function C_DOTA_BaseNPC:IsDueling()
	return self:HasModifier("modifier_hero_dueling")
end

ENFOS_ARENA_RADIANT = 1
ENFOS_ARENA_PVP = 2
ENFOS_ARENA_DIRE = 3

function C_DOTA_BaseNPC:GetEnfosArena()
    local unit_loc = self:GetAbsOrigin()

    if unit_loc.x < -4000 then
        return ENFOS_ARENA_RADIANT
    elseif unit_loc.x > 4000 then
        return ENFOS_ARENA_DIRE
    else
        return ENFOS_ARENA_PVP
    end
end

function GetEnfosArena(location)
    if location.x < -4000 then
        return ENFOS_ARENA_RADIANT
    elseif location.x > 4000 then
        return ENFOS_ARENA_DIRE
    else
        return ENFOS_ARENA_PVP
    end
end

function GetEnfosArenaForTeam(team)
    if team == DOTA_TEAM_GOODGUYS then
        return ENFOS_ARENA_RADIANT
    elseif team == DOTA_TEAM_BADGUYS then
        return ENFOS_ARENA_DIRE
    end
end

function RegisterSpecialValuesModifier(modifier)
    local parent = modifier:GetParent()

    parent.special_values_modifiers = parent.special_values_modifiers or {}
    table.insert(parent.special_values_modifiers, modifier)
end
