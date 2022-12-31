require( "libraries/hero_tables" )

local particles = {
	"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", -- modifier_creature_berserker
    "particles/items_fx/blink_dagger_start.vpcf", -- round manager
    "particles/items_fx/blink_dagger_end.vpcf", -- round manager
    "particles/items_fx/aegis_respawn_timer.vpcf", -- modifier_aegis
    "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", -- modifier_aegis_buff
    "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", -- modifier_aegis_buff
    "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_spindle_rig.vpcf", -- bet_manager
    "particles/econ/events/ti6/teleport_start_ti6.vpcf", -- bet_manager
    "particles/econ/events/ti6/teleport_start_ti6_lvl3_rays.vpcf", -- bet_manager
    "particles/bets/confirm_bet_gold.vpcf", -- bet_manager

	"particles/units/heroes/hero_techies/techies_suicide.vpcf", -- revenge mastery, test mode
    "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf" -- modifier_aegis
}

local particle_folders = {
    "particles/creature",
    "particles/items",
    "particles/custom",
    "particles/imported",
}

local particle_folders_map = {
    duos = {
        "particles/totem",
    },

    enfos = {
        "particles/5v5/custom",
    }
}


local sounds = {
    "soundevents/game_sounds.vsndevts",
    "soundevents/game_sounds_ui_imported.vsndevts",
    "soundevents/game_sounds_creeps.vsndevts",

    "soundevents/custom_sounds.vsndevts",
    "soundevents/custom_sounds_kv3.vsndevts",
    "soundevents/custom_soundboard_soundevents.vsndevts"
}

local function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            --Ignore those preloaded units
            if not string.find(key, "npc_precache_") then
               PrecacheEverythingFromTable( context, value )
            end
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle", value, context)
            end
            if string.find(value, "vmdl") then
                PrecacheResource( "model", value, context)
            end
            if string.find(value, "vsndevts") then            
                PrecacheResource( "soundfile", value, context)
            end
        end
    end
end

local function GetPrecacheUnitList()
    local unit_list = {}
    local map_name = GetMapName()
    
    if map_name == "ffa" or map_name == "demo" or map_name == "duos" then
        local round_data_path = "scripts/kv/round_data/"..GetMapName().."_"

        if map_name == "demo" then round_data_path = "scripts/kv/round_data/ffa_" end

        local regular_round_data = LoadKeyValues(round_data_path.."normal_rounds.txt")
        local boss_round_data = LoadKeyValues(round_data_path.."boss_rounds.txt")

        for tier, tier_rounds in pairs(regular_round_data) do
            for round_name, round_data in pairs(tier_rounds) do
                for key, data in pairs(round_data) do
                    unit_list[data.unit] = true
                end
            end
        end

        for tier, tier_rounds in pairs(boss_round_data) do
            for round_name, round_data in pairs(tier_rounds) do
                for key, data in pairs(round_data) do
                    unit_list[data.unit] = true
                end
            end
        end

        if map_name == "duos" then
            local totem_data = LoadKeyValues("scripts/kv/round_data/totems.txt")

            for _, totem in pairs(totem_data) do
                unit_list[totem] = true
            end
        end

    elseif map_name == "enfos" then
        for _, round_creeps in pairs(Enfos.round_creeps) do
            unit_list[round_creeps.basic_creep] = true
            unit_list[round_creeps.elite_creep] = true
        end
    end

    return unit_list
end

function PrecacheEverythingFromKV( context )
    local kv_files = {
        "scripts/npc/npc_items_custom.txt",
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            PrecacheEverythingFromTable( context, kvs)
        end
    end

    local unit_list = GetPrecacheUnitList()
    for unit_name, _ in pairs(unit_list) do
        PrecacheUnitByNameSync(unit_name, context, -1)
    end
end

function RollRandomHeroes()
    HeroBuilder.hero_tables = {}
    HeroBuilder.pending_precache_table = {}
    local team_layout = teams_layout[GetMapName()]
    local players_count = team_layout.player_count * #team_layout.teamlist
    if not players_count then players_count = 24 end
    for i=0, players_count + 1 do
        local str_hero_name = table.random(hero_tables.str_heroes)
        local agi_hero_name = table.random(hero_tables.agi_heroes)
        local int_hero_name = table.random(hero_tables.int_heroes)

        table.remove_item(hero_tables.str_heroes, str_hero_name)
        table.remove_item(hero_tables.agi_heroes, agi_hero_name)
        table.remove_item(hero_tables.int_heroes, int_hero_name)

        HeroBuilder.hero_tables[i] = {str_hero_name, agi_hero_name, int_hero_name}
    end
end

function RollRandomHeroesForAllPlayers(context)
    HeroBuilder.tCommonHerosTable = {}
    HeroBuilder.tCommonHerosTable["str"] = {}
    HeroBuilder.tCommonHerosTable["int"] = {}
    HeroBuilder.tCommonHerosTable["agi"] = {}
    local team_layout = teams_layout[GetMapName()]
    local players_count = team_layout.player_count * #team_layout.teamlist
    if not players_count then players_count = 24 end
    for i=0, players_count + 1 do
        local str_hero_name = table.random(hero_tables.str_heroes)
        local agi_hero_name = table.random(hero_tables.agi_heroes)
        local int_hero_name = table.random(hero_tables.int_heroes)

        table.remove_item(hero_tables.str_heroes, str_hero_name)
        table.remove_item(hero_tables.agi_heroes, agi_hero_name)
        table.remove_item(hero_tables.int_heroes, int_hero_name)

        table.insert(HeroBuilder.tCommonHerosTable["str"], str_hero_name)
        table.insert(HeroBuilder.tCommonHerosTable["agi"], agi_hero_name)
        table.insert(HeroBuilder.tCommonHerosTable["int"], int_hero_name)
    end
end

_G.PRECACHE_RESOURCE_LISTS = {}
function PrecacheResourceListAsync(resource_list, callback)
    if table.count(resource_list) > 0 then
        table.insert(_G.PRECACHE_RESOURCE_LISTS, resource_list)
        PrecacheItemByNameAsync("item_precache_dummy", callback)
    else
        callback()
    end
end

return function(context)
    PrecacheEverythingFromKV(context)

    local map_particles_folders = particle_folders_map[GetMapName()]
    if map_particles_folders then
        table.extend(particle_folders, map_particles_folders)
    end
    
    for _, p in pairs(particles) do
        PrecacheResource("particle", p, context)
    end
    for _, p in pairs(particle_folders) do
        PrecacheResource("particle_folder", p, context)
    end
    for _, p in pairs(sounds) do
        PrecacheResource("soundfile", p, context)
    end

    -- local heroeskv = LoadKeyValues("scripts/heroes.txt")
    -- for hero, _ in pairs(heroeskv) do
    --     PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_"..string.sub(hero,15)..".vsndevts", context )
    -- end
	
	RollRandomHeroes(context)
	RollRandomHeroesForAllPlayers(context)
end

