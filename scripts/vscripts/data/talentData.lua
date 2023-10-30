function GetHeroTalentsData(heroname)
    local data = heroTalentsData[heroname]
    for key, value in pairs(basicTalentsData) do
        data[key] = value
    end
    return data
end

basicTalentsData = {
    -------------------- STR -----------------------------------------------------------	
    modifier_talent_hp_per_level = {
        place = {"str 1"}, url = "/basic/str/str-talant-1.png", name = "modifier_talent_hp_per_level",
    },
    modifier_talent_hp_regen_level = {
        place = {"str 2"}, url = "/basic/str/str-talant-2.png", name = "modifier_talent_hp_regen_level",
    },
    modifier_talent_sheeld = {
        place = {"str 3"}, url = "/basic/str/str-talant-3.png", name = "modifier_talent_sheeld",
    },
    modifier_talent_armor_per_level = {
        place = {"str 4"}, url = "/basic/str/str-talant-4.png", name = "modifier_talent_armor_per_level",
    },
    modifier_talent_increase_str = {
        place = {"str 5"}, url = "/basic/str/str-talant-5.png", name = "modifier_talent_increase_str",
    },
    -------------------- AGI -----------------------------------------------------------	
    modifier_talent_armor_curruption = {
        place = {"agi 1"}, url = "/basic/agi/agi-talant-1.png", name = "modifier_talent_armor_curruption",
    },
    modifier_talent_dmg_per_level = {
        place = {"agi 2"}, url = "/basic/agi/agi-talant-2.png", name = "modifier_talent_dmg_per_level",
    },
    modifier_talent_all_evasion = {
        place = {"agi 3"}, url = "/basic/agi/agi-talant-3.png", name = "modifier_talent_all_evasion",
    },
    modifier_talent_base_attack_time = {
        place = {"agi 4"}, url = "/basic/agi/agi-talant-4.png", name = "modifier_talent_base_attack_time",
    },
    modifier_talent_increase_agi = {
        place = {"agi 5"}, url = "/basic/agi/agi-talant-5.png", name = "modifier_talent_increase_agi",
    },
    -------------------- INT -----------------------------------------------------------			
    modifier_talent_magic_damage = {
        place = {"int 1"}, url = "/basic/int/int-talant-1.png", name = "modifier_talent_magic_damage",
    },
    modifier_talent_mp_regen_level = {
        place = {"int 2"}, url = "/basic/int/int-talant-2.png", name = "modifier_talent_mp_regen_level",
    },
    modifier_talent_m_resist = {
        place = {"int 3"}, url = "/basic/int/int-talant-3.png", name = "modifier_talent_m_resist",
    },
    modifier_talent_manacost = {
        place = {"int 4"}, url = "/basic/int/int-talant-4.png", name = "modifier_talent_manacost",
    },
    modifier_talent_increase_int = {
        place = {"int 5"}, url = "/basic/int/int-talant-5.png", name = "modifier_talent_increase_int",
    },
    -------------------- DON -----------------------------------------------------------	
    modifier_don1 = {
        place = {"don 1"}, url = "/basic/don/don-talant-1.png", name = "modifier_don1",
    },
    modifier_don2 = {
        place = {"don 2"}, url = "/basic/don/don-talant-2.png", name = "modifier_don2",
    },
    modifier_don3 = {
        place = {"don 3"}, url = "/basic/don/don-talant-3.png", name = "modifier_don3",
    },
    modifier_don4 = {
        place = {"don 4"}, url = "/basic/don/don-talant-4.png", name = "modifier_don4",
    },
    modifier_don5 = {
        place = {"don 5"}, url = "/basic/don/don-talant-5.png", name = "modifier_don5",
    },
    modifier_don6 = {
        place = {"don 6"}, url = "/basic/don/don-talant-6.png", name = "modifier_don6",
    },
    modifier_don7 = {
        place = {"don 7"}, url = "/basic/don/don-talant-7.png", name = "modifier_don7",
    },
    modifier_don8 = {
        place = {"don 8"}, url = "/basic/don/don-talant-8.png", name = "modifier_don8",
    },
    modifier_don9 = {
        place = {"don 9"}, url = "/basic/don/don-talant-9.png", name = "modifier_don9",
    },
    modifier_don10 = {
        place = {"don 10"}, url = "/basic/don/don-talant-10.png", name = "modifier_don10",
    },
    modifier_don11 = {
        place = {"don 11"}, url = "/basic/don/don-talant-11.png", name = "modifier_don11",
    }, 
    modifier_don_last = {
        place = {"don 12"}, url = "/basic/don/don-talant-12.png", name = "modifier_don12",
    },
    modifier_don_13 = {
        place = {"don 13"}, url = "/basic/don/don-talant-12.png", name = "modifier_don13",
    },
}

