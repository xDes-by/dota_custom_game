if (!Game.GetMapInfo_Engine) {
	Game.GetMapInfo_Engine = Game.GetMapInfo;

	Game.GetMapInfo = function () {
		const map_info = Game.GetMapInfo_Engine();

		if (map_info.map_display_name == "demo_duos") {
			map_info.map_display_name = "duos";
			map_info.map_name = "maps/duos.vpk";
		}

		return map_info;
	};
}

const LOCAL_PLAYER_ID = Game.GetLocalPlayerID();
const LOCAL_STEAM_ID = Game.GetLocalPlayerInfo() ? Game.GetLocalPlayerInfo().player_steamid : "0";
const CURRENT_MAP = Game.GetMapInfo().map_display_name;

function setInterval(callback, interval) {
	interval = interval / 1000;
	$.Schedule(interval, function reschedule() {
		$.Schedule(interval, reschedule);
		callback();
	});
}

function SubscribeToNetTableKey(tableName, key, callback) {
	var immediateValue = CustomNetTables.GetTableValue(tableName, key);
	if (immediateValue != null) callback(immediateValue);
	CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value) {
		if (currentKey === key && value != null) callback(value);
	});
}

const useChineseDateFormat = $.Language() === "schinese" || $.Language() === "tchinese";
/** @param {Date} date */
function formatDate(date) {
	return useChineseDateFormat
		? date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate()
		: date.getMonth() + "/" + date.getDate() + "/" + date.getFullYear();
}

/** @param {Panel} groupRoot */
function getRadioButtonGroupValue(groupRoot) {
	for (const child of groupRoot.Children()) {
		if (child.checked) {
			return child.GetAttributeString("value", undefined);
		}
	}
}

function IsDemoMode() {
	const map_name = Game.GetMapInfo_Engine().map_display_name;
	return map_name == "demo" || map_name == "demo_duos";
}

function IsTournamentMode() {
	return CustomNetTables.GetTableValue("game", "tournament_mode").enabled == 1;
}