heroTalentsData = {
    npc_dota_hero_axe = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_axe_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_axe/str/str-talant-6.png", name = "npc_dota_hero_axe_str6",
        },
        npc_dota_hero_axe_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_axe/str/str-talant-7.png", name = "npc_dota_hero_axe_str7",
        },
        npc_dota_hero_axe_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_axe/str/str-talant-13.png", name = "npc_dota_hero_axe_str8",
        },
        npc_dota_hero_axe_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_axe/str/str-talant-13.png", name = "npc_dota_hero_axe_str9",
        },
        npc_dota_hero_axe_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_axe/str/str-talant-10.png", name = "npc_dota_hero_axe_str10",
        },
        npc_dota_hero_axe_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_axe/str/str-talant-11.png", name = "npc_dota_hero_axe_str11",
        },
        npc_dota_hero_axe_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_axe/str/str-talant-13.png", name = "npc_dota_hero_axe_str12",
        },       
        -------------------- AGI -----------------------------------------------------------	
        npc_dota_hero_axe_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_axe/agi/agi-talant-9.png", name = "npc_dota_hero_axe_agi6", 
        },
        npc_dota_hero_axe_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_axe/agi/agi-talant-7.png", name = "npc_dota_hero_axe_agi7", 
        },
        npc_dota_hero_axe_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_axe/agi/agi-talant-12.png", name = "npc_dota_hero_axe_agi8", 
        }, 
        npc_dota_hero_axe_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_axe/agi/agi-talant-9.png", name = "npc_dota_hero_axe_agi9", 
        },
        npc_dota_hero_axe_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_axe/agi/agi-talant-12.png", name = "npc_dota_hero_axe_agi10",
        },
        npc_dota_hero_axe_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_axe/agi/agi-talant-11.png", name = "npc_dota_hero_axe_agi11", 
        },
        npc_dota_hero_axe_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_axe/agi/agi-talant-12.png", name = "npc_dota_hero_axe_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_axe_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_axe/int/int-talant-6.png", name = "npc_dota_hero_axe_int6",
        },
        npc_dota_hero_axe_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_axe/int/int-talant-7.png", name = "npc_dota_hero_axe_int7",
        },
        npc_dota_hero_axe_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_axe/int/int-talant-6.png", name = "npc_dota_hero_axe_int8",
        }, 
        npc_dota_hero_axe_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_axe/int/int-talant-9.png", name = "npc_dota_hero_axe_int9",
        },
        npc_dota_hero_axe_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_axe/int/int-talant-10.png", name = "npc_dota_hero_axe_int10",
        },
        npc_dota_hero_axe_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_axe/int/int-talant-6.png", name = "npc_dota_hero_axe_int11",
        },
        npc_dota_hero_axe_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_axe/int/int-talant-12.png", name = "npc_dota_hero_axe_int12",
        },
    },
    npc_dota_hero_arc_warden = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_arc_warden_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_arc_warden/str/str-talant-6.png", name = "npc_dota_hero_arc_warden_str6",
        },
        npc_dota_hero_arc_warden_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_arc_warden/str/str-talant-7.png", name = "npc_dota_hero_arc_warden_str7",
        },
        npc_dota_hero_arc_warden_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_arc_warden/str/str-talant-8.png", name = "npc_dota_hero_arc_warden_str8",
        },
        npc_dota_hero_arc_warden_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_arc_warden/str/str-talant-9.png", name = "npc_dota_hero_arc_warden_str9",
        },
        npc_dota_hero_arc_warden_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_arc_warden/str/str-talant-10.png", name = "npc_dota_hero_arc_warden_str10",
        },
        npc_dota_hero_arc_warden_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_arc_warden/str/str-talant-11.png", name = "npc_dota_hero_arc_warden_str11",
        },
        npc_dota_hero_arc_warden_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_arc_warden/str/str-talant-12.png", name = "npc_dota_hero_arc_warden_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_arc_warden_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-6.png", name = "npc_dota_hero_arc_warden_agi6",
        },
        npc_dota_hero_arc_warden_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-7.png", name = "npc_dota_hero_arc_warden_agi7",
        },
        npc_dota_hero_arc_warden_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-8.png", name = "npc_dota_hero_arc_warden_agi8",
        },
        npc_dota_hero_arc_warden_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-9.png", name = "npc_dota_hero_arc_warden_agi9",
        },
        npc_dota_hero_arc_warden_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-10.png", name = "npc_dota_hero_arc_warden_agi10",
        },
        npc_dota_hero_arc_warden_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-11.png", name = "npc_dota_hero_arc_warden_agi11",
        },
        npc_dota_hero_arc_warden_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_arc_warden/agi/agi-talant-12.png", name = "npc_dota_hero_arc_warden_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_arc_warden_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_arc_warden/int/int-talant-6.png", name = "npc_dota_hero_arc_warden_int6",
        },
        npc_dota_hero_arc_warden_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_arc_warden/int/int-talant-7.png", name = "npc_dota_hero_arc_warden_int7",
        },
        npc_dota_hero_arc_warden_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_arc_warden/int/int-talant-8.png", name = "npc_dota_hero_arc_warden_int8",
        },
        npc_dota_hero_arc_warden_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_arc_warden/int/int-talant-9.png", name = "npc_dota_hero_arc_warden_int9",
        },
        npc_dota_hero_arc_warden_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_arc_warden/int/int-talant-10.png", name = "npc_dota_hero_arc_warden_int10",
        },
        npc_dota_hero_arc_warden_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_arc_warden/int/int-talant-11.png", name = "npc_dota_hero_arc_warden_int11",
        },
        npc_dota_hero_arc_warden_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_arc_warden/int/int-talant-12.png", name = "npc_dota_hero_arc_warden_int12",
        },
    },
    npc_dota_hero_bristleback = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_bristleback_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_bristleback/str/str-talant-6.png", name = "npc_dota_hero_bristleback_str6",
        },
        npc_dota_hero_bristleback_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_bristleback/str/str-talant-7.png", name = "npc_dota_hero_bristleback_str7",
        },
        npc_dota_hero_bristleback_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_bristleback/str/str-talant-8.png", name = "npc_dota_hero_bristleback_str8",
        },
        npc_dota_hero_bristleback_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_bristleback/str/str-talant-9.png", name = "npc_dota_hero_bristleback_str9",
        },
        npc_dota_hero_bristleback_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_bristleback/str/str-talant-10.png", name = "npc_dota_hero_bristleback_str10",
        },
        npc_dota_hero_bristleback_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_bristleback/str/str-talant-11.png", name = "npc_dota_hero_bristleback_str11",
        },
        npc_dota_hero_bristleback_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_bristleback/str/str-talant-12.png", name = "npc_dota_hero_bristleback_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_bristleback_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-6.png", name = "npc_dota_hero_bristleback_agi6",
        },
        npc_dota_hero_bristleback_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-7.png", name = "npc_dota_hero_bristleback_agi7",
        },
        npc_dota_hero_bristleback_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-8.png", name = "npc_dota_hero_bristleback_agi8",
        },
        npc_dota_hero_bristleback_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-9.png", name = "npc_dota_hero_bristleback_agi9",
        },
        npc_dota_hero_bristleback_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-10.png", name = "npc_dota_hero_bristleback_agi10",
        },
        npc_dota_hero_bristleback_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-11.png", name = "npc_dota_hero_bristleback_agi11",
        },
        npc_dota_hero_bristleback_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_bristleback/agi/agi-talant-12.png", name = "npc_dota_hero_bristleback_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_bristleback_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_bristleback/int/int-talant-6.png", name = "npc_dota_hero_bristleback_int6",
        },
        npc_dota_hero_bristleback_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_bristleback/int/int-talant-7.png", name = "npc_dota_hero_bristleback_int7",
        },
        npc_dota_hero_bristleback_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_bristleback/int/int-talant-8.png", name = "npc_dota_hero_bristleback_int8",
        },
        npc_dota_hero_bristleback_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_bristleback/int/int-talant-9.png", name = "npc_dota_hero_bristleback_int9",
        },
        npc_dota_hero_bristleback_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_bristleback/int/int-talant-10.png", name = "npc_dota_hero_bristleback_int10",
        },
        npc_dota_hero_bristleback_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_bristleback/int/int-talant-11.png", name = "npc_dota_hero_bristleback_int11",
        },
        npc_dota_hero_bristleback_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_bristleback/int/int-talant-12.png", name = "npc_dota_hero_bristleback_int12",
        },
    },
    npc_dota_hero_centaur = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_centaur_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_centaur/str/str-talant-6.png", name = "npc_dota_hero_centaur_str6",
        },
        npc_dota_hero_centaur_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_centaur/str/str-talant-7.png", name = "npc_dota_hero_centaur_str7",
        },
        npc_dota_hero_centaur_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_centaur/str/str-talant-8.png", name = "npc_dota_hero_centaur_str8",
        },
        npc_dota_hero_centaur_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_centaur/str/str-talant-9.png", name = "npc_dota_hero_centaur_str9",
        },
        npc_dota_hero_centaur_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_centaur/str/str-talant-10.png", name = "npc_dota_hero_centaur_str10",
        },
        npc_dota_hero_centaur_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_centaur/str/str-talant-11.png", name = "npc_dota_hero_centaur_str11",
        },
        npc_dota_hero_centaur_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_centaur/str/str-talant-12.png", name = "npc_dota_hero_centaur_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_centaur_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_centaur/agi/agi-talant-6.png", name = "npc_dota_hero_centaur_agi6",
        },
        npc_dota_hero_centaur_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_centaur/agi/agi-talant-7.png", name = "npc_dota_hero_centaur_agi7",
        },
        npc_dota_hero_centaur_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_centaur/agi/agi-talant-8.png", name = "npc_dota_hero_centaur_agi8",
        },
        npc_dota_hero_centaur_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_centaur/agi/agi-talant-9.png", name = "npc_dota_hero_centaur_agi9",
        },
        npc_dota_hero_centaur_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_centaur/agi/agi-talant-10.png", name = "npc_dota_hero_centaur_agi10",
        },
        npc_dota_hero_centaur_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_centaur/agi/agi-talant-11.png", name = "npc_dota_hero_centaur_agi11",
        },
        npc_dota_hero_centaur_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_centaur/agi/agi-talant-12.png", name = "npc_dota_hero_centaur_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_centaur_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_centaur/int/int-talant-6.png", name = "npc_dota_hero_centaur_int6",
        },
        npc_dota_hero_centaur_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_centaur/int/int-talant-7.png", name = "npc_dota_hero_centaur_int7",
        },
        npc_dota_hero_centaur_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_centaur/int/int-talant-8.png", name = "npc_dota_hero_centaur_int8",
        },
        npc_dota_hero_centaur_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_centaur/int/int-talant-9.png", name = "npc_dota_hero_centaur_int9",
        },
        npc_dota_hero_centaur_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_centaur/int/int-talant-10.png", name = "npc_dota_hero_centaur_int10",
        },
        npc_dota_hero_centaur_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_centaur/int/int-talant-11.png", name = "npc_dota_hero_centaur_int11",
        },
        npc_dota_hero_centaur_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_centaur/int/int-talant-12.png", name = "npc_dota_hero_centaur_int12",
        },
    },
    npc_dota_hero_dazzle = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_dazzle_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_dazzle/str/str-talant-6.png", name = "npc_dota_hero_dazzle_str6",
        },
        npc_dota_hero_dazzle_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_dazzle/str/str-talant-7.png", name = "npc_dota_hero_dazzle_str7",
        },
        npc_dota_hero_dazzle_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_dazzle/str/str-talant-8.png", name = "npc_dota_hero_dazzle_str8",
        },
        npc_dota_hero_dazzle_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_dazzle/str/str-talant-9.png", name = "npc_dota_hero_dazzle_str9",
        },
        npc_dota_hero_dazzle_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_dazzle/str/str-talant-10.png", name = "npc_dota_hero_dazzle_str10",
        },
        npc_dota_hero_dazzle_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_dazzle/str/str-talant-11.png", name = "npc_dota_hero_dazzle_str11",
        },
        npc_dota_hero_dazzle_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_dazzle/str/str-talant-12.png", name = "npc_dota_hero_dazzle_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_dazzle_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-6.png", name = "npc_dota_hero_dazzle_agi6",
        },
        npc_dota_hero_dazzle_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-7.png", name = "npc_dota_hero_dazzle_agi7",
        },
        npc_dota_hero_dazzle_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-8.png", name = "npc_dota_hero_dazzle_agi8",
        },
        npc_dota_hero_dazzle_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-9.png", name = "npc_dota_hero_dazzle_agi9",
        },
        npc_dota_hero_dazzle_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-10.png", name = "npc_dota_hero_dazzle_agi10",
        },
        npc_dota_hero_dazzle_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-11.png", name = "npc_dota_hero_dazzle_agi11",
        },
        npc_dota_hero_dazzle_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_dazzle/agi/agi-talant-12.png", name = "npc_dota_hero_dazzle_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_dazzle_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_dazzle/int/int-talant-6.png", name = "npc_dota_hero_dazzle_int6",
        },
        npc_dota_hero_dazzle_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_dazzle/int/int-talant-7.png", name = "npc_dota_hero_dazzle_int7",
        },
        npc_dota_hero_dazzle_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_dazzle/int/int-talant-8.png", name = "npc_dota_hero_dazzle_int8",
        },
        npc_dota_hero_dazzle_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_dazzle/int/int-talant-9.png", name = "npc_dota_hero_dazzle_int9",
        },
        npc_dota_hero_dazzle_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_dazzle/int/int-talant-10.png", name = "npc_dota_hero_dazzle_int10",
        },
        npc_dota_hero_dazzle_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_dazzle/int/int-talant-11.png", name = "npc_dota_hero_dazzle_int11",
        },
        npc_dota_hero_dazzle_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_dazzle/int/int-talant-12.png", name = "npc_dota_hero_dazzle_int12",
        },
    },
    npc_dota_hero_dragon_knight = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_dragon_knight_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-6.png", name = "npc_dota_hero_dragon_knight_str6",
        },
        npc_dota_hero_dragon_knight_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-7.png", name = "npc_dota_hero_dragon_knight_str7",
        },
        npc_dota_hero_dragon_knight_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-8.png", name = "npc_dota_hero_dragon_knight_str8",
        },
        npc_dota_hero_dragon_knight_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-9.png", name = "npc_dota_hero_dragon_knight_str9",
        },
        npc_dota_hero_dragon_knight_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-10.png", name = "npc_dota_hero_dragon_knight_str10",
        },
        npc_dota_hero_dragon_knight_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-11.png", name = "npc_dota_hero_dragon_knight_str11",
        },
        npc_dota_hero_dragon_knight_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_dragon_knight/str/str-talant-12.png", name = "npc_dota_hero_dragon_knight_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_dragon_knight_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-6.png", name = "npc_dota_hero_dragon_knight_agi6",
        },
        npc_dota_hero_dragon_knight_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-7.png", name = "npc_dota_hero_dragon_knight_agi7",
        },
        npc_dota_hero_dragon_knight_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-8.png", name = "npc_dota_hero_dragon_knight_agi8",
        },
        npc_dota_hero_dragon_knight_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-9.png", name = "npc_dota_hero_dragon_knight_agi9",
        },
        npc_dota_hero_dragon_knight_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-10.png", name = "npc_dota_hero_dragon_knight_agi10",
        },
        npc_dota_hero_dragon_knight_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-11.png", name = "npc_dota_hero_dragon_knight_agi11",
        },
        npc_dota_hero_dragon_knight_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_dragon_knight/agi/agi-talant-12.png", name = "npc_dota_hero_dragon_knight_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_dragon_knight_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-6.png", name = "npc_dota_hero_dragon_knight_int6",
        },
        npc_dota_hero_dragon_knight_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-7.png", name = "npc_dota_hero_dragon_knight_int7",
        },
        npc_dota_hero_dragon_knight_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-8.png", name = "npc_dota_hero_dragon_knight_int8",
        },
        npc_dota_hero_dragon_knight_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-9.png", name = "npc_dota_hero_dragon_knight_int9",
        },
        npc_dota_hero_dragon_knight_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-10.png", name = "npc_dota_hero_dragon_knight_int10",
        },
        npc_dota_hero_dragon_knight_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-11.png", name = "npc_dota_hero_dragon_knight_int11",
        },
        npc_dota_hero_dragon_knight_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_dragon_knight/int/int-talant-12.png", name = "npc_dota_hero_dragon_knight_int12",
        },
    },
    npc_dota_hero_drow_ranger = {      
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_drow_ranger_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-6.png", name = "npc_dota_hero_drow_ranger_str6",
        },
        npc_dota_hero_drow_ranger_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-7.png", name = "npc_dota_hero_drow_ranger_str7",
        },
        npc_dota_hero_drow_ranger_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-8.png", name = "npc_dota_hero_drow_ranger_str8",
        },
        npc_dota_hero_drow_ranger_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-9.png", name = "npc_dota_hero_drow_ranger_str9",
        },
        npc_dota_hero_drow_ranger_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-10.png", name = "npc_dota_hero_drow_ranger_str10",
        },
        npc_dota_hero_drow_ranger_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-11.png", name = "npc_dota_hero_drow_ranger_str11",
        },
        npc_dota_hero_drow_ranger_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_drow_ranger/str/str-talant-12.png", name = "npc_dota_hero_drow_ranger_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_drow_ranger_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-6.png", name = "npc_dota_hero_drow_ranger_agi6",
        },
        npc_dota_hero_drow_ranger_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-7.png", name = "npc_dota_hero_drow_ranger_agi7",
        },
        npc_dota_hero_drow_ranger_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-8.png", name = "npc_dota_hero_drow_ranger_agi8",
        },
        npc_dota_hero_drow_ranger_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-9.png", name = "npc_dota_hero_drow_ranger_agi9",
        },
        npc_dota_hero_drow_ranger_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-10.png", name = "npc_dota_hero_drow_ranger_agi10",
        },
        npc_dota_hero_drow_ranger_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-11.png", name = "npc_dota_hero_drow_ranger_agi11",
        },
        npc_dota_hero_drow_ranger_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_drow_ranger/agi/agi-talant-12.png", name = "npc_dota_hero_drow_ranger_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_drow_ranger_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-6.png", name = "npc_dota_hero_drow_ranger_int6", 
        },
        npc_dota_hero_drow_ranger_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-7.png", name = "npc_dota_hero_drow_ranger_int7", 
        },
        npc_dota_hero_drow_ranger_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-8.png", name = "npc_dota_hero_drow_ranger_int8", 
        },
        npc_dota_hero_drow_ranger_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-9.png", name = "npc_dota_hero_drow_ranger_int9", 
        },
        npc_dota_hero_drow_ranger_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-10.png", name = "npc_dota_hero_drow_ranger_int10", 
        }, 
        npc_dota_hero_drow_ranger_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-11.png", name = "npc_dota_hero_drow_ranger_int11", 
        },  
        npc_dota_hero_drow_ranger_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_drow_ranger/int/int-talant-12.png", name = "npc_dota_hero_drow_ranger_int12",
        },  
    },
    npc_dota_hero_enchantress = {      
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_enchantress_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_enchantress/str/str-talant-6.png", name = "npc_dota_hero_enchantress_str6",
        },
        npc_dota_hero_enchantress_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_enchantress/str/str-talant-7.png", name = "npc_dota_hero_enchantress_str7",
        },
        npc_dota_hero_enchantress_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_enchantress/str/str-talant-8.png", name = "npc_dota_hero_enchantress_str8",
        },
        npc_dota_hero_enchantress_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_enchantress/str/str-talant-9.png", name = "npc_dota_hero_enchantress_str9",
        },
        npc_dota_hero_enchantress_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_enchantress/str/str-talant-10.png", name = "npc_dota_hero_enchantress_str10",
        },
        npc_dota_hero_enchantress_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_enchantress/str/str-talant-11.png", name = "npc_dota_hero_enchantress_str11",
        },
        npc_dota_hero_enchantress_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_enchantress/str/str-talant-12.png", name = "npc_dota_hero_enchantress_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_enchantress_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-6.png", name = "npc_dota_hero_enchantress_agi6",
        },
        npc_dota_hero_enchantress_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-7.png", name = "npc_dota_hero_enchantress_agi7",
        },
        npc_dota_hero_enchantress_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-8.png", name = "npc_dota_hero_enchantress_agi8",
        },
        npc_dota_hero_enchantress_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-9.png", name = "npc_dota_hero_enchantress_agi9",
        },
        npc_dota_hero_enchantress_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-10.png", name = "npc_dota_hero_enchantress_agi10",
        },
        npc_dota_hero_enchantress_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-11.png", name = "npc_dota_hero_enchantress_agi11",
        },
        npc_dota_hero_enchantress_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_enchantress/agi/agi-talant-12.png", name = "npc_dota_hero_enchantress_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_enchantress_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_enchantress/int/int-talant-6.png", name = "npc_dota_hero_enchantress_int6", 
        },
        npc_dota_hero_enchantress_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_enchantress/int/int-talant-7.png", name = "npc_dota_hero_enchantress_int7", 
        },
        npc_dota_hero_enchantress_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_enchantress/int/int-talant-8.png", name = "npc_dota_hero_enchantress_int8", 
        },
        npc_dota_hero_enchantress_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_enchantress/int/int-talant-9.png", name = "npc_dota_hero_enchantress_int9", 
        },
        npc_dota_hero_enchantress_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_enchantress/int/int-talant-10.png", name = "npc_dota_hero_enchantress_int10", 
        }, 
        npc_dota_hero_enchantress_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_enchantress/int/int-talant-11.png", name = "npc_dota_hero_enchantress_int11", 
        },  
        npc_dota_hero_enchantress_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_enchantress/int/int-talant-12.png", name = "npc_dota_hero_enchantress_int12",
        },  
    },
    npc_dota_hero_juggernaut = {      
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_juggernaut_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_juggernaut/str/str-talant-6.png", name = "npc_dota_hero_juggernaut_str6",
        },
        npc_dota_hero_juggernaut_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_juggernaut/str/str-talant-7.png", name = "npc_dota_hero_juggernaut_str7",
        },
        npc_dota_hero_juggernaut_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_juggernaut/str/str-talant-8.png", name = "npc_dota_hero_juggernaut_str8",
        },
        npc_dota_hero_juggernaut_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_juggernaut/str/str-talant-9.png", name = "npc_dota_hero_juggernaut_str9",
        },
        npc_dota_hero_juggernaut_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_juggernaut/str/str-talant-10.png", name = "npc_dota_hero_juggernaut_str10",
        },
        npc_dota_hero_juggernaut_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_juggernaut/str/str-talant-11.png", name = "npc_dota_hero_juggernaut_str11",
        },
        npc_dota_hero_juggernaut_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_juggernaut/str/str-talant-12.png", name = "npc_dota_hero_juggernaut_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_juggernaut_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-6.png", name = "npc_dota_hero_juggernaut_agi6",
        },
        npc_dota_hero_juggernaut_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-7.png", name = "npc_dota_hero_juggernaut_agi7",
        },
        npc_dota_hero_juggernaut_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-8.png", name = "npc_dota_hero_juggernaut_agi8",
        },
        npc_dota_hero_juggernaut_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-9.png", name = "npc_dota_hero_juggernaut_agi9",
        },
        npc_dota_hero_juggernaut_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-10.png", name = "npc_dota_hero_juggernaut_agi10",
        },
        npc_dota_hero_juggernaut_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-11.png", name = "npc_dota_hero_juggernaut_agi11",
        },
        npc_dota_hero_juggernaut_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_juggernaut/agi/agi-talant-12.png", name = "npc_dota_hero_juggernaut_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_juggernaut_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_juggernaut/int/int-talant-6.png", name = "npc_dota_hero_juggernaut_int6", 
        },
        npc_dota_hero_juggernaut_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_juggernaut/int/int-talant-7.png", name = "npc_dota_hero_juggernaut_int7", 
        },
        npc_dota_hero_juggernaut_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_juggernaut/int/int-talant-8.png", name = "npc_dota_hero_juggernaut_int8", 
        },
        npc_dota_hero_juggernaut_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_juggernaut/int/int-talant-9.png", name = "npc_dota_hero_juggernaut_int9", 
        },
        npc_dota_hero_juggernaut_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_juggernaut/int/int-talant-10.png", name = "npc_dota_hero_juggernaut_int10", 
        }, 
        npc_dota_hero_juggernaut_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_juggernaut/int/int-talant-11.png", name = "npc_dota_hero_juggernaut_int11", 
        },  
        npc_dota_hero_juggernaut_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_juggernaut/int/int-talant-12.png", name = "npc_dota_hero_juggernaut_int12",
        },  
    },
    npc_dota_hero_lina = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_lina_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_lina/str/str-talant-6.png", name = "npc_dota_hero_lina_str6",
        },
        npc_dota_hero_lina_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_lina/str/str-talant-7.png", name = "npc_dota_hero_lina_str7",
        },
        npc_dota_hero_lina_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_lina/str/str-talant-8.png", name = "npc_dota_hero_lina_str8",
        },
        npc_dota_hero_lina_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_lina/str/str-talant-9.png", name = "npc_dota_hero_lina_str9",
        },
        npc_dota_hero_lina_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_lina/str/str-talant-10.png", name = "npc_dota_hero_lina_str10",
        },
        npc_dota_hero_lina_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_lina/str/str-talant-11.png", name = "npc_dota_hero_lina_str11",
        },
        npc_dota_hero_lina_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_lina/str/str-talant-12.png", name = "npc_dota_hero_lina_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_lina_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_lina/agi/agi-talant-6.png", name = "npc_dota_hero_lina_agi6",
        },
        npc_dota_hero_lina_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_lina/agi/agi-talant-7.png", name = "npc_dota_hero_lina_agi7",
        },
        npc_dota_hero_lina_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_lina/agi/agi-talant-8.png", name = "npc_dota_hero_lina_agi8",
        },
        npc_dota_hero_lina_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_lina/agi/agi-talant-9.png", name = "npc_dota_hero_lina_agi9",
        },
        npc_dota_hero_lina_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_lina/agi/agi-talant-10.png", name = "npc_dota_hero_lina_agi10",
        },
        npc_dota_hero_lina_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_lina/agi/agi-talant-11.png", name = "npc_dota_hero_lina_agi11",
        },
        npc_dota_hero_lina_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_lina/agi/agi-talant-12.png", name = "npc_dota_hero_lina_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_lina_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_lina/int/int-talant-6.png", name = "npc_dota_hero_lina_int6", 
        },
        npc_dota_hero_lina_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_lina/int/int-talant-7.png", name = "npc_dota_hero_lina_int7", 
        },
        npc_dota_hero_lina_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_lina/int/int-talant-8.png", name = "npc_dota_hero_lina_int8", 
        },
        npc_dota_hero_lina_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_lina/int/int-talant-9.png", name = "npc_dota_hero_lina_int9", 
        },
        npc_dota_hero_lina_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_lina/int/int-talant-10.png", name = "npc_dota_hero_lina_int10", 
        }, 
        npc_dota_hero_lina_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_lina/int/int-talant-11.png", name = "npc_dota_hero_lina_int11", 
        },  
        npc_dota_hero_lina_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_lina/int/int-talant-12.png", name = "npc_dota_hero_lina_int12",
        },  
    },
    npc_dota_hero_lion = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_lion_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_lion/str/str-talant-6.png", name = "npc_dota_hero_lion_str6",
        },
        npc_dota_hero_lion_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_lion/str/str-talant-7.png", name = "npc_dota_hero_lion_str7",
        },
        npc_dota_hero_lion_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_lion/str/str-talant-8.png", name = "npc_dota_hero_lion_str8",
        },
        npc_dota_hero_lion_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_lion/str/str-talant-9.png", name = "npc_dota_hero_lion_str9",
        },
        npc_dota_hero_lion_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_lion/str/str-talant-10.png", name = "npc_dota_hero_lion_str10",
        },
        npc_dota_hero_lion_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_lion/str/str-talant-11.png", name = "npc_dota_hero_lion_str11",
        },
        npc_dota_hero_lion_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_lion/str/str-talant-12.png", name = "npc_dota_hero_lion_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_lion_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_lion/agi/agi-talant-6.png", name = "npc_dota_hero_lion_agi6",
        },
        npc_dota_hero_lion_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_lion/agi/agi-talant-7.png", name = "npc_dota_hero_lion_agi7",
        },
        npc_dota_hero_lion_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_lion/agi/agi-talant-8.png", name = "npc_dota_hero_lion_agi8",
        },
        npc_dota_hero_lion_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_lion/agi/agi-talant-9.png", name = "npc_dota_hero_lion_agi9",
        },
        npc_dota_hero_lion_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_lion/agi/agi-talant-10.png", name = "npc_dota_hero_lion_agi10",
        },
        npc_dota_hero_lion_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_lion/agi/agi-talant-11.png", name = "npc_dota_hero_lion_agi11",
        },
        npc_dota_hero_lion_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_lion/agi/agi-talant-12.png", name = "npc_dota_hero_lion_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_lion_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_lion/int/int-talant-6.png", name = "npc_dota_hero_lion_int6", 
        },
        npc_dota_hero_lion_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_lion/int/int-talant-7.png", name = "npc_dota_hero_lion_int7", 
        },
        npc_dota_hero_lion_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_lion/int/int-talant-8.png", name = "npc_dota_hero_lion_int8", 
        },
        npc_dota_hero_lion_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_lion/int/int-talant-9.png", name = "npc_dota_hero_lion_int9", 
        },
        npc_dota_hero_lion_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_lion/int/int-talant-10.png", name = "npc_dota_hero_lion_int10", 
        }, 
        npc_dota_hero_lion_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_lion/int/int-talant-11.png", name = "npc_dota_hero_lion_int11", 
        },  
        npc_dota_hero_lion_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_lion/int/int-talant-12.png", name = "npc_dota_hero_lion_int12",
        },  
    },
    npc_dota_hero_luna = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_luna_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_luna/str/str-talant-6.png", name = "npc_dota_hero_luna_str6",
        },
        npc_dota_hero_luna_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_luna/str/str-talant-7.png", name = "npc_dota_hero_luna_str7",
        },
        npc_dota_hero_luna_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_luna/str/str-talant-8.png", name = "npc_dota_hero_luna_str8",
        },
        npc_dota_hero_luna_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_luna/str/str-talant-9.png", name = "npc_dota_hero_luna_str9",
        },
        npc_dota_hero_luna_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_luna/str/str-talant-10.png", name = "npc_dota_hero_luna_str10",
        },
        npc_dota_hero_luna_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_luna/str/str-talant-11.png", name = "npc_dota_hero_luna_str11",
        },
        npc_dota_hero_luna_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_luna/str/str-talant-12.png", name = "npc_dota_hero_luna_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_luna_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_luna/agi/agi-talant-6.png", name = "npc_dota_hero_luna_agi6",
        },
        npc_dota_hero_luna_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_luna/agi/agi-talant-7.png", name = "npc_dota_hero_luna_agi7",
        },
        npc_dota_hero_luna_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_luna/agi/agi-talant-8.png", name = "npc_dota_hero_luna_agi8",
        },
        npc_dota_hero_luna_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_luna/agi/agi-talant-9.png", name = "npc_dota_hero_luna_agi9",
        },
        npc_dota_hero_luna_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_luna/agi/agi-talant-10.png", name = "npc_dota_hero_luna_agi10",
        },
        npc_dota_hero_luna_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_luna/agi/agi-talant-11.png", name = "npc_dota_hero_luna_agi11",
        },
        npc_dota_hero_luna_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_luna/agi/agi-talant-12.png", name = "npc_dota_hero_luna_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_luna_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_luna/int/int-talant-6.png", name = "npc_dota_hero_luna_int6", 
        },
        npc_dota_hero_luna_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_luna/int/int-talant-7.png", name = "npc_dota_hero_luna_int7", 
        },
        npc_dota_hero_luna_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_luna/int/int-talant-8.png", name = "npc_dota_hero_luna_int8", 
        },
        npc_dota_hero_luna_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_luna/int/int-talant-9.png", name = "npc_dota_hero_luna_int9", 
        },
        npc_dota_hero_luna_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_luna/int/int-talant-10.png", name = "npc_dota_hero_luna_int10", 
        }, 
        npc_dota_hero_luna_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_luna/int/int-talant-11.png", name = "npc_dota_hero_luna_int11", 
        },  
        npc_dota_hero_luna_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_luna/int/int-talant-12.png", name = "npc_dota_hero_luna_int12",
        },  
    },
    npc_dota_hero_mars = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_mars_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_mars/str/str-talant-6.png", name = "npc_dota_hero_mars_str6",
        },
        npc_dota_hero_mars_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_mars/str/str-talant-7.png", name = "npc_dota_hero_mars_str7",
        },
        npc_dota_hero_mars_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_mars/str/str-talant-8.png", name = "npc_dota_hero_mars_str8",
        },
        npc_dota_hero_mars_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_mars/str/str-talant-9.png", name = "npc_dota_hero_mars_str9",
        },
        npc_dota_hero_mars_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_mars/str/str-talant-10.png", name = "npc_dota_hero_mars_str10",
        },
        npc_dota_hero_mars_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_mars/str/str-talant-11.png", name = "npc_dota_hero_mars_str11",
        },
        npc_dota_hero_mars_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_mars/str/str-talant-12.png", name = "npc_dota_hero_mars_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_mars_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_mars/agi/agi-talant-6.png", name = "npc_dota_hero_mars_agi6",
        },
        npc_dota_hero_mars_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_mars/agi/agi-talant-7.png", name = "npc_dota_hero_mars_agi7",
        },
        npc_dota_hero_mars_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_mars/agi/agi-talant-8.png", name = "npc_dota_hero_mars_agi8",
        },
        npc_dota_hero_mars_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_mars/agi/agi-talant-9.png", name = "npc_dota_hero_mars_agi9",
        },
        npc_dota_hero_mars_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_mars/agi/agi-talant-10.png", name = "npc_dota_hero_mars_agi10",
        },
        npc_dota_hero_mars_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_mars/agi/agi-talant-11.png", name = "npc_dota_hero_mars_agi11",
        },
        npc_dota_hero_mars_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_mars/agi/agi-talant-12.png", name = "npc_dota_hero_mars_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_mars_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_mars/int/int-talant-6.png", name = "npc_dota_hero_mars_int6", 
        },
        npc_dota_hero_mars_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_mars/int/int-talant-7.png", name = "npc_dota_hero_mars_int7", 
        },
        npc_dota_hero_mars_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_mars/int/int-talant-8.png", name = "npc_dota_hero_mars_int8", 
        },
        npc_dota_hero_mars_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_mars/int/int-talant-9.png", name = "npc_dota_hero_mars_int9", 
        },
        npc_dota_hero_mars_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_mars/int/int-talant-10.png", name = "npc_dota_hero_mars_int10", 
        }, 
        npc_dota_hero_mars_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_mars/int/int-talant-11.png", name = "npc_dota_hero_mars_int11", 
        },  
        npc_dota_hero_mars_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_mars/int/int-talant-12.png", name = "npc_dota_hero_mars_int12",
        },  
    },
    npc_dota_hero_nevermore = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_nevermore_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_nevermore/str/str-talant-6.png", name = "npc_dota_hero_nevermore_str6",
        },
        npc_dota_hero_nevermore_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_nevermore/str/str-talant-7.png", name = "npc_dota_hero_nevermore_str7",
        },
        npc_dota_hero_nevermore_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_nevermore/str/str-talant-8.png", name = "npc_dota_hero_nevermore_str8",
        },
        npc_dota_hero_nevermore_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_nevermore/str/str-talant-9.png", name = "npc_dota_hero_nevermore_str9",
        },
        npc_dota_hero_nevermore_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_nevermore/str/str-talant-10.png", name = "npc_dota_hero_nevermore_str10",
        },
        npc_dota_hero_nevermore_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_nevermore/str/str-talant-11.png", name = "npc_dota_hero_nevermore_str11",
        },
        npc_dota_hero_nevermore_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_nevermore/str/str-talant-12.png", name = "npc_dota_hero_nevermore_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_nevermore_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-6.png", name = "npc_dota_hero_nevermore_agi6",
        },
        npc_dota_hero_nevermore_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-7.png", name = "npc_dota_hero_nevermore_agi7",
        },
        npc_dota_hero_nevermore_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-8.png", name = "npc_dota_hero_nevermore_agi8",
        },
        npc_dota_hero_nevermore_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-9.png", name = "npc_dota_hero_nevermore_agi9",
        },
        npc_dota_hero_nevermore_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-10.png", name = "npc_dota_hero_nevermore_agi10",
        },
        npc_dota_hero_nevermore_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-11.png", name = "npc_dota_hero_nevermore_agi11",
        },
        npc_dota_hero_nevermore_agi8 = {
            place = {"agi 12"}, url = "/npc_dota_hero_nevermore/agi/agi-talant-12.png", name = "npc_dota_hero_nevermore_agi8",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_nevermore_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_nevermore/int/int-talant-6.png", name = "npc_dota_hero_nevermore_int6",
        },
        npc_dota_hero_nevermore_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_nevermore/int/int-talant-7.png", name = "npc_dota_hero_nevermore_int7",
        },
        npc_dota_hero_nevermore_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_nevermore/int/int-talant-8.png", name = "npc_dota_hero_nevermore_int8",
        },
        npc_dota_hero_nevermore_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_nevermore/int/int-talant-9.png", name = "npc_dota_hero_nevermore_int9",
        },
        npc_dota_hero_nevermore_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_nevermore/int/int-talant-10.png", name = "npc_dota_hero_nevermore_int10",
        },
        npc_dota_hero_nevermore_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_nevermore/int/int-talant-11.png", name = "npc_dota_hero_nevermore_int11",
        },
        npc_dota_hero_nevermore_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_nevermore/int/int-talant-12.png", name = "npc_dota_hero_nevermore_int12",
        },
    },
    npc_dota_hero_phantom_assassin = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_phantom_assassin_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-6.png", name = "npc_dota_hero_phantom_assassin_str6",
        },
        npc_dota_hero_phantom_assassin_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-7.png", name = "npc_dota_hero_phantom_assassin_str7",
        },
        npc_dota_hero_phantom_assassin_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-8.png", name = "npc_dota_hero_phantom_assassin_str8",
        },
        npc_dota_hero_phantom_assassin_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-9.png", name = "npc_dota_hero_phantom_assassin_str9",
        },
        npc_dota_hero_phantom_assassin_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-10.png", name = "npc_dota_hero_phantom_assassin_str10",
        },
        npc_dota_hero_phantom_assassin_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-11.png", name = "npc_dota_hero_phantom_assassin_str11",
        },
        npc_dota_hero_phantom_assassin_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_phantom_assassin/str/str-talant-12.png", name = "npc_dota_hero_phantom_assassin_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_phantom_assassin_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-6.png", name = "npc_dota_hero_phantom_assassin_agi6",
        },
        npc_dota_hero_phantom_assassin_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-7.png", name = "npc_dota_hero_phantom_assassin_agi7",
        },
        npc_dota_hero_phantom_assassin_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-8.png", name = "npc_dota_hero_phantom_assassin_agi8",
        },
        npc_dota_hero_phantom_assassin_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-9.png", name = "npc_dota_hero_phantom_assassin_agi9",
        },
        npc_dota_hero_phantom_assassin_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-10.png", name = "npc_dota_hero_phantom_assassin_agi10",
        },
        npc_dota_hero_phantom_assassin_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-11.png", name = "npc_dota_hero_phantom_assassin_agi11",
        },
        npc_dota_hero_phantom_assassin_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_phantom_assassin/agi/agi-talant-12.png", name = "npc_dota_hero_phantom_assassin_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_phantom_assassin_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-6.png", name = "npc_dota_hero_phantom_assassin_int6",
        },
        npc_dota_hero_phantom_assassin_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-7.png", name = "npc_dota_hero_phantom_assassin_int7",
        },
        npc_dota_hero_phantom_assassin_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-8.png", name = "npc_dota_hero_phantom_assassin_int8",
        },
        npc_dota_hero_phantom_assassin_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-9.png", name = "npc_dota_hero_phantom_assassin_int9",
        },
        npc_dota_hero_phantom_assassin_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-10.png", name = "npc_dota_hero_phantom_assassin_int10",
        },
        npc_dota_hero_phantom_assassin_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-11.png", name = "npc_dota_hero_phantom_assassin_int11",
        },
        npc_dota_hero_phantom_assassin_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_phantom_assassin/int/int-talant-12.png", name = "npc_dota_hero_phantom_assassin_int12",
        },
    },
    npc_dota_hero_pugna = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_pugna_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_pugna/str/str-talant-6.png", name = "npc_dota_hero_pugna_str6",
        },
        npc_dota_hero_pugna_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_pugna/str/str-talant-7.png", name = "npc_dota_hero_pugna_str7",
        },
        npc_dota_hero_pugna_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_pugna/str/str-talant-8.png", name = "npc_dota_hero_pugna_str8",
        },
        npc_dota_hero_pugna_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_pugna/str/str-talant-9.png", name = "npc_dota_hero_pugna_str9",
        },
        npc_dota_hero_pugna_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_pugna/str/str-talant-10.png", name = "npc_dota_hero_pugna_str10",
        },
        npc_dota_hero_pugna_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_pugna/str/str-talant-11.png", name = "npc_dota_hero_pugna_str11",
        },
        npc_dota_hero_pugna_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_pugna/str/str-talant-12.png", name = "npc_dota_hero_pugna_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_pugna_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_pugna/agi/agi-talant-6.png", name = "npc_dota_hero_pugna_agi6",
        },
        npc_dota_hero_pugna_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_pugna/agi/agi-talant-7.png", name = "npc_dota_hero_pugna_agi7",
        },
        npc_dota_hero_pugna_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_pugna/agi/agi-talant-8.png", name = "npc_dota_hero_pugna_agi8",
        },
        npc_dota_hero_pugna_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_pugna/agi/agi-talant-9.png", name = "npc_dota_hero_pugna_agi9",
        },
        npc_dota_hero_pugna_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_pugna/agi/agi-talant-10.png", name = "npc_dota_hero_pugna_agi10",
        },
        npc_dota_hero_pugna_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_pugna/agi/agi-talant-11.png", name = "npc_dota_hero_pugna_agi11",
        },
        npc_dota_hero_pugna_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_pugna/agi/agi-talant-12.png", name = "npc_dota_hero_pugna_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_pugna_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_pugna/int/int-talant-6.png", name = "npc_dota_hero_pugna_int6",
        },
        npc_dota_hero_pugna_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_pugna/int/int-talant-7.png", name = "npc_dota_hero_pugna_int7",
        },
        npc_dota_hero_pugna_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_pugna/int/int-talant-8.png", name = "npc_dota_hero_pugna_int8",
        },
        npc_dota_hero_pugna_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_pugna/int/int-talant-9.png", name = "npc_dota_hero_pugna_int9",
        },
        npc_dota_hero_pugna_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_pugna/int/int-talant-10.png", name = "npc_dota_hero_pugna_int10",
        },
        npc_dota_hero_pugna_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_pugna/int/int-talant-11.png", name = "npc_dota_hero_pugna_int11",
        },
        npc_dota_hero_pugna_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_pugna/int/int-talant-12.png", name = "npc_dota_hero_pugna_int12",
        },
    },
    npc_dota_hero_sand_king = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_sand_king_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_sand_king/str/str-talant-6.png", name = "npc_dota_hero_sand_king_str6",
        },
        npc_dota_hero_sand_king_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_sand_king/str/str-talant-7.png", name = "npc_dota_hero_sand_king_str7",
        },
        npc_dota_hero_sand_king_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_sand_king/str/str-talant-8.png", name = "npc_dota_hero_sand_king_str8",
        },
        npc_dota_hero_sand_king_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_sand_king/str/str-talant-9.png", name = "npc_dota_hero_sand_king_str9",
        },
        npc_dota_hero_sand_king_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_sand_king/str/str-talant-10.png", name = "npc_dota_hero_sand_king_str10",
        },
        npc_dota_hero_sand_king_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_sand_king/str/str-talant-11.png", name = "npc_dota_hero_sand_king_str11",
        },
        npc_dota_hero_sand_king_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_sand_king/str/str-talant-12.png", name = "npc_dota_hero_sand_king_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_sand_king_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-6.png", name = "npc_dota_hero_sand_king_agi6",
        },
        npc_dota_hero_sand_king_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-7.png", name = "npc_dota_hero_sand_king_agi7",
        },
        npc_dota_hero_sand_king_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-8.png", name = "npc_dota_hero_sand_king_agi8",
        },
        npc_dota_hero_sand_king_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-9.png", name = "npc_dota_hero_sand_king_agi9",
        },
        npc_dota_hero_sand_king_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-10.png", name = "npc_dota_hero_sand_king_agi10",
        },
        npc_dota_hero_sand_king_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-11.png", name = "npc_dota_hero_sand_king_agi11",
        },
        npc_dota_hero_sand_king_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_sand_king/agi/agi-talant-12.png", name = "npc_dota_hero_sand_king_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_sand_king_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_sand_king/int/int-talant-6.png", name = "npc_dota_hero_sand_king_int6",
        },
        npc_dota_hero_sand_king_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_sand_king/int/int-talant-7.png", name = "npc_dota_hero_sand_king_int7",
        },
        npc_dota_hero_sand_king_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_sand_king/int/int-talant-8.png", name = "npc_dota_hero_sand_king_int8",
        },
        npc_dota_hero_sand_king_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_sand_king/int/int-talant-9.png", name = "npc_dota_hero_sand_king_int9",
        },
        npc_dota_hero_sand_king_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_sand_king/int/int-talant-10.png", name = "npc_dota_hero_sand_king_int10",
        },
        npc_dota_hero_sand_king_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_sand_king/int/int-talant-11.png", name = "npc_dota_hero_sand_king_int11",
        },
        npc_dota_hero_sand_king_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_sand_king/int/int-talant-12.png", name = "npc_dota_hero_sand_king_int12",
        },
    },
    npc_dota_hero_shadow_shaman = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_shadow_shaman_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-6.png", name = "npc_dota_hero_shadow_shaman_str6",
        },
        npc_dota_hero_shadow_shaman_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-7.png", name = "npc_dota_hero_shadow_shaman_str7",
        },
        npc_dota_hero_shadow_shaman_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-8.png", name = "npc_dota_hero_shadow_shaman_str8",
        },
        npc_dota_hero_shadow_shaman_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-9.png", name = "npc_dota_hero_shadow_shaman_str9",
        },
        npc_dota_hero_shadow_shaman_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-10.png", name = "npc_dota_hero_shadow_shaman_str10",
        },
        npc_dota_hero_shadow_shaman_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-11.png", name = "npc_dota_hero_shadow_shaman_str11",
        },
        npc_dota_hero_shadow_shaman_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_shadow_shaman/str/str-talant-12.png", name = "npc_dota_hero_shadow_shaman_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_shadow_shaman_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-6.png", name = "npc_dota_hero_shadow_shaman_agi6",
        },
        npc_dota_hero_shadow_shaman_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-7.png", name = "npc_dota_hero_shadow_shaman_agi7",
        },
        npc_dota_hero_shadow_shaman_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-8.png", name = "npc_dota_hero_shadow_shaman_agi8",
        },
        npc_dota_hero_shadow_shaman_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-9.png", name = "npc_dota_hero_shadow_shaman_agi9",
        },
        npc_dota_hero_shadow_shaman_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-10.png", name = "npc_dota_hero_shadow_shaman_agi10",
        },
        npc_dota_hero_shadow_shaman_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-11.png", name = "npc_dota_hero_shadow_shaman_agi11",
        },
        npc_dota_hero_shadow_shaman_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_shadow_shaman/agi/agi-talant-12.png", name = "npc_dota_hero_shadow_shaman_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_shadow_shaman_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-6.png", name = "npc_dota_hero_shadow_shaman_int6",
        },
        npc_dota_hero_shadow_shaman_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-7.png", name = "npc_dota_hero_shadow_shaman_int7",
        },
        npc_dota_hero_shadow_shaman_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-8.png", name = "npc_dota_hero_shadow_shaman_int8",
        },
        npc_dota_hero_shadow_shaman_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-9.png", name = "npc_dota_hero_shadow_shaman_int9",
        },
        npc_dota_hero_shadow_shaman_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-10.png", name = "npc_dota_hero_shadow_shaman_int10",
        },
        npc_dota_hero_shadow_shaman_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-11.png", name = "npc_dota_hero_shadow_shaman_int11",
        },
        npc_dota_hero_shadow_shaman_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_shadow_shaman/int/int-talant-12.png", name = "npc_dota_hero_shadow_shaman_int12",
        },
    },
    npc_dota_hero_skeleton_king = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_skeleton_king_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-6.png", name = "npc_dota_hero_skeleton_king_str6",
        },
        npc_dota_hero_skeleton_king_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-7.png", name = "npc_dota_hero_skeleton_king_str7",
        },
        npc_dota_hero_skeleton_king_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-8.png", name = "npc_dota_hero_skeleton_king_str8",
        },
        npc_dota_hero_skeleton_king_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-9.png", name = "npc_dota_hero_skeleton_king_str9",
        },
        npc_dota_hero_skeleton_king_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-10.png", name = "npc_dota_hero_skeleton_king_str10",
        },
        npc_dota_hero_skeleton_king_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-11.png", name = "npc_dota_hero_skeleton_king_str11",
        },
        npc_dota_hero_skeleton_king_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_skeleton_king/str/str-talant-12.png", name = "npc_dota_hero_skeleton_king_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_skeleton_king_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-6.png", name = "npc_dota_hero_skeleton_king_agi6",
        },
        npc_dota_hero_skeleton_king_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-7.png", name = "npc_dota_hero_skeleton_king_agi7",
        },
        npc_dota_hero_skeleton_king_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-8.png", name = "npc_dota_hero_skeleton_king_agi8",
        },
        npc_dota_hero_skeleton_king_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-9.png", name = "npc_dota_hero_skeleton_king_agi9",
        },
        npc_dota_hero_skeleton_king_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-10.png", name = "npc_dota_hero_skeleton_king_agi10",
        },
        npc_dota_hero_skeleton_king_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-11.png", name = "npc_dota_hero_skeleton_king_agi11",
        },
        npc_dota_hero_skeleton_king_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_skeleton_king/agi/agi-talant-12.png", name = "npc_dota_hero_skeleton_king_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_skeleton_king_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-6.png", name = "npc_dota_hero_skeleton_king_int6",
        },
        npc_dota_hero_skeleton_king_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-7.png", name = "npc_dota_hero_skeleton_king_int7",
        },
        npc_dota_hero_skeleton_king_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-8.png", name = "npc_dota_hero_skeleton_king_int8",
        },
        npc_dota_hero_skeleton_king_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-9.png", name = "npc_dota_hero_skeleton_king_int9",
        },
        npc_dota_hero_skeleton_king_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-10.png", name = "npc_dota_hero_skeleton_king_int10",
        },
        npc_dota_hero_skeleton_king_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-11.png", name = "npc_dota_hero_skeleton_king_int11",
        },
        npc_dota_hero_skeleton_king_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_skeleton_king/int/int-talant-12.png", name = "npc_dota_hero_skeleton_king_int12",
        },
    },
    npc_dota_hero_slark = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_slark_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_slark/str/str-talant-6.png", name = "npc_dota_hero_slark_str6",
        },
        npc_dota_hero_slark_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_slark/str/str-talant-7.png", name = "npc_dota_hero_slark_str7",
        },
        npc_dota_hero_slark_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_slark/str/str-talant-8.png", name = "npc_dota_hero_slark_str8",
        },
        npc_dota_hero_slark_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_slark/str/str-talant-9.png", name = "npc_dota_hero_slark_str9",
        },
        npc_dota_hero_slark_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_slark/str/str-talant-10.png", name = "npc_dota_hero_slark_str10",
        },
        npc_dota_hero_slark_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_slark/str/str-talant-11.png", name = "npc_dota_hero_slark_str11",
        },
        npc_dota_hero_slark_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_slark/str/str-talant-12.png", name = "npc_dota_hero_slark_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_slark_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_slark/agi/agi-talant-6.png", name = "npc_dota_hero_slark_agi6",
        },
        npc_dota_hero_slark_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_slark/agi/agi-talant-7.png", name = "npc_dota_hero_slark_agi7",
        },
        npc_dota_hero_slark_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_slark/agi/agi-talant-8.png", name = "npc_dota_hero_slark_agi8",
        },
        npc_dota_hero_slark_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_slark/agi/agi-talant-9.png", name = "npc_dota_hero_slark_agi9",
        },
        npc_dota_hero_slark_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_slark/agi/agi-talant-10.png", name = "npc_dota_hero_slark_agi10",
        },
        npc_dota_hero_slark_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_slark/agi/agi-talant-11.png", name = "npc_dota_hero_slark_agi11",
        },
        npc_dota_hero_slark_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_slark/agi/agi-talant-12.png", name = "npc_dota_hero_slark_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_slark_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_slark/int/int-talant-6.png", name = "npc_dota_hero_slark_int6",
        },
        npc_dota_hero_slark_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_slark/int/int-talant-7.png", name = "npc_dota_hero_slark_int7",
        },
        npc_dota_hero_slark_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_slark/int/int-talant-8.png", name = "npc_dota_hero_slark_int8",
        },
        npc_dota_hero_slark_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_slark/int/int-talant-9.png", name = "npc_dota_hero_slark_int9",
        },
        npc_dota_hero_slark_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_slark/int/int-talant-10.png", name = "npc_dota_hero_slark_int10",
        },
        npc_dota_hero_slark_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_slark/int/int-talant-11.png", name = "npc_dota_hero_slark_int11",
        },
        npc_dota_hero_slark_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_slark/int/int-talant-12.png", name = "npc_dota_hero_slark_int12",
        },
    },
    npc_dota_hero_sniper = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_sniper_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_sniper/str/str-talant-6.png", name = "npc_dota_hero_sniper_str6",
        },
        npc_dota_hero_sniper_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_sniper/str/str-talant-7.png", name = "npc_dota_hero_sniper_str7",
        },
        npc_dota_hero_sniper_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_sniper/str/str-talant-8.png", name = "npc_dota_hero_sniper_str8",
        },
        npc_dota_hero_sniper_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_sniper/str/str-talant-9.png", name = "npc_dota_hero_sniper_str9",
        },
        npc_dota_hero_sniper_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_sniper/str/str-talant-10.png", name = "npc_dota_hero_sniper_str10",
        },
        npc_dota_hero_sniper_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_sniper/str/str-talant-11.png", name = "npc_dota_hero_sniper_str11",
        },
        npc_dota_hero_sniper_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_sniper/str/str-talant-12.png", name = "npc_dota_hero_sniper_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_sniper_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_sniper/agi/agi-talant-6.png", name = "npc_dota_hero_sniper_agi6",
        },
        npc_dota_hero_sniper_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_sniper/agi/agi-talant-7.png", name = "npc_dota_hero_sniper_agi7",
        },
        npc_dota_hero_sniper_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_sniper/agi/agi-talant-8.png", name = "npc_dota_hero_sniper_agi8",
        },
        npc_dota_hero_sniper_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_sniper/agi/agi-talant-9.png", name = "npc_dota_hero_sniper_agi9",
        },
        npc_dota_hero_sniper_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_sniper/agi/agi-talant-10.png", name = "npc_dota_hero_sniper_agi10",
        },
        npc_dota_hero_sniper_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_sniper/agi/agi-talant-11.png", name = "npc_dota_hero_sniper_agi11",
        },
        npc_dota_hero_sniper_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_sniper/agi/agi-talant-12.png", name = "npc_dota_hero_sniper_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_sniper_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_sniper/int/int-talant-6.png", name = "npc_dota_hero_sniper_int6",
        },
        npc_dota_hero_sniper_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_sniper/int/int-talant-7.png", name = "npc_dota_hero_sniper_int7",
        },
        npc_dota_hero_sniper_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_sniper/int/int-talant-8.png", name = "npc_dota_hero_sniper_int8",
        },
        npc_dota_hero_sniper_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_sniper/int/int-talant-9.png", name = "npc_dota_hero_sniper_int9",
        },
        npc_dota_hero_sniper_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_sniper/int/int-talant-10.png", name = "npc_dota_hero_sniper_int10",
        },
        npc_dota_hero_sniper_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_sniper/int/int-talant-11.png", name = "npc_dota_hero_sniper_int11",
        },
        npc_dota_hero_sniper_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_sniper/int/int-talant-12.png", name = "npc_dota_hero_sniper_int12",
        },
    },
    npc_dota_hero_spectre = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_spectre_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_spectre/str/3.png", name = "npc_dota_hero_spectre_str6",
        },
        npc_dota_hero_spectre_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_spectre/str/2.png", name = "npc_dota_hero_spectre_str7",
        },
        npc_dota_hero_spectre_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_spectre/str/5.png", name = "npc_dota_hero_spectre_str8",
        },
        npc_dota_hero_spectre_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_spectre/str/3.png", name = "npc_dota_hero_spectre_str9",
        },
        npc_dota_hero_spectre_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_spectre/str/2.png", name = "npc_dota_hero_spectre_str10",
        },
        npc_dota_hero_spectre_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_spectre/str/4.png", name = "npc_dota_hero_spectre_str11",
        },
        npc_dota_hero_spectre_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_spectre/str/2.png", name = "npc_dota_hero_spectre_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_spectre_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_spectre/agi/2.png", name = "npc_dota_hero_spectre_agi6",
        },
        npc_dota_hero_spectre_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_spectre/agi/5.png", name = "npc_dota_hero_spectre_agi7",
        },
        npc_dota_hero_spectre_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_spectre/agi/1.png", name = "npc_dota_hero_spectre_agi8",
        },
        npc_dota_hero_spectre_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_spectre/agi/4.png", name = "npc_dota_hero_spectre_agi9",
        },
        npc_dota_hero_spectre_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_spectre/agi/1.png", name = "npc_dota_hero_spectre_agi10", tooltip = "npc_dota_hero_spectre_agi10_tooltip",
        },
        npc_dota_hero_spectre_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_spectre/agi/1.png", name = "npc_dota_hero_spectre_agi11",
        },
        npc_dota_hero_spectre_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_spectre/agi/1.png", name = "npc_dota_hero_spectre_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_spectre_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_spectre/int/1.png", name = "npc_dota_hero_spectre_int6",
        },
        npc_dota_hero_spectre_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_spectre/int/4.png", name = "npc_dota_hero_spectre_int7",
        },
        npc_dota_hero_spectre_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_spectre/int/2.png", name = "npc_dota_hero_spectre_int8", tooltip = "npc_dota_hero_spectre_int8_tooltip",
        },
        npc_dota_hero_spectre_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_spectre/int/1.png", name = "npc_dota_hero_spectre_int9",
        },
        npc_dota_hero_spectre_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_spectre/int/4.png", name = "npc_dota_hero_spectre_int10",
        },
        npc_dota_hero_spectre_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_spectre/int/2.png", name = "npc_dota_hero_spectre_int11",
        },
        npc_dota_hero_spectre_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_spectre/int/1.png", name = "npc_dota_hero_spectre_int12", tooltip = "npc_dota_hero_spectre_int_last_tooltip",
        },
    },
    npc_dota_hero_sven = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_sven_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_sven/str/str-talant-6.png", name = "npc_dota_hero_sven_str6",
        },
        npc_dota_hero_sven_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_sven/str/str-talant-7.png", name = "npc_dota_hero_sven_str7",
        },
        npc_dota_hero_sven_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_sven/str/str-talant-8.png", name = "npc_dota_hero_sven_str8",
        },
        npc_dota_hero_sven_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_sven/str/str-talant-9.png", name = "npc_dota_hero_sven_str9",
        },
        npc_dota_hero_sven_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_sven/str/str-talant-10.png", name = "npc_dota_hero_sven_str10",
        },
        npc_dota_hero_sven_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_sven/str/str-talant-11.png", name = "npc_dota_hero_sven_str11",
        },
        npc_dota_hero_sven_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_sven/str/str-talant-12.png", name = "npc_dota_hero_sven_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_sven_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_sven/agi/agi-talant-6.png", name = "npc_dota_hero_sven_agi6",
        },
        npc_dota_hero_sven_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_sven/agi/agi-talant-7.png", name = "npc_dota_hero_sven_agi7",
        },
        npc_dota_hero_sven_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_sven/agi/agi-talant-8.png", name = "npc_dota_hero_sven_agi8",
        },
        npc_dota_hero_sven_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_sven/agi/agi-talant-9.png", name = "npc_dota_hero_sven_agi9",
        },
        npc_dota_hero_sven_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_sven/agi/agi-talant-10.png", name = "npc_dota_hero_sven_agi10",
        },
        npc_dota_hero_sven_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_sven/agi/agi-talant-11.png", name = "npc_dota_hero_sven_agi11",
        },
        npc_dota_hero_sven_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_sven/agi/agi-talant-12.png", name = "npc_dota_hero_sven_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_sven_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_sven/int/int-talant-6.png", name = "npc_dota_hero_sven_int6",
        },
        npc_dota_hero_sven_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_sven/int/int-talant-7.png", name = "npc_dota_hero_sven_int7",
        },
        npc_dota_hero_sven_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_sven/int/int-talant-8.png", name = "npc_dota_hero_sven_int8",
        },
        npc_dota_hero_sven_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_sven/int/int-talant-9.png", name = "npc_dota_hero_sven_int9",
        },
        npc_dota_hero_sven_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_sven/int/int-talant-10.png", name = "npc_dota_hero_sven_int10",
        },
        npc_dota_hero_sven_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_sven/int/int-talant-11.png", name = "npc_dota_hero_sven_int11",
        },
        npc_dota_hero_sven_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_sven/int/int-talant-12.png", name = "npc_dota_hero_sven_int12",
        },
    },
    npc_dota_hero_terrorblade = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_terrorblade_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_terrorblade/str/str-talant-6.png", name = "npc_dota_hero_terrorblade_str6",
        },
        npc_dota_hero_terrorblade_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_terrorblade/str/str-talant-7.png", name = "npc_dota_hero_terrorblade_str7",
        },
        npc_dota_hero_terrorblade_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_terrorblade/str/str-talant-8.png", name = "npc_dota_hero_terrorblade_str8",
        },
        npc_dota_hero_terrorblade_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_terrorblade/str/str-talant-9.png", name = "npc_dota_hero_terrorblade_str9",
        },
        npc_dota_hero_terrorblade_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_terrorblade/str/str-talant-10.png", name = "npc_dota_hero_terrorblade_str10",
        },
        npc_dota_hero_terrorblade_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_terrorblade/str/str-talant-11.png", name = "npc_dota_hero_terrorblade_str11",
        },
        npc_dota_hero_terrorblade_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_terrorblade/str/str-talant-12.png", name = "npc_dota_hero_terrorblade_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_terrorblade_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-6.png", name = "npc_dota_hero_terrorblade_agi6",
        },
        npc_dota_hero_terrorblade_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-7.png", name = "npc_dota_hero_terrorblade_agi7",
        },
        npc_dota_hero_terrorblade_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-8.png", name = "npc_dota_hero_terrorblade_agi8",
        },
        npc_dota_hero_terrorblade_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-9.png", name = "npc_dota_hero_terrorblade_agi9",
        },
        npc_dota_hero_terrorblade_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-10.png", name = "npc_dota_hero_terrorblade_agi10",
        },
        npc_dota_hero_terrorblade_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-11.png", name = "npc_dota_hero_terrorblade_agi11",
        },
        npc_dota_hero_terrorblade_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_terrorblade/agi/agi-talant-12.png", name = "npc_dota_hero_terrorblade_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_terrorblade_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_terrorblade/int/int-talant-6.png", name = "npc_dota_hero_terrorblade_int6",
        },
        npc_dota_hero_terrorblade_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_terrorblade/int/int-talant-7.png", name = "npc_dota_hero_terrorblade_int7",
        },
        npc_dota_hero_terrorblade_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_terrorblade/int/int-talant-8.png", name = "npc_dota_hero_terrorblade_int8",
        },
        npc_dota_hero_terrorblade_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_terrorblade/int/int-talant-9.png", name = "npc_dota_hero_terrorblade_int9",
        },
        npc_dota_hero_terrorblade_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_terrorblade/int/int-talant-10.png", name = "npc_dota_hero_terrorblade_int10",
        },
        npc_dota_hero_terrorblade_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_terrorblade/int/int-talant-11.png", name = "npc_dota_hero_terrorblade_int11",
        },
        npc_dota_hero_terrorblade_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_terrorblade/int/int-talant-12.png", name = "npc_dota_hero_terrorblade_int12",
        },
    },
    npc_dota_hero_tinker = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_tinker_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_tinker/str/str-talant-6.png", name = "npc_dota_hero_tinker_str6",
        },
        npc_dota_hero_tinker_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_tinker/str/str-talant-7.png", name = "npc_dota_hero_tinker_str7",
        },
        npc_dota_hero_tinker_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_tinker/str/str-talant-8.png", name = "npc_dota_hero_tinker_str8",
        },
        npc_dota_hero_tinker_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_tinker/str/str-talant-9.png", name = "npc_dota_hero_tinker_str9",
        },
        npc_dota_hero_tinker_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_tinker/str/str-talant-10.png", name = "npc_dota_hero_tinker_str10",
        },
        npc_dota_hero_tinker_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_tinker/str/str-talant-11.png", name = "npc_dota_hero_tinker_str11",
        },
        npc_dota_hero_tinker_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_tinker/str/str-talant-12.png", name = "npc_dota_hero_tinker_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_tinker_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_tinker/agi/agi-talant-6.png", name = "npc_dota_hero_tinker_agi6",
        },
        npc_dota_hero_tinker_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_tinker/agi/agi-talant-7.png", name = "npc_dota_hero_tinker_agi7",
        },
        npc_dota_hero_tinker_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_tinker/agi/agi-talant-8.png", name = "npc_dota_hero_tinker_agi8",
        },
        npc_dota_hero_tinker_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_tinker/agi/agi-talant-9.png", name = "npc_dota_hero_tinker_agi9",
        },
        npc_dota_hero_tinker_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_tinker/agi/agi-talant-10.png", name = "npc_dota_hero_tinker_agi10",
        },
        npc_dota_hero_tinker_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_tinker/agi/agi-talant-11.png", name = "npc_dota_hero_tinker_agi11",
        },
        npc_dota_hero_tinker_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_tinker/agi/agi-talant-12.png", name = "npc_dota_hero_tinker_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_tinker_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_tinker/int/int-talant-6.png", name = "npc_dota_hero_tinker_int6",
        },
        npc_dota_hero_tinker_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_tinker/int/int-talant-7.png", name = "npc_dota_hero_tinker_int7",
        },
        npc_dota_hero_tinker_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_tinker/int/int-talant-8.png", name = "npc_dota_hero_tinker_int8",
        },
        npc_dota_hero_tinker_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_tinker/int/int-talant-9.png", name = "npc_dota_hero_tinker_int9",
        },
        npc_dota_hero_tinker_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_tinker/int/int-talant-10.png", name = "npc_dota_hero_tinker_int10",
        },
        npc_dota_hero_tinker_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_tinker/int/int-talant-11.png", name = "npc_dota_hero_tinker_int11",
        },
        npc_dota_hero_tinker_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_tinker/int/int-talant-12.png", name = "npc_dota_hero_tinker_int12",
        },
    },
    npc_dota_hero_treant = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_treant_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_treant/str/str-talant-6.png", name = "npc_dota_hero_treant_str6",
        },
        npc_dota_hero_treant_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_treant/str/str-talant-7.png", name = "npc_dota_hero_treant_str7",
        },
        npc_dota_hero_treant_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_treant/str/str-talant-8.png", name = "npc_dota_hero_treant_str8",
        },
        npc_dota_hero_treant_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_treant/str/str-talant-9.png", name = "npc_dota_hero_treant_str9",
        },
        npc_dota_hero_treant_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_treant/str/str-talant-10.png", name = "npc_dota_hero_treant_str10",
        },
        npc_dota_hero_treant_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_treant/str/str-talant-11.png", name = "npc_dota_hero_treant_str11",
        },
        npc_dota_hero_treant_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_treant/str/str-talant-12.png", name = "npc_dota_hero_treant_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_treant_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_treant/agi/agi-talant-6.png", name = "npc_dota_hero_treant_agi6",
        },
        npc_dota_hero_treant_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_treant/agi/agi-talant-7.png", name = "npc_dota_hero_treant_agi7",
        },
        npc_dota_hero_treant_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_treant/agi/agi-talant-8.png", name = "npc_dota_hero_treant_agi8",
        },
        npc_dota_hero_treant_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_treant/agi/agi-talant-9.png", name = "npc_dota_hero_treant_agi9",
        },
        npc_dota_hero_treant_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_treant/agi/agi-talant-10.png", name = "npc_dota_hero_treant_agi10",
        },
        npc_dota_hero_treant_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_treant/agi/agi-talant-11.png", name = "npc_dota_hero_treant_agi11",
        },
        npc_dota_hero_treant_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_treant/agi/agi-talant-12.png", name = "npc_dota_hero_treant_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_treant_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_treant/int/int-talant-6.png", name = "npc_dota_hero_treant_int6",
        },
        npc_dota_hero_treant_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_treant/int/int-talant-7.png", name = "npc_dota_hero_treant_int7",
        },
        npc_dota_hero_treant_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_treant/int/int-talant-8.png", name = "npc_dota_hero_treant_int8",
        },
        npc_dota_hero_treant_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_treant/int/int-talant-9.png", name = "npc_dota_hero_treant_int9",
        },
        npc_dota_hero_treant_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_treant/int/int-talant-10.png", name = "npc_dota_hero_treant_int10",
        },
        npc_dota_hero_treant_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_treant/int/int-talant-11.png", name = "npc_dota_hero_treant_int11",
        },
        npc_dota_hero_treant_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_treant/int/int-talant-12.png", name = "npc_dota_hero_treant_int12",
        },
    },
    npc_dota_hero_warlock = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_warlock_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_warlock/str/str-talant-6.png", name = "npc_dota_hero_warlock_str6",
        },
        npc_dota_hero_warlock_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_warlock/str/str-talant-7.png", name = "npc_dota_hero_warlock_str7",
        },
        npc_dota_hero_warlock_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_warlock/str/str-talant-8.png", name = "npc_dota_hero_warlock_str8",
        },
        npc_dota_hero_warlock_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_warlock/str/str-talant-9.png", name = "npc_dota_hero_warlock_str9",
        },
        npc_dota_hero_warlock_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_warlock/str/str-talant-10.png", name = "npc_dota_hero_warlock_str10",
        },
        npc_dota_hero_warlock_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_warlock/str/str-talant-11.png", name = "npc_dota_hero_warlock_str11",
        },
        npc_dota_hero_warlock_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_warlock/str/str-talant-12.png", name = "npc_dota_hero_warlock_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_warlock_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_warlock/agi/agi-talant-6.png", name = "npc_dota_hero_warlock_agi6",
        },
        npc_dota_hero_warlock_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_warlock/agi/agi-talant-7.png", name = "npc_dota_hero_warlock_agi7",
        },
        npc_dota_hero_warlock_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_warlock/agi/agi-talant-8.png", name = "npc_dota_hero_warlock_agi8",
        },
        npc_dota_hero_warlock_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_warlock/agi/agi-talant-9.png", name = "npc_dota_hero_warlock_agi9",
        },
        npc_dota_hero_warlock_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_warlock/agi/agi-talant-10.png", name = "npc_dota_hero_warlock_agi10",
        },
        npc_dota_hero_warlock_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_warlock/agi/agi-talant-11.png", name = "npc_dota_hero_warlock_agi11",
        },
        npc_dota_hero_warlock_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_warlock/agi/agi-talant-12.png", name = "npc_dota_hero_warlock_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_warlock_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_warlock/int/int-talant-6.png", name = "npc_dota_hero_warlock_int6",
        },
        npc_dota_hero_warlock_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_warlock/int/int-talant-7.png", name = "npc_dota_hero_warlock_int7",
        },
        npc_dota_hero_warlock_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_warlock/int/int-talant-8.png", name = "npc_dota_hero_warlock_int8",
        },
        npc_dota_hero_warlock_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_warlock/int/int-talant-9.png", name = "npc_dota_hero_warlock_int9",
        },
        npc_dota_hero_warlock_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_warlock/int/int-talant-10.png", name = "npc_dota_hero_warlock_int10",
        },
        npc_dota_hero_warlock_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_warlock/int/int-talant-11.png", name = "npc_dota_hero_warlock_int11",
        },
        npc_dota_hero_warlock_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_warlock/int/int-talant-12.png", name = "npc_dota_hero_warlock_int12",
        },
    },
    npc_dota_hero_windrunner = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_windrunner_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_windrunner/str/str-talant-6.png", name = "npc_dota_hero_windrunner_str6",
        },
        npc_dota_hero_windrunner_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_windrunner/str/str-talant-7.png", name = "npc_dota_hero_windrunner_str7",
        },
        npc_dota_hero_windrunner_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_windrunner/str/str-talant-8.png", name = "npc_dota_hero_windrunner_str8",
        },
        npc_dota_hero_windrunner_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_windrunner/str/str-talant-9.png", name = "npc_dota_hero_windrunner_str9",
        },
        npc_dota_hero_windrunner_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_windrunner/str/str-talant-10.png", name = "npc_dota_hero_windrunner_str10",
        },
        npc_dota_hero_windrunner_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_windrunner/str/str-talant-11.png", name = "npc_dota_hero_windrunner_str11",
        },
        npc_dota_hero_windrunner_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_windrunner/str/str-talant-12.png", name = "npc_dota_hero_windrunner_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_windrunner_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-6.png", name = "npc_dota_hero_windrunner_agi6",
        },
        npc_dota_hero_windrunner_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-7.png", name = "npc_dota_hero_windrunner_agi7",
        },
        npc_dota_hero_windrunner_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-8.png", name = "npc_dota_hero_windrunner_agi8",
        },
        npc_dota_hero_windrunner_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-9.png", name = "npc_dota_hero_windrunner_agi9",
        },
        npc_dota_hero_windrunner_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-10.png", name = "npc_dota_hero_windrunner_agi10",
        },
        npc_dota_hero_windrunner_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-11.png", name = "npc_dota_hero_windrunner_agi11",
        },
        npc_dota_hero_windrunner_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_windrunner/agi/agi-talant-12.png", name = "npc_dota_hero_windrunner_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_windrunner_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_windrunner/int/int-talant-6.png", name = "npc_dota_hero_windrunner_int6",
        },
        npc_dota_hero_windrunner_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_windrunner/int/int-talant-7.png", name = "npc_dota_hero_windrunner_int7",
        },
        npc_dota_hero_windrunner_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_windrunner/int/int-talant-8.png", name = "npc_dota_hero_windrunner_int8",
        },
        npc_dota_hero_windrunner_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_windrunner/int/int-talant-9.png", name = "npc_dota_hero_windrunner_int9",
        },
        npc_dota_hero_windrunner_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_windrunner/int/int-talant-10.png", name = "npc_dota_hero_windrunner_int10",
        },
        npc_dota_hero_windrunner_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_windrunner/int/int-talant-11.png", name = "npc_dota_hero_windrunner_int11",
        },
        npc_dota_hero_windrunner_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_windrunner/int/int-talant-12.png", name = "npc_dota_hero_windrunner_int12",
        },
    },
    npc_dota_hero_wisp = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_wisp_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_wisp/str/str-talant-6.png", name = "npc_dota_hero_wisp_str6",
        },
        npc_dota_hero_wisp_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_wisp/str/str-talant-7.png", name = "npc_dota_hero_wisp_str7",
        },
        npc_dota_hero_wisp_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_wisp/str/str-talant-8.png", name = "npc_dota_hero_wisp_str8",
        },
        npc_dota_hero_wisp_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_wisp/str/str-talant-9.png", name = "npc_dota_hero_wisp_str9",
        },
        npc_dota_hero_wisp_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_wisp/str/str-talant-10.png", name = "npc_dota_hero_wisp_str10",
        },
        npc_dota_hero_wisp_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_wisp/str/str-talant-11.png", name = "npc_dota_hero_wisp_str11",
        },
        npc_dota_hero_wisp_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_wisp/str/life_stealer_infest.png", name = "lifestealer_infest_bh",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_wisp_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_wisp/agi/agi-talant-6.png", name = "npc_dota_hero_wisp_agi6",
        },
        npc_dota_hero_wisp_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_wisp/agi/agi-talant-7.png", name = "npc_dota_hero_wisp_agi7",
        },
        npc_dota_hero_wisp_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_wisp/agi/agi-talant-8.png", name = "npc_dota_hero_wisp_agi8",
        },
        npc_dota_hero_wisp_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_wisp/agi/agi-talant-9.png", name = "npc_dota_hero_wisp_agi9",
        },
        npc_dota_hero_wisp_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_wisp/agi/agi-talant-10.png", name = "npc_dota_hero_wisp_agi10",
        },
        npc_dota_hero_wisp_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_wisp/agi/agi-talant-11.png", name = "npc_dota_hero_wisp_agi11",
        },
        npc_dota_hero_wisp_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_wisp/agi/agi-talant-12.png", name = "npc_dota_hero_wisp_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_wisp_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_wisp/int/int-talant-6.png", name = "npc_dota_hero_wisp_int6",
        },
        npc_dota_hero_wisp_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_wisp/int/int-talant-7.png", name = "npc_dota_hero_wisp_int7",
        },
        npc_dota_hero_wisp_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_wisp/int/int-talant-8.png", name = "npc_dota_hero_wisp_int8",
        },
        npc_dota_hero_wisp_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_wisp/int/int-talant-9.png", name = "npc_dota_hero_wisp_int9",
        },
        npc_dota_hero_wisp_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_wisp/int/int-talant-10.png", name = "npc_dota_hero_wisp_int10",
        },
        npc_dota_hero_wisp_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_wisp/int/int-talant-11.png", name = "npc_dota_hero_wisp_int11",
        },
        npc_dota_hero_wisp_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_wisp/int/int-talant-12.png", name = "npc_dota_hero_wisp_int12",
        },
    },
    npc_dota_hero_zuus = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_zuus_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_zuus/str/3.png", name = "npc_dota_hero_zuus_str6",
        },
        npc_dota_hero_zuus_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_zuus/str/2.png", name = "npc_dota_hero_zuus_str7",
        },
        npc_dota_hero_zuus_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_zuus/str/4.png", name = "npc_dota_hero_zuus_str8",
        },
        npc_dota_hero_zuus_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_zuus/str/3.png", name = "npc_dota_hero_zuus_str9",
        },
        npc_dota_hero_zuus_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_zuus/str/4.png", name = "npc_dota_hero_zuus_str10",
        },
        npc_dota_hero_zuus_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_zuus/str/4.png", name = "npc_dota_hero_zuus_str11",
        },
        npc_dota_hero_zuus_str12 = {
            place = {"str 12"}, url = "/npc_dota_hero_zuus/str/3.png", name = "npc_dota_hero_zuus_str12",
        },
        npc_dota_hero_zuus_str13 = {
            place = {"str 13"}, url = "/npc_dota_hero_zuus/str/4.png", name = "npc_dota_hero_zuus_str13",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_zuus_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_zuus/agi/1.png", name = "npc_dota_hero_zuus_agi6",
        },
        npc_dota_hero_zuus_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_zuus/agi/2.png", name = "npc_dota_hero_zuus_agi7",
        },
        npc_dota_hero_zuus_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_zuus/agi/0.png", name = "npc_dota_hero_zuus_agi8",
        },
        npc_dota_hero_zuus_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_zuus/agi/1.png", name = "npc_dota_hero_zuus_agi9",
        },
        npc_dota_hero_zuus_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_zuus/agi/5.png", name = "npc_dota_hero_zuus_agi10",
        },
        npc_dota_hero_zuus_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_zuus/agi/0.png", name = "npc_dota_hero_zuus_agi11",
        },
        npc_dota_hero_zuus_agi12 = {
            place = {"agi 12"}, url = "/npc_dota_hero_zuus/agi/5.png", name = "npc_dota_hero_zuus_agi12",
        },
        npc_dota_hero_zuus_agi13 = {
            place = {"agi 13"}, url = "/npc_dota_hero_zuus/agi/5.png", name = "npc_dota_hero_zuus_agi13",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_zuus_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_zuus/int/1.png", name = "npc_dota_hero_zuus_int6",
        },
        npc_dota_hero_zuus_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_zuus/int/2.png", name = "npc_dota_hero_zuus_int7",
        },
        npc_dota_hero_zuus_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_zuus/int/4.png", name = "npc_dota_hero_zuus_int8",
        },
        npc_dota_hero_zuus_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_zuus/int/1.png", name = "npc_dota_hero_zuus_int9",
        },
        npc_dota_hero_zuus_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_zuus/int/2.png", name = "npc_dota_hero_zuus_int10",
        },
        npc_dota_hero_zuus_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_zuus/int/3.png", name = "npc_dota_hero_zuus_int11",
        },
        npc_dota_hero_zuus_int12 = {
            place = {"int 12"}, url = "/npc_dota_hero_zuus/int/3.png", name = "npc_dota_hero_zuus_int12",
        },
        npc_dota_hero_zuus_int13 = {
            place = {"int 13"}, url = "/npc_dota_hero_zuus/int/5.png", name = "npc_dota_hero_zuus_int13",
        },
    },
    npc_dota_hero_medusa = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_medusa_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_medusa/str/str-talant-13.png", name = "npc_dota_hero_medusa_str6",
        },
        npc_dota_hero_medusa_str10 = {
            place = {"str 7"}, url = "/npc_dota_hero_medusa/str/str-talant-10.png", name = "npc_dota_hero_medusa_str10",
        },
        npc_dota_hero_medusa_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_medusa/str/medusa_stone_gaze.png", name = "npc_dota_hero_medusa_str8",
        },
        npc_dota_hero_medusa_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_medusa/str/str-talant-9.png", name = "npc_dota_hero_medusa_str9",
        },
        npc_dota_hero_medusa_str7 = {
            place = {"str 10"}, url = "/npc_dota_hero_medusa/str/str-talant-9.png", name = "npc_dota_hero_medusa_str7",
        },
        npc_dota_hero_medusa_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_medusa/str/str-talant-11.png", name = "npc_dota_hero_medusa_str11",
        },
        npc_dota_hero_medusa_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_medusa/str/str-talant-12.png", name = "npc_dota_hero_medusa_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_medusa_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_medusa/agi/agi-talant-12.png", name = "npc_dota_hero_medusa_agi6",
        },
        npc_dota_hero_medusa_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_medusa/agi/agi-talant-13.png", name = "npc_dota_hero_medusa_agi7",
        },
        npc_dota_hero_medusa_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_medusa/agi/agi-talant-8.png", name = "npc_dota_hero_medusa_agi8",
        },
        npc_dota_hero_medusa_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_medusa/agi/agi-talant-9.png", name = "npc_dota_hero_medusa_agi9",
        },
        npc_dota_hero_medusa_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_medusa/agi/agi-talant-10.png", name = "npc_dota_hero_medusa_agi10",
        },
        npc_dota_hero_medusa_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_medusa/agi/agi-talant-11.png", name = "npc_dota_hero_medusa_agi11",
        },
        npc_dota_hero_medusa_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_medusa/agi/agi-talant-6.png", name = "npc_dota_hero_medusa_agi6",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_medusa_int7 = {
            place = {"int 6"}, url = "/npc_dota_hero_medusa/int/int-talant-6.png", name = "npc_dota_hero_medusa_int7",
        },
        npc_dota_hero_medusa_int9 = {
            place = {"int 7"}, url = "/npc_dota_hero_medusa/int/int-talant-9.png", name = "npc_dota_hero_medusa_int9",
        },
        npc_dota_hero_medusa_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_medusa/int/int-talant-6.png", name = "npc_dota_hero_medusa_int8",
        },
        npc_dota_hero_medusa_int6 = {
            place = {"int 9"}, url = "/npc_dota_hero_medusa/int/int-talant-6.png", name = "npc_dota_hero_medusa_int6",
        },
        npc_dota_hero_medusa_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_medusa/int/int-talant-10.png", name = "npc_dota_hero_medusa_int10",
        },
        npc_dota_hero_medusa_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_medusa/int/int-talant-6.png", name = "npc_dota_hero_medusa_int11",
        },
        npc_dota_hero_medusa_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_medusa/int/int-talant-6.png", name = "npc_dota_hero_medusa_int12",
        },
    },
    npc_dota_hero_legion_commander = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_legion_commander_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_legion_commander/str/str-talant-6.png", name = "npc_dota_hero_legion_commander_str6",
        },
        npc_dota_hero_legion_commander_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_legion_commander/str/str-talant-7.png", name = "npc_dota_hero_legion_commander_str7",
        },
        npc_dota_hero_legion_commander_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_legion_commander/str/str-talant-8.png", name = "npc_dota_hero_legion_commander_str8",
        },
        npc_dota_hero_legion_commander_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_legion_commander/str/str-talant-9.png", name = "npc_dota_hero_legion_commander_str9",
        },
        npc_dota_hero_legion_commander_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_legion_commander/str/str-talant-10.png", name = "npc_dota_hero_legion_commander_str10",
        },
        npc_dota_hero_legion_commander_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_legion_commander/str/str-talant-11.png", name = "npc_dota_hero_legion_commander_str11",
        },
        npc_dota_hero_legion_commander_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_legion_commander/str/str-talant-12.png", name = "npc_dota_hero_legion_commander_str12",
        },
        special_bonus_unique_npc_dota_hero_legion_commander_str50 = {
            place = {"str 13"}, url = "/npc_dota_hero_legion_commander/str/str-talant-12.png", name = "npc_dota_hero_legion_commander_str13",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_legion_commander_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-6.png", name = "npc_dota_hero_legion_commander_agi6",
        },
        npc_dota_hero_legion_commander_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-7.png", name = "npc_dota_hero_legion_commander_agi7",
        },
        npc_dota_hero_legion_commander_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-8.png", name = "npc_dota_hero_legion_commander_agi8",
        },
        npc_dota_hero_legion_commander_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-9.png", name = "npc_dota_hero_legion_commander_agi9",
        },
        npc_dota_hero_legion_commander_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-10.png", name = "npc_dota_hero_legion_commander_agi10",
        },
        npc_dota_hero_legion_commander_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-11.png", name = "npc_dota_hero_legion_commander_agi11",
        },
        npc_dota_hero_legion_commander_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-12.png", name = "npc_dota_hero_legion_commander_agi12",
        },
        special_bonus_unique_npc_dota_hero_legion_commander_agi50 = {
            place = {"agi 13"}, url = "/npc_dota_hero_legion_commander/agi/agi-talant-12.png", name = "npc_dota_hero_legion_commander_agi_13",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_legion_commander_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_legion_commander/int/int-talant-6.png", name = "npc_dota_hero_legion_commander_int6",
        },
        npc_dota_hero_legion_commander_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_legion_commander/int/int-talant-7.png", name = "npc_dota_hero_legion_commander_int7",
        },
        npc_dota_hero_legion_commander_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_legion_commander/int/int-talant-8.png", name = "npc_dota_hero_legion_commander_int8",
        },
        npc_dota_hero_legion_commander_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_legion_commander/int/int-talant-9.png", name = "npc_dota_hero_legion_commander_int9",
        },
        npc_dota_hero_legion_commander_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_legion_commander/int/int-talant-10.png", name = "npc_dota_hero_legion_commander_int10",
        },
        npc_dota_hero_legion_commander_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_legion_commander/int/int-talant-11.png", name = "npc_dota_hero_legion_commander_int11",
        },
        npc_dota_hero_legion_commander_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_legion_commander/int/int-talant-8.png", name = "npc_dota_hero_legion_commander_int12",
        },
        special_bonus_unique_npc_dota_hero_legion_commander_int50 = {
            place = {"int 13"}, url = "/npc_dota_hero_legion_commander/int/int-talant-12.png", name = "npc_dota_hero_legion_commander_int_13",
        },
    },
    npc_dota_hero_skywrath_mage = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_skywrath_mage_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-6.png", name = "npc_dota_hero_skywrath_mage_str6",
        },
        npc_dota_hero_skywrath_mage_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-7.png", name = "npc_dota_hero_skywrath_mage_str7",
        },
        npc_dota_hero_skywrath_mage_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-8.png", name = "npc_dota_hero_skywrath_mage_str8",
        },
        npc_dota_hero_skywrath_mage_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-9.png", name = "npc_dota_hero_skywrath_mage_str9",
        },
        npc_dota_hero_skywrath_mage_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-10.png", name = "npc_dota_hero_skywrath_mage_str10",
        },
        npc_dota_hero_skywrath_mage_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-11.png", name = "npc_dota_hero_skywrath_mage_str11",
        },
        npc_dota_hero_skywrath_mage_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_skywrath_mage/str/str-talant-12.png", name = "npc_dota_hero_skywrath_mage_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_skywrath_mage_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-6.png", name = "npc_dota_hero_skywrath_mage_agi6",
        },
        npc_dota_hero_skywrath_mage_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-7.png", name = "npc_dota_hero_skywrath_mage_agi7",
        },
        npc_dota_hero_skywrath_mage_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-8.png", name = "npc_dota_hero_skywrath_mage_agi8",
        },
        npc_dota_hero_skywrath_mage_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-9.png", name = "npc_dota_hero_skywrath_mage_agi9",
        },
        npc_dota_hero_skywrath_mage_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-10.png", name = "npc_dota_hero_skywrath_mage_agi10",
        },
        npc_dota_hero_skywrath_mage_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-11.png", name = "npc_dota_hero_skywrath_mage_agi11",
        },
        npc_dota_hero_skywrath_mage_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_skywrath_mage/agi/agi-talant-12.png", name = "npc_dota_hero_skywrath_mage_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_skywrath_mage_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-6.png", name = "npc_dota_hero_skywrath_mage_int6",
        },
        npc_dota_hero_skywrath_mage_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-7.png", name = "npc_dota_hero_skywrath_mage_int7",
        },
        npc_dota_hero_skywrath_mage_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-8.png", name = "npc_dota_hero_skywrath_mage_int8",
        },
        npc_dota_hero_skywrath_mage_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-9.png", name = "npc_dota_hero_skywrath_mage_int9",
        },
        npc_dota_hero_skywrath_mage_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-10.png", name = "npc_dota_hero_skywrath_mage_int10",
        },
        npc_dota_hero_skywrath_mage_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-11.png", name = "npc_dota_hero_skywrath_mage_int11",
        },
        npc_dota_hero_skywrath_mage_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_skywrath_mage/int/int-talant-12.png", name = "npc_dota_hero_skywrath_mage_int12",
        },
    },
    npc_dota_hero_doom_bringer = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_doom_bringer_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-6.png", name = "npc_dota_hero_doom_bringer_str6",
        },
        npc_dota_hero_doom_bringer_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-7.png", name = "npc_dota_hero_doom_bringer_str7",
        },
        npc_dota_hero_doom_bringer_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-8.png", name = "npc_dota_hero_doom_bringer_str8",
        },
        npc_dota_hero_doom_bringer_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-9.png", name = "npc_dota_hero_doom_bringer_str9",
        },
        npc_dota_hero_doom_bringer_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-10.png", name = "npc_dota_hero_doom_bringer_str10",
        },
        npc_dota_hero_doom_bringer_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-11.png", name = "npc_dota_hero_doom_bringer_str11",
        },
        npc_dota_hero_doom_bringer_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_doom_bringer/str/str-talant-12.png", name = "npc_dota_hero_doom_bringer_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_doom_bringer_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-6.png", name = "npc_dota_hero_doom_bringer_agi6",
        },
        npc_dota_hero_doom_bringer_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-7.png", name = "npc_dota_hero_doom_bringer_agi7",
        },
        npc_dota_hero_doom_bringer_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-8.png", name = "npc_dota_hero_doom_bringer_agi8",
        },
        npc_dota_hero_doom_bringer_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-9.png", name = "npc_dota_hero_doom_bringer_agi9",
        },
        npc_dota_hero_doom_bringer_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-10.png", name = "npc_dota_hero_doom_bringer_agi10",
        },
        npc_dota_hero_doom_bringer_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-11.png", name = "npc_dota_hero_doom_bringer_agi11",
        },
        npc_dota_hero_doom_bringer_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_doom_bringer/agi/agi-talant-12.png", name = "npc_dota_hero_doom_bringer_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_doom_bringer_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-6.png", name = "npc_dota_hero_doom_bringer_int6",
        },
        npc_dota_hero_doom_bringer_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-7.png", name = "npc_dota_hero_doom_bringer_int7",
        },
        npc_dota_hero_doom_bringer_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-8.png", name = "npc_dota_hero_doom_bringer_int8",
        },
        npc_dota_hero_doom_bringer_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-9.png", name = "npc_dota_hero_doom_bringer_int9",
        },
        npc_dota_hero_doom_bringer_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-10.png", name = "npc_dota_hero_doom_bringer_int10",
        },
        npc_dota_hero_doom_bringer_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-11.png", name = "npc_dota_hero_doom_bringer_int11",
        },
        npc_dota_hero_doom_bringer_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_doom_bringer/int/int-talant-12.png", name = "npc_dota_hero_doom_bringer_int12",
        },
    },
    npc_dota_hero_pudge = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_pudge_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_pudge/str/str-talant-6.png", name = "npc_dota_hero_pudge_str6",
        },
        npc_dota_hero_pudge_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_pudge/str/str-talant-7.png", name = "npc_dota_hero_pudge_str7",
        },
        npc_dota_hero_pudge_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_pudge/str/str-talant-8.png", name = "npc_dota_hero_pudge_str8",
        },
        npc_dota_hero_pudge_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_pudge/str/str-talant-9.png", name = "npc_dota_hero_pudge_str9",
        },
        npc_dota_hero_pudge_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_pudge/str/str-talant-10.png", name = "npc_dota_hero_pudge_str10",
        },
        npc_dota_hero_pudge_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_pudge/str/str-talant-11.png", name = "npc_dota_hero_pudge_str11",
        },
        npc_dota_hero_pudge_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_pudge/str/str-talant-12.png", name = "npc_dota_hero_pudge_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_pudge_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_pudge/agi/agi-talant-6.png", name = "npc_dota_hero_pudge_agi6",
        },
        npc_dota_hero_pudge_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_pudge/agi/agi-talant-7.png", name = "npc_dota_hero_pudge_agi7",
        },
        npc_dota_hero_pudge_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_pudge/agi/agi-talant-8.png", name = "npc_dota_hero_pudge_agi8",
        },
        npc_dota_hero_pudge_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_pudge/agi/agi-talant-9.png", name = "npc_dota_hero_pudge_agi9",
        },
        npc_dota_hero_pudge_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_pudge/agi/agi-talant-10.png", name = "npc_dota_hero_pudge_agi10",
        },
        npc_dota_hero_pudge_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_pudge/agi/agi-talant-11.png", name = "npc_dota_hero_pudge_agi11",
        },
        npc_dota_hero_pudge_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_pudge/agi/agi-talant-12.png", name = "npc_dota_hero_pudge_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_pudge_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_pudge/int/int-talant-6.png", name = "npc_dota_hero_pudge_int6",
        },
        npc_dota_hero_pudge_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_pudge/int/int-talant-7.png", name = "npc_dota_hero_pudge_int7",
        },
        npc_dota_hero_pudge_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_pudge/int/int-talant-8.png", name = "npc_dota_hero_pudge_int8",
        },
        npc_dota_hero_pudge_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_pudge/int/int-talant-9.png", name = "npc_dota_hero_pudge_int9",
        },
        npc_dota_hero_pudge_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_pudge/int/int-talant-10.png", name = "npc_dota_hero_pudge_int10",
        },
        npc_dota_hero_pudge_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_pudge/int/int-talant-11.png", name = "npc_dota_hero_pudge_int11",
        },
        npc_dota_hero_pudge_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_pudge/int/int-talant-12.png", name = "npc_dota_hero_pudge_int12",
        },
    },
    npc_dota_hero_techies = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_techies_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_techies/str/str-talant-6.png", name = "npc_dota_hero_techies_str6",
        },
        npc_dota_hero_techies_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_techies/str/str-talant-7.png", name = "npc_dota_hero_techies_str7",
        },
        npc_dota_hero_techies_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_techies/str/str-talant-8.png", name = "npc_dota_hero_techies_str8",
        },
        npc_dota_hero_techies_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_techies/str/str-talant-9.png", name = "npc_dota_hero_techies_str9",
        },
        npc_dota_hero_techies_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_techies/str/str-talant-10.png", name = "npc_dota_hero_techies_str10",
        },
        npc_dota_hero_techies_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_techies/str/str-talant-11.png", name = "npc_dota_hero_techies_str11",
        },
        npc_dota_hero_techies_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_techies/str/str-talant-12.png", name = "npc_dota_hero_techies_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_techies_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_techies/agi/agi-talant-6.png", name = "npc_dota_hero_techies_agi6",
        },
        npc_dota_hero_techies_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_techies/agi/agi-talant-7.png", name = "npc_dota_hero_techies_agi7",
        },
        npc_dota_hero_techies_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_techies/agi/agi-talant-8.png", name = "npc_dota_hero_techies_agi8",
        },
        npc_dota_hero_techies_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_techies/agi/agi-talant-9.png", name = "npc_dota_hero_techies_agi9",
        },
        npc_dota_hero_techies_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_techies/agi/agi-talant-10.png", name = "npc_dota_hero_techies_agi10",
        },
        npc_dota_hero_techies_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_techies/agi/agi-talant-11.png", name = "npc_dota_hero_techies_agi11",
        },
        npc_dota_hero_techies_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_techies/agi/agi-talant-12.png", name = "npc_dota_hero_techies_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_techies_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_techies/int/int-talant-6.png", name = "npc_dota_hero_techies_int6",
        },
        npc_dota_hero_techies_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_techies/int/int-talant-7.png", name = "npc_dota_hero_techies_int7",
        },
        npc_dota_hero_techies_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_techies/int/int-talant-8.png", name = "npc_dota_hero_techies_int8",
        },
        npc_dota_hero_techies_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_techies/int/int-talant-9.png", name = "npc_dota_hero_techies_int9",
        },
        npc_dota_hero_techies_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_techies/int/int-talant-10.png", name = "npc_dota_hero_techies_int10",
        },
        npc_dota_hero_techies_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_techies/int/int-talant-11.png", name = "npc_dota_hero_techies_int11",
        },
        npc_dota_hero_techies_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_techies/int/int-talant-12.png", name = "npc_dota_hero_techies_int12",
        },
    },
    npc_dota_hero_marci = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_marci_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str6.png", name = "npc_dota_hero_marci_str6",
        },
        npc_dota_hero_marci_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str7.png", name = "npc_dota_hero_marci_str7",
        },
        npc_dota_hero_marci_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str8.png", name = "npc_dota_hero_marci_str8",
        },
        npc_dota_hero_marci_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str9.png", name = "npc_dota_hero_marci_str9",
        },
        npc_dota_hero_marci_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str10.png", name = "npc_dota_hero_marci_str10",
        },
        npc_dota_hero_marci_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str11.png", name = "npc_dota_hero_marci_str11",
        },
        npc_dota_hero_marci_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_marci/str/npc_dota_hero_marci_str_last.png", name = "npc_dota_hero_marci_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_marci_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi6.png", name = "npc_dota_hero_marci_agi6",
        },
        npc_dota_hero_marci_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi7.png", name = "npc_dota_hero_marci_agi7",
        },
        npc_dota_hero_marci_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi8.png", name = "npc_dota_hero_marci_agi8",
        },
        npc_dota_hero_marci_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi9.png", name = "npc_dota_hero_marci_agi9",
        },
        npc_dota_hero_marci_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi10.png", name = "npc_dota_hero_marci_agi10",
        },
        npc_dota_hero_marci_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi11.png", name = "npc_dota_hero_marci_agi11",
        },
        npc_dota_hero_marci_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_marci/agi/npc_dota_hero_marci_agi_last.png", name = "npc_dota_hero_marci_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_marci_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int6.png", name = "npc_dota_hero_marci_int6",
        },
        npc_dota_hero_marci_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int7.png", name = "npc_dota_hero_marci_int7",
        },
        npc_dota_hero_marci_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int8.png", name = "npc_dota_hero_marci_int8",
        },
        npc_dota_hero_marci_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int9.png", name = "npc_dota_hero_marci_int9",
        },
        npc_dota_hero_marci_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int10.png", name = "npc_dota_hero_marci_int10",
        },
        npc_dota_hero_marci_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int11.png", name = "npc_dota_hero_marci_int11",
        },
        npc_dota_hero_marci_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_marci/int/npc_dota_hero_marci_int_last.png", name = "npc_dota_hero_marci_int12",
        },
    },
    npc_dota_hero_crystal_maiden = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_crystal_maiden_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_crystal/str/str-talant-6.png", name = "npc_dota_hero_crystal_maiden_str6",
        },
        npc_dota_hero_crystal_maiden_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_crystal/str/str-talant-7.png", name = "npc_dota_hero_crystal_maiden_str7",
        },
        npc_dota_hero_crystal_maiden_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_crystal/str/str-talant-8.png", name = "npc_dota_hero_crystal_maiden_str8",
        },
        npc_dota_hero_crystal_maiden_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_crystal/str/str-talant-9.png", name = "npc_dota_hero_crystal_maiden_str9",
        },
        npc_dota_hero_crystal_maiden_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_crystal/str/str-talant-10.png", name = "npc_dota_hero_crystal_maiden_str10",
        },
        npc_dota_hero_crystal_maiden_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_crystal/str/str-talant-11.png", name = "npc_dota_hero_crystal_maiden_str11",
        },
        npc_dota_hero_crystal_maiden_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_crystal/str/str-talant-12.png", name = "npc_dota_hero_crystal_maiden_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_crystal_maiden_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_crystal/agi/agi-talant-6.png", name = "npc_dota_hero_crystal_maiden_agi6",
        },
        npc_dota_hero_crystal_maiden_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_crystal/agi/agi-talant-7.png", name = "npc_dota_hero_crystal_maiden_agi7",
        },
        npc_dota_hero_crystal_maiden_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_crystal/agi/agi-talant-8.png", name = "npc_dota_hero_crystal_maiden_agi8",
        },
        npc_dota_hero_crystal_maiden_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_crystal/agi/agi-talant-9.png", name = "npc_dota_hero_crystal_maiden_agi9",
        },
        npc_dota_hero_crystal_maiden_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_crystal/agi/agi-talant-10.png", name = "npc_dota_hero_crystal_maiden_agi10",
        },
        npc_dota_hero_crystal_maiden_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_crystal/agi/agi-talant-11.png", name = "npc_dota_hero_crystal_maiden_agi11",
        },
        npc_dota_hero_crystal_maiden_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_crystal/agi/agi-talant-12.png", name = "npc_dota_hero_crystal_maiden_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_crystal_maiden_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_crystal/int/int-talant-6.png", name = "npc_dota_hero_crystal_maiden_int6",
        },
        npc_dota_hero_crystal_maiden_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_crystal/int/int-talant-7.png", name = "npc_dota_hero_crystal_maiden_int7",
        },
        npc_dota_hero_crystal_maiden_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_crystal/int/int-talant-8.png", name = "npc_dota_hero_crystal_maiden_int8",
        },
        npc_dota_hero_crystal_maiden_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_crystal/int/int-talant-9.png", name = "npc_dota_hero_crystal_maiden_int9",
        },
        npc_dota_hero_crystal_maiden_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_crystal/int/int-talant-10.png", name = "npc_dota_hero_crystal_maiden_int10",
        },
        npc_dota_hero_crystal_maiden_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_crystal/int/int-talant-11.png", name = "npc_dota_hero_crystal_maiden_int11",
        },
        npc_dota_hero_crystal_maiden_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_crystal/int/int-talant-12.png", name = "npc_dota_hero_crystal_maiden_int12",
        },
    },
    npc_dota_hero_alchemist = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_alchemist_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_alchemist/str/str-talant-6.png", name = "npc_dota_hero_alchemist_str6",
        },
        npc_dota_hero_alchemist_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_alchemist/str/str-talant-7.png", name = "npc_dota_hero_alchemist_str7",
        },
        npc_dota_hero_alchemist_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_alchemist/str/str-talant-8.png", name = "npc_dota_hero_alchemist_str8",
        },
        npc_dota_hero_alchemist_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_alchemist/str/str-talant-9.png", name = "npc_dota_hero_alchemist_str9",
        },
        npc_dota_hero_alchemist_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_alchemist/str/str-talant-10.png", name = "npc_dota_hero_alchemist_str10",
        },
        npc_dota_hero_alchemist_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_alchemist/str/str-talant-11.png", name = "npc_dota_hero_alchemist_str11",
        },
        npc_dota_hero_alchemist_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_alchemist/str/str-talant-12.png", name = "npc_dota_hero_alchemist_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_alchemist_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-6.png", name = "npc_dota_hero_alchemist_agi6",
        },
        npc_dota_hero_alchemist_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-7.png", name = "npc_dota_hero_alchemist_agi7",
        },
        npc_dota_hero_alchemist_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-8.png", name = "npc_dota_hero_alchemist_agi8",
        },
        npc_dota_hero_alchemist_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-9.png", name = "npc_dota_hero_alchemist_agi9",
        },
        npc_dota_hero_alchemist_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-10.png", name = "npc_dota_hero_alchemist_agi10",
        },
        npc_dota_hero_alchemist_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-11.png", name = "npc_dota_hero_alchemist_agi11",
        },
        npc_dota_hero_alchemist_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_alchemist/agi/agi-talant-12.png", name = "npc_dota_hero_alchemist_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_alchemist_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_alchemist/int/int-talant-6.png", name = "npc_dota_hero_alchemist_int6",
        },
        npc_dota_hero_alchemist_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_alchemist/int/int-talant-7.png", name = "npc_dota_hero_alchemist_int7",
        },
        npc_dota_hero_alchemist_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_alchemist/int/int-talant-8.png", name = "npc_dota_hero_alchemist_int8",
        },
        npc_dota_hero_alchemist_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_alchemist/int/int-talant-9.png", name = "npc_dota_hero_alchemist_int9",
        },
        npc_dota_hero_alchemist_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_alchemist/int/int-talant-10.png", name = "npc_dota_hero_alchemist_int10",
        },
        npc_dota_hero_alchemist_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_alchemist/int/int-talant-11.png", name = "npc_dota_hero_alchemist_int11",
        },
        npc_dota_hero_alchemist_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_alchemist/int/int-talant-12.png", name = "npc_dota_hero_alchemist_int12",
        },
    },
    npc_dota_hero_troll_warlord = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_troll_warlord_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-6.png", name = "npc_dota_hero_troll_warlord_str6",
        },
        npc_dota_hero_troll_warlord_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-7.png", name = "npc_dota_hero_troll_warlord_str7",
        },
        npc_dota_hero_troll_warlord_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-8.png", name = "npc_dota_hero_troll_warlord_str8",
        },
        npc_dota_hero_troll_warlord_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-9.png", name = "npc_dota_hero_troll_warlord_str9",
        },
        npc_dota_hero_troll_warlord_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-10.png", name = "npc_dota_hero_troll_warlord_str10",
        },
        npc_dota_hero_troll_warlord_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-11.png", name = "npc_dota_hero_troll_warlord_str11",
        },
        npc_dota_hero_troll_warlord_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_troll_warlord/str/str-talant-12.png", name = "npc_dota_hero_troll_warlord_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_troll_warlord_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-6.png", name = "npc_dota_hero_troll_warlord_agi6",
        },
        npc_dota_hero_troll_warlord_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-7.png", name = "npc_dota_hero_troll_warlord_agi7",
        },
        npc_dota_hero_troll_warlord_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-8.png", name = "npc_dota_hero_troll_warlord_agi8",
        },
        npc_dota_hero_troll_warlord_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-9.png", name = "npc_dota_hero_troll_warlord_agi9",
        },
        npc_dota_hero_troll_warlord_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-10.png", name = "npc_dota_hero_troll_warlord_agi10",
        },
        npc_dota_hero_troll_warlord_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-11.png", name = "npc_dota_hero_troll_warlord_agi11",
        },
        npc_dota_hero_troll_warlord_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_troll_warlord/agi/agi-talant-12.png", name = "npc_dota_hero_troll_warlord_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_troll_warlord_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-6.png", name = "npc_dota_hero_troll_warlord_int6",
        },
        npc_dota_hero_troll_warlord_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-7.png", name = "npc_dota_hero_troll_warlord_int7",
        },
        npc_dota_hero_troll_warlord_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-8.png", name = "npc_dota_hero_troll_warlord_int8",
        },
        npc_dota_hero_troll_warlord_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-9.png", name = "npc_dota_hero_troll_warlord_int9",
        },
        npc_dota_hero_troll_warlord_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-10.png", name = "npc_dota_hero_troll_warlord_int10",
        },
        npc_dota_hero_troll_warlord_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-11.png", name = "npc_dota_hero_troll_warlord_int11",
        },
        npc_dota_hero_troll_warlord_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_troll_warlord/int/int-talant-12.png", name = "npc_dota_hero_troll_warlord_int12",
        },
    },
    npc_dota_hero_gyrocopter = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_gyrocopter_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-6.png", name = "npc_dota_hero_gyrocopter_str6",
        },
        npc_dota_hero_gyrocopter_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-7.png", name = "npc_dota_hero_gyrocopter_str7",
        },
        npc_dota_hero_gyrocopter_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-8.png", name = "npc_dota_hero_gyrocopter_str8",
        },
        npc_dota_hero_gyrocopter_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-9.png", name = "npc_dota_hero_gyrocopter_str9",
        },
        npc_dota_hero_gyrocopter_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-10.png", name = "npc_dota_hero_gyrocopter_str10",
        },
        npc_dota_hero_gyrocopter_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-11.png", name = "npc_dota_hero_gyrocopter_str11",
        },
        npc_dota_hero_gyrocopter_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_gyrocopter/str/str-talant-12.png", name = "npc_dota_hero_gyrocopter_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_gyrocopter_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-6.png", name = "npc_dota_hero_gyrocopter_agi6",
        },
        npc_dota_hero_gyrocopter_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-7.png", name = "npc_dota_hero_gyrocopter_agi7",
        },
        npc_dota_hero_gyrocopter_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-8.png", name = "npc_dota_hero_gyrocopter_agi8",
        },
        npc_dota_hero_gyrocopter_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-9.png", name = "npc_dota_hero_gyrocopter_agi9",
        },
        npc_dota_hero_gyrocopter_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-10.png", name = "npc_dota_hero_gyrocopter_agi10",
        },
        npc_dota_hero_gyrocopter_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-11.png", name = "npc_dota_hero_gyrocopter_agi11",
        },
        npc_dota_hero_gyrocopter_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_gyrocopter/agi/agi-talant-12.png", name = "npc_dota_hero_gyrocopter_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_gyrocopter_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-6.png", name = "npc_dota_hero_gyrocopter_int6",
        },
        npc_dota_hero_gyrocopter_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-7.png", name = "npc_dota_hero_gyrocopter_int7",
        },
        npc_dota_hero_gyrocopter_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-8.png", name = "npc_dota_hero_gyrocopter_int8",
        },
        npc_dota_hero_gyrocopter_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-9.png", name = "npc_dota_hero_gyrocopter_int9",
        },
        npc_dota_hero_gyrocopter_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-10.png", name = "npc_dota_hero_gyrocopter_int10",
        },
        npc_dota_hero_gyrocopter_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-11.png", name = "npc_dota_hero_gyrocopter_int11",
        },
        npc_dota_hero_gyrocopter_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_gyrocopter/int/int-talant-12.png", name = "npc_dota_hero_gyrocopter_int12",
        },
    },
    npc_dota_hero_ancient_apparition = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_ancient_apparition_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-6.png", name = "npc_dota_hero_ancient_apparition_str6", 
        },
        npc_dota_hero_ancient_apparition_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-7.png", name = "npc_dota_hero_ancient_apparition_str7", 
        },
        npc_dota_hero_ancient_apparition_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-8.png", name = "npc_dota_hero_ancient_apparition_str8", 
        },
        npc_dota_hero_ancient_apparition_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-9.png", name = "npc_dota_hero_ancient_apparition_str9", 
        },
        npc_dota_hero_ancient_apparition_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-10.png", name = "npc_dota_hero_ancient_apparition_str10", 
        },
        npc_dota_hero_ancient_apparition_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-11.png", name = "npc_dota_hero_ancient_apparition_str11", 
        },
        npc_dota_hero_ancient_apparition_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_ancient_apparition/str/str-talant-12.png", name = "npc_dota_hero_ancient_apparition_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_ancient_apparition_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-6.png", name = "npc_dota_hero_ancient_apparition_agi6", 
        },
        npc_dota_hero_ancient_apparition_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-7.png", name = "npc_dota_hero_ancient_apparition_agi7", 
        },
        npc_dota_hero_ancient_apparition_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-8.png", name = "npc_dota_hero_ancient_apparition_agi8", 
        },
        npc_dota_hero_ancient_apparition_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-9.png", name = "npc_dota_hero_ancient_apparition_agi9", 
        },
        npc_dota_hero_ancient_apparition_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-10.png", name = "npc_dota_hero_ancient_apparition_agi10", 
        },
        npc_dota_hero_ancient_apparition_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-11.png", name = "npc_dota_hero_ancient_apparition_agi11", 
        },
        npc_dota_hero_ancient_apparition_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_ancient_apparition/agi/agi-talant-12.png", name = "npc_dota_hero_ancient_apparition_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_ancient_apparition_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-6.png", name = "npc_dota_hero_ancient_apparition_int6", 
        },
        npc_dota_hero_ancient_apparition_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-7.png", name = "npc_dota_hero_ancient_apparition_int7", 
        },
        npc_dota_hero_ancient_apparition_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-8.png", name = "npc_dota_hero_ancient_apparition_int8", 
        },
        npc_dota_hero_ancient_apparition_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-9.png", name = "npc_dota_hero_ancient_apparition_int9", 
        },
        npc_dota_hero_ancient_apparition_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-10.png", name = "npc_dota_hero_ancient_apparition_int10", 
        },
        npc_dota_hero_ancient_apparition_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-11.png", name = "npc_dota_hero_ancient_apparition_int11", 
        },
        npc_dota_hero_ancient_apparition_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_ancient_apparition/int/int-talant-12.png", name = "npc_dota_hero_ancient_apparition_int12", 
        },
    },
    npc_dota_hero_bloodseeker = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_bloodseeker_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_bloodseeker/str/str-talant-6.png", name = "npc_dota_hero_bloodseeker_str6", 
        },
        npc_dota_hero_bloodseeker_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_bloodseeker/str/bloodseeker_thirst.png", name = "npc_dota_hero_bloodseeker_str7", 
        },
        npc_dota_hero_bloodseeker_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_bloodseeker/str/str-talant-8.png", name = "npc_dota_hero_bloodseeker_str8", 
        },
        npc_dota_hero_bloodseeker_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_bloodseeker/str/str-talant-9.png", name = "npc_dota_hero_bloodseeker_str9", 
        },
        npc_dota_hero_bloodseeker_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_bloodseeker/str/bloodseeker_thirst.png", name = "npc_dota_hero_bloodseeker_str10", 
        },
        npc_dota_hero_bloodseeker_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_bloodseeker/str/str-talant-11.png", name = "npc_dota_hero_bloodseeker_str11", 
        },
        npc_dota_hero_bloodseeker_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_bloodseeker/str/str-talant-12.png", name = "npc_dota_hero_bloodseeker_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_bloodseeker_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-6.png", name = "npc_dota_hero_bloodseeker_agi6", 
        },
        npc_dota_hero_bloodseeker_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-7.png", name = "npc_dota_hero_bloodseeker_agi7", 
        },
        npc_dota_hero_bloodseeker_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-8.png", name = "npc_dota_hero_bloodseeker_agi8", 
        },
        npc_dota_hero_bloodseeker_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-9.png", name = "npc_dota_hero_bloodseeker_agi9", 
        },
        npc_dota_hero_bloodseeker_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-10.png", name = "npc_dota_hero_bloodseeker_agi10", 
        },
        npc_dota_hero_bloodseeker_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-6.png", name = "npc_dota_hero_bloodseeker_agi11",
        },
        npc_dota_hero_bloodseeker_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_bloodseeker/agi/agi-talant-10.png", name = "npc_dota_hero_bloodseeker_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_bloodseeker_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-9.png", name = "npc_dota_hero_bloodseeker_int6",
        },
        npc_dota_hero_bloodseeker_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-7.png", name = "npc_dota_hero_bloodseeker_int7",
        },
        npc_dota_hero_bloodseeker_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-8.png", name = "npc_dota_hero_bloodseeker_int8",
        },
        npc_dota_hero_bloodseeker_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-9.png", name = "npc_dota_hero_bloodseeker_int9",
        },
        npc_dota_hero_bloodseeker_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-12.png", name = "npc_dota_hero_bloodseeker_int10",
        },
        npc_dota_hero_bloodseeker_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-11.png", name = "npc_dota_hero_bloodseeker_int11",
        },
        npc_dota_hero_bloodseeker_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_bloodseeker/int/int-talant-12.png", name = "npc_dota_hero_bloodseeker_int12",
        },
    },
    npc_dota_hero_magnataur = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_magnataur_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_magnataur/str/str-talant-11.png", name = "npc_dota_hero_magnataur_str6",
        },
        npc_dota_hero_magnataur_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_magnataur/str/str-talant-7.png", name = "npc_dota_hero_magnataur_str7",
        },
        npc_dota_hero_magnataur_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_magnataur/str/str-talant-8.png", name = "npc_dota_hero_magnataur_str8",
        },
        npc_dota_hero_magnataur_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_magnataur/str/str-talant-12.png", name = "npc_dota_hero_magnataur_str9",
        },
        npc_dota_hero_magnataur_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_magnataur/str/str-talant-11.png", name = "npc_dota_hero_magnataur_str10",
        },
        npc_dota_hero_magnataur_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_magnataur/str/str-talant-11.png", name = "npc_dota_hero_magnataur_str11",
        },
        npc_dota_hero_magnataur_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_magnataur/str/str-talant-9.png", name = "npc_dota_hero_magnataur_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_magnataur_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-6.png", name = "npc_dota_hero_magnataur_agi6",
        },
        npc_dota_hero_magnataur_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-6.png", name = "npc_dota_hero_magnataur_agi7",
        },
        npc_dota_hero_magnataur_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-8.png", name = "npc_dota_hero_magnataur_agi8",
        },
        npc_dota_hero_magnataur_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-9.png", name = "npc_dota_hero_magnataur_agi9",
        },
        npc_dota_hero_magnataur_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-10.png", name = "npc_dota_hero_magnataur_agi10",
        },
        npc_dota_hero_magnataur_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-11.png", name = "npc_dota_hero_magnataur_agi11",
        },
        npc_dota_hero_magnataur_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_magnataur/agi/agi-talant-12.png", name = "npc_dota_hero_magnataur_agi12",
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_magnataur_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_magnataur/int/int-talant-6.png", name = "npc_dota_hero_magnataur_int6",
        },
        npc_dota_hero_magnataur_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_magnataur/int/int-talant-12.png", name = "npc_dota_hero_magnataur_int7", 
        },
        npc_dota_hero_magnataur_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_magnataur/int/int-talant-8.png", name = "npc_dota_hero_magnataur_int8", 
        },
        npc_dota_hero_magnataur_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_magnataur/int/int-talant-9.png", name = "npc_dota_hero_magnataur_int9", 
        },
        npc_dota_hero_magnataur_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_magnataur/int/int-talant-11.png", name = "npc_dota_hero_magnataur_int10", 
        },
        npc_dota_hero_magnataur_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_magnataur/int/int-talant-11.png", name = "npc_dota_hero_magnataur_int11", 
        },
        npc_dota_hero_magnataur_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_magnataur/int/int-talant-12.png", name = "npc_dota_hero_magnataur_int12", 
        },
    },
    npc_dota_hero_huskar = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_huskar_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_huskar/str/1.png", name = "npc_dota_hero_huskar_str6", 
        },
        npc_dota_hero_huskar_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_huskar/str/1.png", name = "npc_dota_hero_huskar_str7", 
        },
        npc_dota_hero_huskar_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_huskar/str/2.png", name = "npc_dota_hero_huskar_str8", 
        },
        npc_dota_hero_huskar_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_huskar/str/1.png", name = "npc_dota_hero_huskar_str9", 
        },
        npc_dota_hero_huskar_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_huskar/str/1.png", name = "npc_dota_hero_huskar_str10", 
        },
        npc_dota_hero_huskar_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_huskar/str/1.png", name = "npc_dota_hero_huskar_str11", 
        },
        npc_dota_hero_huskar_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_huskar/str/2.png", name = "npc_dota_hero_huskar_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_huskar_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_huskar/agi/2.png", name = "npc_dota_hero_huskar_agi6", 
        },
        npc_dota_hero_huskar_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_huskar/agi/1.png", name = "npc_dota_hero_huskar_agi7", 
        },
        npc_dota_hero_huskar_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_huskar/agi/1.png", name = "npc_dota_hero_huskar_agi8", 
        },
        npc_dota_hero_huskar_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_huskar/agi/1.png", name = "npc_dota_hero_huskar_agi9", 
        },
        npc_dota_hero_huskar_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_huskar/agi/2.png", name = "npc_dota_hero_huskar_agi10", 
        },
        npc_dota_hero_huskar_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_huskar/agi/1.png", name = "npc_dota_hero_huskar_agi11", 
        },
        npc_dota_hero_huskar_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_huskar/agi/1.png", name = "npc_dota_hero_huskar_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_huskar_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_huskar/int/1.png", name = "npc_dota_hero_huskar_int6", 
        },
        npc_dota_hero_huskar_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_huskar/int/2.png", name = "npc_dota_hero_huskar_int7", 
        },
        npc_dota_hero_huskar_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_huskar/int/4.png", name = "npc_dota_hero_huskar_int8", 
        },
        npc_dota_hero_huskar_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_huskar/int/1.png", name = "npc_dota_hero_huskar_int9", 
        },
        npc_dota_hero_huskar_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_huskar/int/3.png", name = "npc_dota_hero_huskar_int10", 
        },
        npc_dota_hero_huskar_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_huskar/int/3.png", name = "npc_dota_hero_huskar_int11", 
        },
        npc_dota_hero_huskar_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_huskar/int/3.png", name = "npc_dota_hero_huskar_int12", 
        },
    },
    npc_dota_hero_broodmother = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_broodmother_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_broodmother/str/str-talant-6.png", name = "npc_dota_hero_broodmother_str6", 
        },
        npc_dota_hero_broodmother_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_broodmother/str/str-talant-7.png", name = "npc_dota_hero_broodmother_str7", 
        },
        npc_dota_hero_broodmother_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_broodmother/str/str-talant-8.png", name = "npc_dota_hero_broodmother_str8", 
        },
        npc_dota_hero_broodmother_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_broodmother/str/str-talant-9.png", name = "npc_dota_hero_broodmother_str9", 
        },
        npc_dota_hero_broodmother_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_broodmother/str/str-talant-10.png", name = "npc_dota_hero_broodmother_str10", 
        },
        npc_dota_hero_broodmother_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_broodmother/str/str-talant-11.png", name = "npc_dota_hero_broodmother_str11", 
        },
        npc_dota_hero_broodmother_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_broodmother/str/str-talant-12.png", name = "npc_dota_hero_broodmother_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_broodmother_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-6.png", name = "npc_dota_hero_broodmother_agi6", 
        },
        npc_dota_hero_broodmother_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-7.png", name = "npc_dota_hero_broodmother_agi7", 
        },
        npc_dota_hero_broodmother_agi8 = {
            place = {"agi 10"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-8.png", name = "npc_dota_hero_broodmother_agi8", 
        },
        npc_dota_hero_broodmother_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-9.png", name = "npc_dota_hero_broodmother_agi9", 
        },
        npc_dota_hero_broodmother_agi10 = {
            place = {"agi 8"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-10.png", name = "npc_dota_hero_broodmother_agi10", 
        },
        npc_dota_hero_broodmother_agi11 = {
            place = {"agi 12"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-11.png", name = "npc_dota_hero_broodmother_agi11", 
        },
        npc_dota_hero_broodmother_agi_last = {
            place = {"agi 11"}, url = "/npc_dota_hero_broodmother/agi/agi-talant-12.png", name = "npc_dota_hero_broodmother_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_broodmother_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_broodmother/int/int-talant-6.png", name = "npc_dota_hero_broodmother_int6", 
        },
        npc_dota_hero_broodmother_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_broodmother/int/int-talant-7.png", name = "npc_dota_hero_broodmother_int7", 
        },
        npc_dota_hero_broodmother_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_broodmother/int/int-talant-8.png", name = "npc_dota_hero_broodmother_int8", 
        },
        npc_dota_hero_broodmother_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_broodmother/int/int-talant-9.png", name = "npc_dota_hero_broodmother_int9", 
        },
        npc_dota_hero_broodmother_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_broodmother/int/int-talant-10.png", name = "npc_dota_hero_broodmother_int10", 
        },
        npc_dota_hero_broodmother_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_broodmother/int/int-talant-11.png", name = "npc_dota_hero_broodmother_int11", 
        },
        npc_dota_hero_broodmother_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_broodmother/int/int-talant-12.png", name = "npc_dota_hero_broodmother_int12", 
        },
    },
    npc_dota_hero_silencer = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_silencer_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_silencer/str/2.png", name = "npc_dota_hero_silencer_str6", 
        },
        npc_dota_hero_silencer_str7 = {
            place = {"str 9"}, url = "/npc_dota_hero_silencer/str/3.png", name = "npc_dota_hero_silencer_str7", 
        },
        npc_dota_hero_silencer_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_silencer/str/2.png", name = "npc_dota_hero_silencer_str8", 
        },
        npc_dota_hero_silencer_str9 = {
            place = {"str 7"}, url = "/npc_dota_hero_silencer/str/1.png", name = "npc_dota_hero_silencer_str9", 
        },
        npc_dota_hero_silencer_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_silencer/str/1.png", name = "npc_dota_hero_silencer_str10", 
        },
        npc_dota_hero_silencer_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_silencer/str/2.png", name = "npc_dota_hero_silencer_str11", 
        },
        npc_dota_hero_silencer_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_silencer/str/4.png", name = "npc_dota_hero_silencer_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_silencer_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_silencer/agi/2.png", name = "npc_dota_hero_silencer_agi6", 
        },
        npc_dota_hero_silencer_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_silencer/agi/2.png", name = "npc_dota_hero_silencer_agi7", 
        },
        npc_dota_hero_silencer_agi8 = {
            place = {"agi 10"}, url = "/npc_dota_hero_silencer/agi/2.png", name = "npc_dota_hero_silencer_agi8", 
        },
        npc_dota_hero_silencer_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_silencer/agi/2.png", name = "npc_dota_hero_silencer_agi9", 
        },
        npc_dota_hero_silencer_agi10 = {
            place = {"agi 8"}, url = "/npc_dota_hero_silencer/agi/1.png", name = "npc_dota_hero_silencer_agi10", 
        },
        npc_dota_hero_silencer_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_silencer/agi/1.png", name = "npc_dota_hero_silencer_agi11", 
        },
        npc_dota_hero_silencer_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_silencer/agi/2.png", name = "npc_dota_hero_silencer_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_silencer_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_silencer/int/2.png", name = "npc_dota_hero_silencer_int6", 
        },
        npc_dota_hero_silencer_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_silencer/int/2.png", name = "npc_dota_hero_silencer_int7", 
        },
        npc_dota_hero_silencer_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_silencer/int/3.png", name = "npc_dota_hero_silencer_int8", 
        },
        npc_dota_hero_silencer_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_silencer/int/2.png", name = "npc_dota_hero_silencer_int9", 
        },
        npc_dota_hero_silencer_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_silencer/int/2.png", name = "npc_dota_hero_silencer_int10", 
        },
        npc_dota_hero_silencer_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_silencer/int/3.png", name = "npc_dota_hero_silencer_int11", 
        },
        npc_dota_hero_silencer_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_silencer/int/2.png", name = "npc_dota_hero_silencer_int12", 
        },
    },
    npc_dota_hero_vengefulspirit = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_vengefulspirit_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_vengefulspirit/str/1.png", name = "npc_dota_hero_vengefulspirit_str6", 
        },
        npc_dota_hero_vengefulspirit_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_vengefulspirit/str/3.png", name = "npc_dota_hero_vengefulspirit_str7", 
        },
        npc_dota_hero_vengefulspirit_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_vengefulspirit/str/4.png", name = "npc_dota_hero_vengefulspirit_str8", 
        },
        npc_dota_hero_vengefulspirit_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_vengefulspirit/str/2.png", name = "npc_dota_hero_vengefulspirit_str9", 
        },
        npc_dota_hero_vengefulspirit_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_vengefulspirit/str/3.png", name = "npc_dota_hero_vengefulspirit_str10", 
        },
        npc_dota_hero_vengefulspirit_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_vengefulspirit/str/4.png", name = "npc_dota_hero_vengefulspirit_str11", 
        },
        npc_dota_hero_vengefulspirit_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_vengefulspirit/str/4.png", name = "npc_dota_hero_vengefulspirit_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_vengefulspirit_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_vengefulspirit/agi/2.png", name = "npc_dota_hero_vengefulspirit_agi6", 
        },
        npc_dota_hero_vengefulspirit_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_vengefulspirit/agi/3.png", name = "npc_dota_hero_vengefulspirit_agi7", 
        },
        npc_dota_hero_vengefulspirit_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_vengefulspirit/agi/2.png", name = "npc_dota_hero_vengefulspirit_agi8", 
        },
        npc_dota_hero_vengefulspirit_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_vengefulspirit/agi/4.png", name = "npc_dota_hero_vengefulspirit_agi9", 
        },
        npc_dota_hero_vengefulspirit_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_vengefulspirit/agi/1.png", name = "npc_dota_hero_vengefulspirit_agi10", 
        },
        npc_dota_hero_vengefulspirit_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_vengefulspirit/agi/2.png", name = "npc_dota_hero_vengefulspirit_agi11", 
        },
        npc_dota_hero_vengefulspirit_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_vengefulspirit/agi/4.png", name = "npc_dota_hero_vengefulspirit_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_vengefulspirit_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_vengefulspirit/int/4.png", name = "npc_dota_hero_vengefulspirit_int6", 
        },
        npc_dota_hero_vengefulspirit_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_vengefulspirit/int/2.png", name = "npc_dota_hero_vengefulspirit_int7", 
        },
        npc_dota_hero_vengefulspirit_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_vengefulspirit/int/1.png", name = "npc_dota_hero_vengefulspirit_int8", 
        },
        npc_dota_hero_vengefulspirit_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_vengefulspirit/int/3.png", name = "npc_dota_hero_vengefulspirit_int9", 
        },
        npc_dota_hero_vengefulspirit_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_vengefulspirit/int/2.png", name = "npc_dota_hero_vengefulspirit_int10", 
        },
        npc_dota_hero_vengefulspirit_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_vengefulspirit/int/1.png", name = "npc_dota_hero_vengefulspirit_int11", 
        },
        npc_dota_hero_vengefulspirit_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_vengefulspirit/int/1.png", name = "npc_dota_hero_vengefulspirit_int12", 
        },
    },
    npc_dota_hero_razor = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_razor_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_razor/str/1.png", name = "npc_dota_hero_razor_str6", 
        },
        npc_dota_hero_razor_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_razor/str/4.png", name = "npc_dota_hero_razor_str7", 
        },
        npc_dota_hero_razor_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_razor/str/3.png", name = "npc_dota_hero_razor_str8", 
        },
        npc_dota_hero_razor_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_razor/str/1.png", name = "npc_dota_hero_razor_str9", 
        },
        npc_dota_hero_razor_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_razor/str/4.png", name = "npc_dota_hero_razor_str10", 
        },
        npc_dota_hero_razor_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_razor/str/3.png", name = "npc_dota_hero_razor_str11", 
        },
        npc_dota_hero_razor_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_razor/str/4.png", name = "npc_dota_hero_razor_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_razor_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_razor/agi/4.png", name = "npc_dota_hero_razor_agi6", 
        },
        npc_dota_hero_razor_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_razor/agi/0.png", name = "npc_dota_hero_razor_agi7", 
        },
        npc_dota_hero_razor_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_razor/agi/2.png", name = "npc_dota_hero_razor_agi8", 
        },
        npc_dota_hero_razor_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_razor/agi/2.png", name = "npc_dota_hero_razor_agi9", 
        },
        npc_dota_hero_razor_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_razor/agi/0.png", name = "npc_dota_hero_razor_agi10", 
        },
        npc_dota_hero_razor_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_razor/agi/4.png", name = "npc_dota_hero_razor_agi11", 
        },
        npc_dota_hero_razor_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_razor/agi/2.png", name = "npc_dota_hero_razor_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_razor_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_razor/int/4.png", name = "npc_dota_hero_razor_int6", 
        },
        npc_dota_hero_razor_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_razor/int/3.png", name = "npc_dota_hero_razor_int7", 
        },
        npc_dota_hero_razor_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_razor/int/1.png", name = "npc_dota_hero_razor_int8", 
        },
        npc_dota_hero_razor_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_razor/int/4.png", name = "npc_dota_hero_razor_int9", 
        },
        npc_dota_hero_razor_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_razor/int/3.png", name = "npc_dota_hero_razor_int10", 
        },
        npc_dota_hero_razor_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_razor/int/1.png", name = "npc_dota_hero_razor_int11", 
        },
        npc_dota_hero_razor_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_razor/int/1.png", name = "npc_dota_hero_razor_int12", 
        },
    },
    npc_dota_hero_death_prophet = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_death_prophet_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_death_prophet/str/1.png", name = "npc_dota_hero_death_prophet_str6", 
        },
        npc_dota_hero_death_prophet_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_death_prophet/str/4.png", name = "npc_dota_hero_death_prophet_str7", 
        },
        npc_dota_hero_death_prophet_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_death_prophet/str/3.png", name = "npc_dota_hero_death_prophet_str8", 
        },
        npc_dota_hero_death_prophet_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_death_prophet/str/1.png", name = "npc_dota_hero_death_prophet_str9", 
        },
        npc_dota_hero_death_prophet_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_death_prophet/str/4.png", name = "npc_dota_hero_death_prophet_str10", 
        },
        npc_dota_hero_death_prophet_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_death_prophet/str/3.png", name = "npc_dota_hero_death_prophet_str11", 
        },
        npc_dota_hero_death_prophet_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_death_prophet/str/4.png", name = "npc_dota_hero_death_prophet_str12",
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_death_prophet_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_death_prophet/agi/0.png", name = "npc_dota_hero_death_prophet_agi6", 
        },
        npc_dota_hero_death_prophet_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_death_prophet/agi/1.png", name = "npc_dota_hero_death_prophet_agi7", 
        },
        npc_dota_hero_death_prophet_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_death_prophet/agi/4.png", name = "npc_dota_hero_death_prophet_agi8", 
        },
        npc_dota_hero_death_prophet_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_death_prophet/agi/4.png", name = "npc_dota_hero_death_prophet_agi9", 
        },
        npc_dota_hero_death_prophet_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_death_prophet/agi/1.png", name = "npc_dota_hero_death_prophet_agi10", 
        },
        npc_dota_hero_death_prophet_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_death_prophet/agi/4.png", name = "npc_dota_hero_death_prophet_agi11", 
        },
        npc_dota_hero_death_prophet_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_death_prophet/agi/4.png", name = "npc_dota_hero_death_prophet_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_death_prophet_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_death_prophet/int/1.png", name = "npc_dota_hero_death_prophet_int6", 
        },
        npc_dota_hero_death_prophet_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_death_prophet/int/3.png", name = "npc_dota_hero_death_prophet_int7", 
        },
        npc_dota_hero_death_prophet_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_death_prophet/int/1.png", name = "npc_dota_hero_death_prophet_int8", 
        },
        npc_dota_hero_death_prophet_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_death_prophet/int/4.png", name = "npc_dota_hero_death_prophet_int9", 
        },
        npc_dota_hero_death_prophet_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_death_prophet/int/2.png", name = "npc_dota_hero_death_prophet_int10", 
        },
        npc_dota_hero_death_prophet_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_death_prophet/int/1.png", name = "npc_dota_hero_death_prophet_int11", 
        },  
        npc_dota_hero_death_prophet_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_death_prophet/int/4.png", name = "npc_dota_hero_death_prophet_int12", 
        },
    },
    npc_dota_hero_viper = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_viper_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_viper/str/4.png", name = "npc_dota_hero_viper_str6",
        },
        npc_dota_hero_viper_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_viper/str/3.png", name = "npc_dota_hero_viper_str7",
        },
        npc_dota_hero_viper_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_viper/str/3.png", name = "npc_dota_hero_viper_str8", 
        },
        npc_dota_hero_viper_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_viper/str/2.png", name = "npc_dota_hero_viper_str9", 
        },
        npc_dota_hero_viper_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_viper/str/1.png", name = "npc_dota_hero_viper_str10", 
        },
        npc_dota_hero_viper_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_viper/str/3.png", name = "npc_dota_hero_viper_str11", 
        },
        npc_dota_hero_viper_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_viper/str/3.png", name = "npc_dota_hero_viper_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_viper_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_viper/agi/1.png", name = "npc_dota_hero_viper_agi6", 
        },
        npc_dota_hero_viper_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_viper/agi/0.png", name = "npc_dota_hero_viper_agi7", 
        },
        npc_dota_hero_viper_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_viper/agi/3.png", name = "npc_dota_hero_viper_agi8", 
        },
        npc_dota_hero_viper_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_viper/agi/1.png", name = "npc_dota_hero_viper_agi9", 
        },
        npc_dota_hero_viper_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_viper/agi/2.png", name = "npc_dota_hero_viper_agi10", 
        },
        npc_dota_hero_viper_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_viper/agi/3.png", name = "npc_dota_hero_viper_agi11", 
        },
        npc_dota_hero_viper_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_viper/agi/0.png", name = "npc_dota_hero_viper_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_viper_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_viper/int/1.png", name = "npc_dota_hero_viper_int6", 
        },
        npc_dota_hero_viper_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_viper/int/0.png", name = "npc_dota_hero_viper_int7", 
        },
        npc_dota_hero_viper_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_viper/int/0.png", name = "npc_dota_hero_viper_int8", 
        },
        npc_dota_hero_viper_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_viper/int/1.png", name = "npc_dota_hero_viper_int9", 
        },
        npc_dota_hero_viper_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_viper/int/2.png", name = "npc_dota_hero_viper_int10", 
        }, 
        npc_dota_hero_viper_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_viper/int/4.png", name = "npc_dota_hero_viper_int11", 
        },  
        npc_dota_hero_viper_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_viper/int/1.png", name = "npc_dota_hero_viper_int12", 
        },	
    },
    npc_dota_hero_spirit_breaker = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_spirit_breaker_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_spirit_breaker/str/2.png", name = "npc_dota_hero_spirit_breaker_str6", 
        },
        npc_dota_hero_spirit_breaker_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_spirit_breaker/str/3.png", name = "npc_dota_hero_spirit_breaker_str7", 
        },
        npc_dota_hero_spirit_breaker_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_spirit_breaker/str/2.png", name = "npc_dota_hero_spirit_breaker_str8", 
        },
        npc_dota_hero_spirit_breaker_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_spirit_breaker/str/3.png", name = "npc_dota_hero_spirit_breaker_str9", 
        },
        npc_dota_hero_spirit_breaker_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_spirit_breaker/str/2.png", name = "npc_dota_hero_spirit_breaker_str10", 
        },
        npc_dota_hero_spirit_breaker_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_spirit_breaker/str/2.png", name = "npc_dota_hero_spirit_breaker_str11", 
        },
        npc_dota_hero_spirit_breaker_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_spirit_breaker/str/3.png", name = "npc_dota_hero_spirit_breaker_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_spirit_breaker_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_spirit_breaker/agi/1.png", name = "npc_dota_hero_spirit_breaker_agi6", 
        },
        npc_dota_hero_spirit_breaker_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_spirit_breaker/agi/0.png", name = "npc_dota_hero_spirit_breaker_agi7", 
        },
        npc_dota_hero_spirit_breaker_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_spirit_breaker/agi/3.png", name = "npc_dota_hero_spirit_breaker_agi8", 
        },
        npc_dota_hero_spirit_breaker_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_spirit_breaker/agi/4.png", name = "npc_dota_hero_spirit_breaker_agi9", 
        },
        npc_dota_hero_spirit_breaker_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_spirit_breaker/agi/0.png", name = "npc_dota_hero_spirit_breaker_agi10", 
        },
        npc_dota_hero_spirit_breaker_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_spirit_breaker/agi/3.png", name = "npc_dota_hero_spirit_breaker_agi11", 
        },
        npc_dota_hero_spirit_breaker_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_spirit_breaker/agi/3.png", name = "npc_dota_hero_spirit_breaker_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_spirit_breaker_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_spirit_breaker/int/2.png", name = "npc_dota_hero_spirit_breaker_int6", 
        },
        npc_dota_hero_spirit_breaker_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_spirit_breaker/int/3.png", name = "npc_dota_hero_spirit_breaker_int7", 
        },
        npc_dota_hero_spirit_breaker_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_spirit_breaker/int/4.png", name = "npc_dota_hero_spirit_breaker_int8", 
        }, 
        npc_dota_hero_spirit_breaker_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_spirit_breaker/int/1.png", name = "npc_dota_hero_spirit_breaker_int9", 
        },
        npc_dota_hero_spirit_breaker_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_spirit_breaker/int/3.png", name = "npc_dota_hero_spirit_breaker_int10", 
        }, 
        npc_dota_hero_spirit_breaker_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_spirit_breaker/int/1.png", name = "npc_dota_hero_spirit_breaker_int11", 
        }, 
        npc_dota_hero_spirit_breaker_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_spirit_breaker/int/3.png", name = "npc_dota_hero_spirit_breaker_int12", 
        },	
    },
    npc_dota_hero_dawnbreaker = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_dawnbreaker_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_dawnbreaker/str/3.png", name = "npc_dota_hero_dawnbreaker_str6", 
        },
        npc_dota_hero_dawnbreaker_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_dawnbreaker/str/4.png", name = "npc_dota_hero_dawnbreaker_str7", 
        },
        npc_dota_hero_dawnbreaker_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_dawnbreaker/str/3.png", name = "npc_dota_hero_dawnbreaker_str8", 
        },
        npc_dota_hero_dawnbreaker_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_dawnbreaker/str/1.png", name = "npc_dota_hero_dawnbreaker_str9", 
        },
        npc_dota_hero_dawnbreaker_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_dawnbreaker/str/4.png", name = "npc_dota_hero_dawnbreaker_str10", 
        },
        npc_dota_hero_dawnbreaker_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_dawnbreaker/str/1.png", name = "npc_dota_hero_dawnbreaker_str11", 
        },
        npc_dota_hero_dawnbreaker_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_dawnbreaker/str/4.png", name = "npc_dota_hero_dawnbreaker_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_dawnbreaker_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_dawnbreaker/agi/4.png", name = "npc_dota_hero_dawnbreaker_agi6", 
        },
        npc_dota_hero_dawnbreaker_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_dawnbreaker/agi/3.png", name = "npc_dota_hero_dawnbreaker_agi7", 
        },
        npc_dota_hero_dawnbreaker_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_dawnbreaker/agi/2.png", name = "npc_dota_hero_dawnbreaker_agi8", 
        }, 
        npc_dota_hero_dawnbreaker_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_dawnbreaker/agi/2.png", name = "npc_dota_hero_dawnbreaker_agi9", 
        },
        npc_dota_hero_dawnbreaker_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_dawnbreaker/agi/1.png", name = "npc_dota_hero_dawnbreaker_agi10", 
        },
        npc_dota_hero_dawnbreaker_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_dawnbreaker/agi/4.png", name = "npc_dota_hero_dawnbreaker_agi11", 
        },
        npc_dota_hero_dawnbreaker_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_dawnbreaker/agi/2.png", name = "npc_dota_hero_dawnbreaker_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_dawnbreaker_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_dawnbreaker/int/4.png", name = "npc_dota_hero_dawnbreaker_int6", 
        },
        npc_dota_hero_dawnbreaker_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_dawnbreaker/int/3.png", name = "npc_dota_hero_dawnbreaker_int7", 
        },
        npc_dota_hero_dawnbreaker_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_dawnbreaker/int/1.png", name = "npc_dota_hero_dawnbreaker_int8", 
        }, 
        npc_dota_hero_dawnbreaker_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_dawnbreaker/int/4.png", name = "npc_dota_hero_dawnbreaker_int9", 
        },
        npc_dota_hero_dawnbreaker_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_dawnbreaker/int/3.png", name = "npc_dota_hero_dawnbreaker_int10", 
        },
        npc_dota_hero_dawnbreaker_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_dawnbreaker/int/1.png", name = "npc_dota_hero_dawnbreaker_int11", 
        },  
        npc_dota_hero_dawnbreaker_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_dawnbreaker/int/1.png", name = "npc_dota_hero_dawnbreaker_int12", 
        },	
    },
    npc_dota_hero_riki = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_riki_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_riki/str/4.png", name = "npc_dota_hero_riki_str6", 
        },
        npc_dota_hero_riki_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_riki/str/4.png", name = "npc_dota_hero_riki_str7", 
        },
        npc_dota_hero_riki_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_riki/str/4.png", name = "npc_dota_hero_riki_str8", 
        },  
        npc_dota_hero_riki_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_riki/str/2.png", name = "npc_dota_hero_riki_str9", 
        },
        npc_dota_hero_riki_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_riki/str/1.png", name = "npc_dota_hero_riki_str10", 
        },
        npc_dota_hero_riki_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_riki/str/1.png", name = "npc_dota_hero_riki_str11", 
        },
        npc_dota_hero_riki_str_last = {
            place = {"str 12"}, url = "/npc_dota_hero_riki/str/4.png", name = "npc_dota_hero_riki_str12", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_riki_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_riki/agi/3.png", name = "npc_dota_hero_riki_agi6", 
        },
        npc_dota_hero_riki_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_riki/agi/3.png", name = "npc_dota_hero_riki_agi7", 
        },
        npc_dota_hero_riki_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_riki/agi/4.png", name = "npc_dota_hero_riki_agi8", 
        },
        npc_dota_hero_riki_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_riki/agi/1.png", name = "npc_dota_hero_riki_agi9", 
        },
        npc_dota_hero_riki_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_riki/agi/1.png", name = "npc_dota_hero_riki_agi10", 
        },
        npc_dota_hero_riki_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_riki/agi/2.png", name = "npc_dota_hero_riki_agi11", 
        },
        npc_dota_hero_riki_agi_last = {
            place = {"agi 12"}, url = "/npc_dota_hero_riki/agi/3.png", name = "npc_dota_hero_riki_agi12", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_riki_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_riki/int/3.png", name = "npc_dota_hero_riki_int6", 
        },
        npc_dota_hero_riki_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_riki/int/1.png", name = "npc_dota_hero_riki_int7", 
        },
        npc_dota_hero_riki_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_riki/int/3.png", name = "npc_dota_hero_riki_int8", 
        },
        npc_dota_hero_riki_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_riki/int/3.png", name = "npc_dota_hero_riki_int9", 
        },
        npc_dota_hero_riki_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_riki/int/4.png", name = "npc_dota_hero_riki_int10", 
        },
        npc_dota_hero_riki_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_riki/int/3.png", name = "npc_dota_hero_riki_int11", 
        },  
        npc_dota_hero_riki_int_last = {
            place = {"int 12"}, url = "/npc_dota_hero_riki/int/4.png", name = "npc_dota_hero_riki_int12", 
        },
    },
    npc_dota_hero_leshrac = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_leshrac_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_leshrac/str/1.png", name = "npc_dota_hero_leshrac_str6", 
        },
        npc_dota_hero_leshrac_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_leshrac/str/4.png", name = "npc_dota_hero_leshrac_str7", 
        },
        npc_dota_hero_leshrac_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_leshrac/str/1.png", name = "npc_dota_hero_leshrac_str8", 
        },  
        npc_dota_hero_leshrac_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_leshrac/str/1.png", name = "npc_dota_hero_leshrac_str9", 
        },
        npc_dota_hero_leshrac_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_leshrac/str/4.png", name = "npc_dota_hero_leshrac_str10", 
        },
        npc_dota_hero_leshrac_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_leshrac/str/3.png", name = "npc_dota_hero_leshrac_str11", 
        },
        npc_dota_hero_leshrac_str12 = {
            place = {"str 12"}, url = "/npc_dota_hero_leshrac/str/3.png", name = "npc_dota_hero_leshrac_str12", 
        },
        npc_dota_hero_leshrac_str13 = {
            place = {"str 13"}, url = "/npc_dota_hero_leshrac/str/3.png", name = "npc_dota_hero_leshrac_str13", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_leshrac_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_leshrac/agi/4.png", name = "npc_dota_hero_leshrac_agi6", 
        },
        npc_dota_hero_leshrac_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_leshrac/agi/1.png", name = "npc_dota_hero_leshrac_agi7", 
        },
        npc_dota_hero_leshrac_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_leshrac/agi/2.png", name = "npc_dota_hero_leshrac_agi8", 
        },
        npc_dota_hero_leshrac_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_leshrac/agi/3.png", name = "npc_dota_hero_leshrac_agi9", 
        },
        npc_dota_hero_leshrac_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_leshrac/agi/1.png", name = "npc_dota_hero_leshrac_agi10", 
        },
        npc_dota_hero_leshrac_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_leshrac/agi/2.png", name = "npc_dota_hero_leshrac_agi11", 
        },
        npc_dota_hero_leshrac_agi12 = {
            place = {"agi 12"}, url = "/npc_dota_hero_leshrac/agi/2.png", name = "npc_dota_hero_leshrac_agi12", 
        },
        npc_dota_hero_leshrac_agi13 = {
            place = {"agi 13"}, url = "/npc_dota_hero_leshrac/agi/2.png", name = "npc_dota_hero_leshrac_agi13", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_leshrac_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_leshrac/int/4.png", name = "npc_dota_hero_leshrac_int6", 
        },
        npc_dota_hero_leshrac_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_leshrac/int/4.png", name = "npc_dota_hero_leshrac_int7", 
        },
        npc_dota_hero_leshrac_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_leshrac/int/4.png", name = "npc_dota_hero_leshrac_int8", 
        },
        npc_dota_hero_leshrac_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_leshrac/int/1.png", name = "npc_dota_hero_leshrac_int9", 
        },
        npc_dota_hero_leshrac_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_leshrac/int/3.png", name = "npc_dota_hero_leshrac_int10", 
        },
        npc_dota_hero_leshrac_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_leshrac/int/2.png", name = "npc_dota_hero_leshrac_int11", 
        },  
        npc_dota_hero_leshrac_int12 = {
            place = {"int 12"}, url = "/npc_dota_hero_leshrac/int/4.png", name = "npc_dota_hero_leshrac_int12", 
        },	
        npc_dota_hero_leshrac_int13 = {
            place = {"int 13"}, url = "/npc_dota_hero_leshrac/int/4.png", name = "npc_dota_hero_leshrac_int13", 
        },	
    },
    npc_dota_hero_necrolyte = {
        -------------------- STR -----------------------------------------------------------
        npc_dota_hero_necrolyte_str6 = {
            place = {"str 6"}, url = "/npc_dota_hero_necrolyte/str/3.png", name = "npc_dota_hero_necrolyte_str6", 
        },
        npc_dota_hero_necrolyte_str7 = {
            place = {"str 7"}, url = "/npc_dota_hero_necrolyte/str/1.png", name = "npc_dota_hero_necrolyte_str7", 
        },
        npc_dota_hero_necrolyte_str8 = {
            place = {"str 8"}, url = "/npc_dota_hero_necrolyte/str/2.png", name = "npc_dota_hero_necrolyte_str8", 
        },  
        npc_dota_hero_necrolyte_str9 = {
            place = {"str 9"}, url = "/npc_dota_hero_necrolyte/str/3.png", name = "npc_dota_hero_necrolyte_str9", 
        },
        npc_dota_hero_necrolyte_str10 = {
            place = {"str 10"}, url = "/npc_dota_hero_necrolyte/str/1.png", name = "npc_dota_hero_necrolyte_str10", 
        },
        npc_dota_hero_necrolyte_str11 = {
            place = {"str 11"}, url = "/npc_dota_hero_necrolyte/str/2.png", name = "npc_dota_hero_necrolyte_str11", 
        },
        npc_dota_hero_necrolyte_str12 = {
            place = {"str 12"}, url = "/npc_dota_hero_necrolyte/str/3.png", name = "npc_dota_hero_necrolyte_str12", 
        },
        npc_dota_hero_necrolyte_str13 = {
            place = {"str 13"}, url = "/npc_dota_hero_necrolyte/str/3.png", name = "npc_dota_hero_necrolyte_str13", 
        },
        -------------------- AGI -----------------------------------------------------------
        npc_dota_hero_necrolyte_agi6 = {
            place = {"agi 6"}, url = "/npc_dota_hero_necrolyte/agi/3.png", name = "npc_dota_hero_necrolyte_agi6", 
        },
        npc_dota_hero_necrolyte_agi7 = {
            place = {"agi 7"}, url = "/npc_dota_hero_necrolyte/agi/1.png", name = "npc_dota_hero_necrolyte_agi7", 
        },
        npc_dota_hero_necrolyte_agi8 = {
            place = {"agi 8"}, url = "/npc_dota_hero_necrolyte/agi/2.png", name = "npc_dota_hero_necrolyte_agi8", 
        },
        npc_dota_hero_necrolyte_agi9 = {
            place = {"agi 9"}, url = "/npc_dota_hero_necrolyte/agi/3.png", name = "npc_dota_hero_necrolyte_agi9", 
        },
        npc_dota_hero_necrolyte_agi10 = {
            place = {"agi 10"}, url = "/npc_dota_hero_necrolyte/agi/1.png", name = "npc_dota_hero_necrolyte_agi10", 
        },
        npc_dota_hero_necrolyte_agi11 = {
            place = {"agi 11"}, url = "/npc_dota_hero_necrolyte/agi/2.png", name = "npc_dota_hero_necrolyte_agi11", 
        },
        npc_dota_hero_necrolyte_agi12 = {
            place = {"agi 12"}, url = "/npc_dota_hero_necrolyte/agi/4.png", name = "npc_dota_hero_necrolyte_agi12", 
        },
        npc_dota_hero_necrolyte_agi13 = {
            place = {"agi 13"}, url = "/npc_dota_hero_necrolyte/agi/4.png", name = "npc_dota_hero_necrolyte_agi13", 
        },
        -------------------- INT -----------------------------------------------------------
        npc_dota_hero_necrolyte_int6 = {
            place = {"int 6"}, url = "/npc_dota_hero_necrolyte/int/1.png", name = "npc_dota_hero_necrolyte_int6", 
        },
        npc_dota_hero_necrolyte_int7 = {
            place = {"int 7"}, url = "/npc_dota_hero_necrolyte/int/4.png", name = "npc_dota_hero_necrolyte_int7", 
        },
        npc_dota_hero_necrolyte_int8 = {
            place = {"int 8"}, url = "/npc_dota_hero_necrolyte/int/2.png", name = "npc_dota_hero_necrolyte_int8", 
        },
        npc_dota_hero_necrolyte_int9 = {
            place = {"int 9"}, url = "/npc_dota_hero_necrolyte/int/1.png", name = "npc_dota_hero_necrolyte_int9", 
        },
        npc_dota_hero_necrolyte_int10 = {
            place = {"int 10"}, url = "/npc_dota_hero_necrolyte/int/4.png", name = "npc_dota_hero_necrolyte_int10", 
        },
        npc_dota_hero_necrolyte_int11 = {
            place = {"int 11"}, url = "/npc_dota_hero_necrolyte/int/2.png", name = "npc_dota_hero_necrolyte_int11", 
        },  
        npc_dota_hero_necrolyte_int12 = {
            place = {"int 12"}, url = "/npc_dota_hero_necrolyte/int/4.png", name = "npc_dota_hero_necrolyte_int12", 
        },	
        npc_dota_hero_necrolyte_int13 = {
            place = {"int 13"}, url = "/npc_dota_hero_necrolyte/int/4.png", name = "npc_dota_hero_necrolyte_int13", 
        },	
    },
}