const heroesId = {
	npc_dota_hero_antimage: 1,
	npc_dota_hero_axe: 2,
	npc_dota_hero_bane: 3,
	npc_dota_hero_bloodseeker: 4,
	npc_dota_hero_crystal_maiden: 5,
	npc_dota_hero_drow_ranger: 6,
	npc_dota_hero_earthshaker: 7,
	npc_dota_hero_juggernaut: 8,
	npc_dota_hero_mirana: 9,
	npc_dota_hero_nevermore: 11,
	npc_dota_hero_morphling: 10,
	npc_dota_hero_phantom_lancer: 12,
	npc_dota_hero_puck: 13,
	npc_dota_hero_pudge: 14,
	npc_dota_hero_razor: 15,
	npc_dota_hero_sand_king: 16,
	npc_dota_hero_storm_spirit: 17,
	npc_dota_hero_sven: 18,
	npc_dota_hero_tiny: 19,
	npc_dota_hero_vengefulspirit: 20,
	npc_dota_hero_windrunner: 21,
	npc_dota_hero_zuus: 22,
	npc_dota_hero_kunkka: 23,
	npc_dota_hero_lina: 25,
	npc_dota_hero_lich: 31,
	npc_dota_hero_lion: 26,
	npc_dota_hero_shadow_shaman: 27,
	npc_dota_hero_slardar: 28,
	npc_dota_hero_tidehunter: 29,
	npc_dota_hero_witch_doctor: 30,
	npc_dota_hero_riki: 32,
	npc_dota_hero_enigma: 33,
	npc_dota_hero_tinker: 34,
	npc_dota_hero_sniper: 35,
	npc_dota_hero_necrolyte: 36,
	npc_dota_hero_warlock: 37,
	npc_dota_hero_beastmaster: 38,
	npc_dota_hero_queenofpain: 39,
	npc_dota_hero_venomancer: 40,
	npc_dota_hero_faceless_void: 41,
	npc_dota_hero_skeleton_king: 42,
	npc_dota_hero_death_prophet: 43,
	npc_dota_hero_phantom_assassin: 44,
	npc_dota_hero_pugna: 45,
	npc_dota_hero_templar_assassin: 46,
	npc_dota_hero_viper: 47,
	npc_dota_hero_luna: 48,
	npc_dota_hero_dragon_knight: 49,
	npc_dota_hero_dazzle: 50,
	npc_dota_hero_rattletrap: 51,
	npc_dota_hero_leshrac: 52,
	npc_dota_hero_furion: 53,
	npc_dota_hero_life_stealer: 54,
	npc_dota_hero_dark_seer: 55,
	npc_dota_hero_clinkz: 56,
	npc_dota_hero_omniknight: 57,
	npc_dota_hero_enchantress: 58,
	npc_dota_hero_huskar: 59,
	npc_dota_hero_night_stalker: 60,
	npc_dota_hero_broodmother: 61,
	npc_dota_hero_bounty_hunter: 62,
	npc_dota_hero_weaver: 63,
	npc_dota_hero_jakiro: 64,
	npc_dota_hero_batrider: 65,
	npc_dota_hero_chen: 66,
	npc_dota_hero_spectre: 67,
	npc_dota_hero_doom_bringer: 69,
	npc_dota_hero_ancient_apparition: 68,
	npc_dota_hero_ursa: 70,
	npc_dota_hero_spirit_breaker: 71,
	npc_dota_hero_gyrocopter: 72,
	npc_dota_hero_alchemist: 73,
	npc_dota_hero_invoker: 74,
	npc_dota_hero_silencer: 75,
	npc_dota_hero_obsidian_destroyer: 76,
	npc_dota_hero_lycan: 77,
	npc_dota_hero_brewmaster: 78,
	npc_dota_hero_shadow_demon: 79,
	npc_dota_hero_lone_druid: 80,
	npc_dota_hero_chaos_knight: 81,
	npc_dota_hero_meepo: 82,
	npc_dota_hero_treant: 83,
	npc_dota_hero_ogre_magi: 84,
	npc_dota_hero_undying: 85,
	npc_dota_hero_rubick: 86,
	npc_dota_hero_disruptor: 87,
	npc_dota_hero_nyx_assassin: 88,
	npc_dota_hero_naga_siren: 89,
	npc_dota_hero_keeper_of_the_light: 90,
	npc_dota_hero_wisp: 91,
	npc_dota_hero_visage: 92,
	npc_dota_hero_slark: 93,
	npc_dota_hero_medusa: 94,
	npc_dota_hero_troll_warlord: 95,
	npc_dota_hero_centaur: 96,
	npc_dota_hero_magnataur: 97,
	npc_dota_hero_shredder: 98,
	npc_dota_hero_bristleback: 99,
	npc_dota_hero_tusk: 100,
	npc_dota_hero_skywrath_mage: 101,
	npc_dota_hero_abaddon: 102,
	npc_dota_hero_elder_titan: 103,
	npc_dota_hero_legion_commander: 104,
	npc_dota_hero_ember_spirit: 106,
	npc_dota_hero_earth_spirit: 107,
	npc_dota_hero_abyssal_underlord: 108,
	npc_dota_hero_terrorblade: 109,
	npc_dota_hero_phoenix: 110,
	npc_dota_hero_techies: 105,
	npc_dota_hero_oracle: 111,
	npc_dota_hero_winter_wyvern: 112,
	npc_dota_hero_arc_warden: 113,
	npc_dota_hero_monkey_king: 114,
	npc_dota_hero_dark_willow: 119,
	npc_dota_hero_pangolier: 120,
	npc_dota_hero_grimstroke: 121,
	npc_dota_hero_hoodwink: 123,
	npc_dota_hero_void_spirit: 126,
	npc_dota_hero_snapfire: 128,
	npc_dota_hero_mars: 129,
	npc_dota_hero_dawnbreaker: 135,
	npc_dota_hero_marci: 136,
	npc_dota_hero_primal_beast: 137,
};

function GetHeroID(heroName) {
	var result = heroesId[heroName];
	if (result == null) return -1;
	return result;
}

function FormatSeconds(v) {
	const hours = Math.floor(v / 3600);
	v = v - 3600 * hours;
	const minutes = Math.floor(v / 60);
	v = v - 60 * minutes;
	return `${hours.toString()}:${minutes.toString().padStart(2, "0")}:${Math.floor(v).toString().padStart(2, "0")}`;
}

const ShowAbilityTooltip = (ability) => () => $.DispatchEvent("DOTAShowAbilityTooltip", ability, ability.abilityname);
const HideAbilityTooltip = (ability) => () => $.DispatchEvent("DOTAHideAbilityTooltip", ability);

const ShowItemTooltip = (item) => () => $.DispatchEvent("DOTAShowAbilityTooltip", item, item.itemname);
const HideItemTooltip = (item) => () => $.DispatchEvent("DOTAHideAbilityTooltip", item);

const FindDotaHudElement = (id) => dotaHud.FindChildTraverse(id);
const dotaHud = (() => {
	let panel = $.GetContextPanel();
	while (panel) {
		if (panel.id === "DotaHud") return panel;
		panel = panel.GetParent();
	}
})();

function HasModifierByName(unitIndex, name) {
	for (var i = 0; i < Entities.GetNumBuffs(unitIndex); i++) {
		var buffName = Buffs.GetName(unitIndex, Entities.GetBuff(unitIndex, i));

		if (buffName == name) {
			return true;
		}
	}

	return false;
}

function IsLocalizeString(str) {
	if (!str.startsWith("#")) {
		str = "#" + str;
	}

	return $.Localize(str) != str;
}

function IsHeroDefenseMode() {
	return Game.GetMapInfo().map_display_name == "enfos";
}

function LuaTableToArrayDec(nt) {
	var result = [];
	for (var i in nt) {
		result[i - 1] = nt[i];
	}
	return result;
}

function LuaTableToArray(nt) {
	var result = [];
	for (var i in nt) {
		result[i] = nt[i];
	}
	return result;
}

let boostGlow = false;
let glowSchelude;

const DEVS = [
	"76561198132422587", // Sanctus Animus
	"76561198054179075", // darklord
	"76561198052211234", // bukka
	"76561199069138789", // ninepigeons (Chinese tester)
	"76561198007141460", // Firetoad
	"76561198064622537", // Sheodar
	"76561198070058334", // ark120202
	"76561198271575954", // HappyFeedFriends
	"76561198188258659", // Australia is my City
	"76561199069138789", // Dota 2 unofficial
	"76561198249367546", // Flam3s
	"76561198091437567", // Shesmu
];

const CENTER_SCREEN_MENUS = ["Leaderboard", "CollectionCHC", "HistoryWindowGrid", "OptionsContainer", "CustomMail"];

function RegisterKeyBindForMenu(panel, keybind, callback) {
	// somehow when menu opens both events can be triggered
	// so we prevent this using flag preventNamespaceEvent
	let preventNamespaceEvent = false;
	GameUI.RegisterKeybindForCommand(keybind, () => {
		preventNamespaceEvent = true;
		$.Schedule(0, () => {
			preventNamespaceEvent = false;
		});
		callback();
	});

	const keybindString = Game.GetKeybindForCommand(keybind);
	if (keybindString != undefined && keybindString != "") {
		$.RegisterKeyBind("chc_menus", `key_${keybindString}`, () => {
			if (!preventNamespaceEvent) callback();
		});
	}
}

function ToggleMenu(name) {
	const panel = FindDotaHudElement(name);

	if (name == "CollectionCHC") {
		if (!panel.BHasClass("Loaded")) return;
		if (IsDemoMode()) return;

		if (glowSchelude != null) {
			$.CancelScheduled(glowSchelude);
			glowSchelude = undefined;
		}
		const glowPanel = FindDotaHudElement("DonateFocus");
		glowPanel.SetHasClass("show", boostGlow);
		if (boostGlow)
			glowSchelude = $.Schedule(4, () => {
				glowSchelude = undefined;
				glowPanel.SetHasClass("show", false);
			});
	}

	if (!panel.BHasClass("show")) {
		// fire DropInputFocus to prevent onblur event on previous opened menu after SetFocus
		$.DispatchEvent("DropInputFocus");
		panel.SetFocus();
	}

	panel.ToggleClass("show");

	if (!panel.BHasClass("show")) {
		$.DispatchEvent("DropInputFocus");
	}

	CENTER_SCREEN_MENUS.forEach((panelName) => {
		if (panelName != name) FindDotaHudElement(panelName).SetHasClass("show", false);
	});
}

function CloseAllMenus() {
	//$.Msg("CloseAllMenus")
	CENTER_SCREEN_MENUS.forEach((panelName) => {
		const panel = FindDotaHudElement(panelName);

		if (panel) {
			const open = panel.BHasClass("show");
			panel.SetHasClass("show", false);
			if (open && panel.OnCloseWindow) panel.OnCloseWindow();
		}
	});
	$.DispatchEvent("DropInputFocus");
}

const cosmeticAbilities = {
	high_five_custom: true,
	seasonal_ti9_banner: true,
	seasonal_summon_cny_balloon: true,
	seasonal_summon_dragon: true,
	seasonal_summon_cny_tree: true,
	seasonal_firecrackers: true,
	seasonal_ti9_shovel: true,
	seasonal_ti9_instruments: true,
	seasonal_ti9_monkey: true,
	seasonal_summon_ti9_balloon: true,
	seasonal_throw_snowball: true,
	seasonal_festive_firework: true,
	seasonal_decorate_tree: true,
	seasonal_summon_snowman: true,
	default_cosmetic_ability: true,
	spray_custom: true,
};

function GetHEXPlayerColor(playerId) {
	var playerColor = Players.GetPlayerColor(playerId).toString(16);
	return playerColor == null
		? "#000000"
		: "#" +
				playerColor.substring(6, 8) +
				playerColor.substring(4, 6) +
				playerColor.substring(2, 4) +
				playerColor.substring(0, 2);
}

const DOTA_SHOP = FindDotaHudElement("shop");

function DeleteAsyncSafe(panel, delay) {
	if (panel && panel.IsValid()) panel.DeleteAsync(delay);
}

function UpdateAbilityTooltip(abilityPanel, ability, abilityName) {
	abilityPanel.abilityname = abilityName;
	if (ability) abilityPanel.contextEntityIndex = ability;
	abilityPanel.SetPanelEvent("onmouseover", function () {
		$.DispatchEvent("DOTAShowAbilityTooltip", abilityPanel, abilityName);
	});
	abilityPanel.SetPanelEvent("onmouseout", function () {
		$.DispatchEvent("DOTAHideAbilityTooltip");
	});
}

function GetModifierStackCount(unit_index, m_name) {
	for (var i = 0; i < Entities.GetNumBuffs(unit_index); i++) {
		var buff_name = Buffs.GetName(unit_index, Entities.GetBuff(unit_index, i));
		if (buff_name == m_name) {
			return Buffs.GetStackCount(unit_index, Entities.GetBuff(unit_index, i));
		}
	}
}

function AbilityShowFilter(ability) {
	const ability_name = Abilities.GetAbilityName(ability);

	if (cosmeticAbilities[ability_name]) return false;
	if (ability_name == null) return false;
	if (ability_name == "") return false;
	if (ability_name == "generic_hidden") return false;
	if (ability_name.substring(0, 14) == "special_bonus_") return false;
	if (Abilities.IsHidden(ability)) return false;

	if (CustomNetTables.GetTableValue("additional_abilities", ability_name) != undefined) return false;
	if (CustomNetTables.GetTableValue("agh_shard_scepter_abilities", ability_name) != undefined) return false;

	return true;
}

function GetPortraitImage(player_id, hero_name) {
	const unique_portraits = CustomNetTables.GetTableValue("game", "portraits");
	if (unique_portraits && unique_portraits[player_id]) {
		return `file://{images}/heroes/${unique_portraits[player_id]}.png`;
	} else {
		return `file://{images}/heroes/${hero_name}.png`;
	}
}

function ParseBigNumber(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function LocalizeWithValues(line, kv) {
	let result = $.Localize(line);
	Object.entries(kv).forEach(([k, v]) => {
		result = result.replace(`%%${k}%%`, v);
	});
	return result;
}

function FindModifier(entity_index, buff_name) {
	for (let i = 0; i < Entities.GetNumBuffs(entity_index); i++) {
		const buff = Entities.GetBuff(entity_index, i);
		if (Buffs.GetName(entity_index, buff) == buff_name) {
			return buff;
		}
	}
	return -1;
}

if (!$.LocalizeEngine) {
	$.LocalizeEngine = $.Localize;
	$.Localize = function (text, panel) {
		const token = text.startsWith("#") ? text : "#" + text;
		const localized_text = panel ? $.LocalizeEngine(token, panel) : $.LocalizeEngine(token);
		return localized_text == token ? text : localized_text;
	};
}

JSON.print = (object) => {
	let result_string;
	try {
		result_string = JSON.stringify(
			object,
			(key, value) => {
				return value;
			},
			"	",
		);
	} catch (e) {
		$.Msg(e);
	}
	let result_array = result_string.split("\n");
	while (result_array.length) {
		$.Msg(result_array.splice(0, 50).join("\n"));
	}
};

function RemapVal(v, a, b, c, d) {
	if (a == b) {
		return v >= b ? d : c;
	}

	return c + ((d - c) * (v - a)) / (b - a);
}

function LocalizeTime(token, date, military_time) {
	const hours = date.getHours();

	return LocalizeWithValues("tournament_date", {
		t_day_name: $.Localize(`UI_day_${date.getDay() + 1}`),
		t_month: $.Localize(`UI_month_${date.getMonth()}`),
		t_day: date.getDate(),
		t_year: date.getFullYear(),
		t_hour: `0${military_time ? hours : hours > 12 ? hours - 12 : hours}`.slice(-2),
		t_min: `0${date.getMinutes()}`.slice(-2),
		ampm: military_time ? "" : hours >= 12 ? "PM" : "AM",
	});
}

Entities.HasShard = function (unit) {
	return HasModifierByName(unit, "modifier_item_aghanims_shard");
};
