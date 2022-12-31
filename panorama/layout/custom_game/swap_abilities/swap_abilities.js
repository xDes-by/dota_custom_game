const PROPOSAL_CONTAINER = $("#swap_proposal_container");
const SWAP_BUTTON = $("#submit_button");

let selection_pair = {
	own: null,
	other: null,
};

const ABILITY_SWAP_COOLDOWN = 10;
const UNSWAPPABLE_ABILITIES = {
	lone_druid_spirit_bear: true,
};

let player_abilities = {};
let ability_lists = {};
let player_panels = {};
let blocked_combinations = {};

const disabled_swap_request = {};

const locked_abilities = new Map();

function _SendErrorMessage(message) {
	GameEvents.SendEventClientSide("dota_hud_error_message", {
		splitscreenplayer: 0,
		reason: 80,
		message: message,
	});
}

function _ShowTooltip(panel, abilityName, index) {
	return () => {
		if (panel.GetParent().GetParent().BHasClass("SameAbilityLocked")) {
			return;
		}
		if (panel.BHasClass("SwapDisallowed")) {
			$.DispatchEvent("DOTAShowTextTooltip", panel, $.Localize("#swap_disallowed"));
		} else {
			$.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", panel, abilityName, index);
		}
	};
}

function _HideTooltip(panel) {
	return () => {
		$.DispatchEvent("DOTAHideTextTooltip");
		$.DispatchEvent("DOTAHideAbilityTooltip");
	};
}

function HasAnyOfComboPair(player_id, combo_pair) {
	for (let key in combo_pair) {
		let value = combo_pair[key];
		// if player has blocked ability
		if (player_abilities[player_id] && player_abilities[player_id][value]) {
			return true;
		}
	}
	return false;
}

function CheckBlockedCombinations(local, player_id, selected_name) {
	let blocked_selected = blocked_combinations[selected_name];
	let selection;
	if (local) {
		selection = selection_pair.other;
	} else {
		selection = selection_pair.own;
	}
	if (!selection) {
		return false;
	}
	let index = parseInt(selection.id.split("_")[1]);
	let selection_name = selection.GetChild(0).abilityname;

	let player_owner_id = Entities.GetPlayerOwnerID(Abilities.GetCaster(index));
	if (HasAnyOfComboPair(player_owner_id, blocked_selected)) {
		if (Object.values(blocked_selected).includes(selection_name)) {
			return false;
		}
		return true;
	}
	blocked_selected = blocked_combinations[selection_name];
	if (HasAnyOfComboPair(player_id, blocked_selected)) {
		if (Object.values(blocked_selected).includes(selected_name)) {
			return false;
		}
		return true;
	}
}

function _SelectAbility(ability_panel, player_id) {
	return () => {
		let own_player_id = "player_" + LOCAL_PLAYER_ID;
		let abilities_container = ability_panel.GetParent();
		let player_container = abilities_container.GetParent();
		let player_container_id = player_container.id;
		let local = player_id != LOCAL_PLAYER_ID;

		if (ability_panel.BHasClass("Locked")) {
			_SendErrorMessage("#swap_locked");
			return;
		}
		if (ability_panel.BHasClass("SwapDisallowed")) {
			_SendErrorMessage("#swap_disallowed");
			return;
		}
		if (ability_panel.GetParent().GetParent().BHasClass("SelectingAbility")) {
			_SendErrorMessage("#selecting_ability");
			return;
		}
		if (player_container.BHasClass("SameAbilityLocked")) {
			_SendErrorMessage("#player_has_this_ability");
			return;
		}
		let ability_name = ability_panel.GetChild(0).abilityname;
		if (local) {
			if (player_abilities[LOCAL_PLAYER_ID][ability_name]) {
				_SendErrorMessage("#already_have_this_ability");
				return;
			}
		}
		// blocked_combinations
		if (CheckBlockedCombinations(!local, player_id, ability_name)) {
			_SendErrorMessage("#locked_combination");
			return;
		}

		for (var other_player_id in player_abilities) {
			if (other_player_id == player_id) continue;

			if (player_abilities[other_player_id] && player_panels[other_player_id]) {
				let player_panel = player_panels[other_player_id];
				let lock_state = Boolean(player_abilities[other_player_id][ability_name]);
				player_panel.SetHasClass("SameAbilityLocked", lock_state);
				// reset selection only if selected ability belongs to this player
				if (
					lock_state &&
					selection_pair.other &&
					selection_pair.other.GetParent().GetParent().id == "player_" + other_player_id
				) {
					selection_pair.other.SetHasClass("Selected", false);
					selection_pair.other = null;
				}
			}
		}

		if (!player_container_id.includes("player")) return;

		if (own_player_id == player_container_id) {
			if (selection_pair.own) {
				selection_pair.own.SetHasClass("Selected", false);
			}
			selection_pair.own = ability_panel;
			selection_pair.own.SetHasClass("Selected", true);
		} else {
			if (selection_pair.other) {
				selection_pair.other.SetHasClass("Selected", false);
			}
			selection_pair.other = ability_panel;
			selection_pair.other.SetHasClass("Selected", true);
		}
		Game.EmitSound("ui_learn_select");
	};
}

function accept_swap(data, panel) {
	return () => {
		Game.EmitSound("General.ButtonClick");
		if (panel.BHasClass("RemovingSwap")) return;
		panel.DeleteAsync(0.5);
		panel.SetHasClass("RemovingSwap", true);
		GameEvents.SendCustomGameEventToServer("swap_abilities:accepted", data);
	};
}

function decline_swap(data, panel) {
	return () => {
		Game.EmitSound("General.ButtonClickRelease");
		if (panel.BHasClass("RemovingSwap")) return;
		panel.DeleteAsync(0.5);
		panel.SetHasClass("RemovingSwap", true);
		GameEvents.SendCustomGameEventToServer("swap_abilities:declined", data);
	};
}

function _BindEvents(ability_panel, ability_name, index, player_id) {
	ability_panel.SetPanelEvent("onmouseover", _ShowTooltip(ability_panel, ability_name, index));
	ability_panel.SetPanelEvent("onmouseout", _HideTooltip(ability_panel));
	ability_panel.SetPanelEvent("onactivate", _SelectAbility(ability_panel, player_id));
}

function _BindPlayerPanelEvents(panel) {
	panel.SetPanelEvent("onmouseover", () => {
		if (panel.BHasClass("SameAbilityLocked")) {
			$.DispatchEvent("DOTAShowTextTooltip", panel, $.Localize("#player_has_this_ability"));
		}
		if (panel.BHasClass("SelectingAbility")) {
			$.DispatchEvent("DOTAShowTextTooltip", panel, $.Localize("#selecting_ability"));
		}
	});
	panel.SetPanelEvent("onmouseout", () => {
		$.DispatchEvent("DOTAHideTextTooltip");
	});
}

function _CheckDeletedPanel(panel, player_id) {
	if (selection_pair.own && selection_pair.own === panel) {
		selection_pair.own.SetHasClass("Selected", false);
		selection_pair.own = null;
	}

	if (selection_pair.other && selection_pair.other === panel) {
		selection_pair.other.SetHasClass("Selected", false);
		selection_pair.other = null;
	}
	let ability_index = panel.GetChild(0).contextEntityIndex;
	if (!ability_index) {
		return;
	}
	let ability_name = Abilities.GetAbilityName(ability_index);
	if (!ability_name) {
		return;
	}
	if (player_abilities[player_id][ability_name]) {
		player_abilities[player_id][ability_name] = null;
	}
}

function _MakeAbilityPanel(container, ability_name, ability_entindex) {
	ability_panel = $.CreatePanel("Panel", container, ability_name);
	ability_panel.BLoadLayoutSnippet("ability_container");
	ability_panel.SetHasClass("passive_ability", Abilities.IsPassive(ability_entindex));

	return ability_panel;
}

function _InitPlayerAbilities(player_panel, hero_entindex, player_id) {
	let container = player_panel.GetChild(2);
	player_abilities[player_id] = {};
	if (!ability_lists[player_id]) return;
	let last_index = 0;
	$.Each(ability_lists[player_id], (ability_name, index) => {
		let ability_entindex = Entities.GetAbilityByName(hero_entindex, ability_name);
		if (ability_entindex == -1) return;
		let ability_panel = container.GetChild(index - 1);
		if (!ability_panel) ability_panel = _MakeAbilityPanel(container, ability_name, ability_entindex);

		let ability_image = ability_panel.GetChild(0);
		ability_image.abilityname = ability_name;
		ability_image.contextEntityIndex = ability_entindex;
		_BindEvents(ability_panel, ability_name, hero_entindex, player_id);

		ability_panel.ability_entindex = ability_entindex;
		ability_panel.visible = true;
		ability_panel.SetHasClass("SwapDisallowed", UNSWAPPABLE_ABILITIES[ability_name] === true);
		player_abilities[player_id][ability_name] = ability_panel;

		if (locked_abilities.has(ability_entindex)) {
			LockAbilities(locked_abilities.get(ability_entindex));
		} else {
			ability_panel.RemoveClass("Locked");
		}

		last_index = index;
	});
	// hide unused panels
	const children = container.Children();
	for (let i = last_index; i < children.length; i++) {
		children[i].visible = false;
	}
}

function _InitPlayers() {
	let container = $("#page_swap_players");
	let teamId = Players.GetTeam(Game.GetLocalPlayerID());
	let teamPlayers = Game.GetPlayerIDsOnTeam(teamId);

	teamPlayers.forEach((player_id) => {
		let player_info = Game.GetPlayerInfo(player_id);
		let hero_entindex = Players.GetPlayerHeroEntityIndex(player_id);
		let steamid = player_info.player_steamid;

		let panel_id = "player_" + player_id;
		let player_panel = $("#" + panel_id);

		if (!player_panel) {
			player_panel = $.CreatePanel("Panel", container, panel_id);
			player_panel.BLoadLayoutSnippet("player_container");

			const disable_incoming_button = player_panel.FindChildTraverse("disable_incoming_swap_requests");
			if (player_id == Game.GetLocalPlayerID()) {
				disable_incoming_button.visible = false;
			} else {
				disable_incoming_button.SetPanelEvent("onactivate", () =>
					ToggleIncomingSwapRequests(player_id, disable_incoming_button.checked),
				);
			}
		}

		player_panel.GetChild(0).heroname = Entities.GetUnitName(hero_entindex);
		player_panel.GetChild(1).steamid = steamid;
		player_panel.player_id = player_id;
		player_panels[player_id] = player_panel;

		_BindPlayerPanelEvents(player_panel);
		_InitPlayerAbilities(player_panel, hero_entindex, player_id);
	});
}

function _UpdateTimer(panel, parent) {
	if (!panel) return;

	if (parent.BHasClass("RemovingSwap")) return;

	panel.value -= 0.4;
	if (panel.value <= 0.0) {
		Game.EmitSound("General.ButtonClickRelease");
		parent.DeleteAsync(0.5);
		parent.SetHasClass("RemovingSwap", true);
		return;
	}
	$.Schedule(0.4, function () {
		_UpdateTimer(panel, parent);
	});
}

function ToggleSwap() {
	let panel = $("#page_swap");
	panel.ToggleClass("Show");

	if (panel.BHasClass("Show")) return;

	if (selection_pair.own) {
		selection_pair.own.SetHasClass("Selected", false);
		selection_pair.own = null;
	}
	if (selection_pair.other) {
		selection_pair.other.SetHasClass("Selected", false);
		selection_pair.other = null;
	}

	Game.EmitSound("ui_custom_lobby_drawer_slide_out");
	FillAbilities();
}

function FillAbilities() {
	GameEvents.SendCustomGameEventToServer("swap_abilities:request_ability_lists", {});
}

function ReloadSwapPanel() {
	if (selection_pair.own) {
		selection_pair.own.SetHasClass("Selected", false);
		selection_pair.own = null;
	}
	if (selection_pair.other) {
		selection_pair.other.SetHasClass("Selected", false);
		selection_pair.other = null;
	}
	FillAbilities();
}

function ProposeSwap() {
	if (SWAP_BUTTON.BHasClass("SwapCooldown")) return;
	if (!selection_pair.own || !selection_pair.other) return;

	let own_ability_index = parseInt(selection_pair.own.ability_entindex);
	let other_ability_index = parseInt(selection_pair.other.ability_entindex);

	GameEvents.SendCustomGameEventToServer("swap_abilities:request_swap", {
		own: own_ability_index,
		other: other_ability_index,
	});

	selection_pair.own.SetHasClass("Selected", false);
	selection_pair.other.SetHasClass("Selected", false);

	selection_pair.own = null;
	selection_pair.other = null;

	SWAP_BUTTON.SetHasClass("SwapCooldown", true);

	$.Schedule(ABILITY_SWAP_COOLDOWN, () => {
		SWAP_BUTTON.SetHasClass("SwapCooldown", false);
	});
}

function SwapProposed(data) {
	let proposer = Abilities.GetCaster(data.own);
	let receiver = Abilities.GetCaster(data.other);

	if (Entities.GetAbilityByName(proposer, Abilities.GetAbilityName(data.own)) == -1) return;
	if (Entities.GetAbilityByName(receiver, Abilities.GetAbilityName(data.other)) == -1) return;

	let proposer_id = Entities.GetPlayerOwnerID(proposer);
	let receiver_id = Entities.GetPlayerOwnerID(receiver);

	let proposer_game_info = Game.GetPlayerInfo(proposer_id);

	if (disabled_swap_request[proposer_id]) {
		GameEvents.SendCustomGameEventToServer("swap_abilities:declined", data);

		const player_color = GetHEXPlayerColor(proposer_id);
		const player_name = ` <font color='${player_color}'>${proposer_game_info.player_name}</font>`;
		GameUI.CreateCustomMessage({ PlayerID: -1, textData: $.Localize("#auto_decline_chat_message") + player_name });

		return;
	}

	let panel_id = "swap_proposal_" + data.own + "_" + data.other;
	swap_panel = $.CreatePanel("Panel", PROPOSAL_CONTAINER, panel_id);
	swap_panel.BLoadLayoutSnippet("proposal_container");

	swap_panel.GetChild(1).steamid = proposer_game_info.player_steamid;

	let abilities_container = swap_panel.GetChild(2);

	let first_ability = abilities_container.GetChild(0);
	let ability_name = Abilities.GetAbilityName(data.own);
	first_ability.BLoadLayoutSnippet("ability_container");
	first_ability.GetChild(0).abilityname = ability_name;
	first_ability.GetChild(1).heroname = Entities.GetUnitName(proposer);
	first_ability.SetHasClass("caster_showcase", true);
	_BindEvents(first_ability, ability_name, proposer, proposer_id);

	let second_ability = abilities_container.GetChild(2);
	ability_name = Abilities.GetAbilityName(data.other);
	second_ability.BLoadLayoutSnippet("ability_container");
	second_ability.GetChild(0).abilityname = Abilities.GetAbilityName(data.other);
	second_ability.GetChild(1).heroname = Entities.GetUnitName(receiver);
	second_ability.SetHasClass("caster_showcase", true);
	_BindEvents(second_ability, ability_name, receiver, receiver_id);

	let accept_button = swap_panel.GetChild(3);
	let decline_button = swap_panel.GetChild(4);

	accept_button.SetPanelEvent("onactivate", accept_swap(data, swap_panel));
	decline_button.SetPanelEvent("onactivate", decline_swap(data, swap_panel));

	_UpdateTimer(swap_panel.GetChild(5), swap_panel);

	Game.EmitSound("swap_popup_sound");
}

function SetAbilities(data) {
	ability_lists = data;
	_InitPlayers();
}

function LockAbilities(event) {
	$.Msg("Lock ", event);
	const own_caster = Abilities.GetCaster(event.own);
	const other_caster = Abilities.GetCaster(event.other);

	locked_abilities.set(event.own, event);
	locked_abilities.set(event.other, event);

	const own = player_abilities[Entities.GetPlayerOwnerID(own_caster)][Abilities.GetAbilityName(event.own)];
	const other = player_abilities[Entities.GetPlayerOwnerID(other_caster)][Abilities.GetAbilityName(event.other)];

	if (!own || !other) return;

	own.SetHasClass("Locked", true);
	other.SetHasClass("Locked", true);

	own.GetChild(1).heroname = Entities.GetUnitName(own_caster);
	own.GetChild(2).heroname = Entities.GetUnitName(other_caster);

	other.GetChild(1).heroname = Entities.GetUnitName(own_caster);
	other.GetChild(2).heroname = Entities.GetUnitName(other_caster);
}

function UnlockAbilities(event) {
	$.Msg("Unlock ", event);
	const own_player_id = Entities.GetPlayerOwnerID(Abilities.GetCaster(event.own));
	const other_player_id = Entities.GetPlayerOwnerID(Abilities.GetCaster(event.other));

	locked_abilities.delete(event.own);
	locked_abilities.delete(event.other);

	let panel = player_abilities[own_player_id][Abilities.GetAbilityName(event.own)];
	if (panel) panel.SetHasClass("Locked", false);

	panel = player_abilities[other_player_id][Abilities.GetAbilityName(event.other)];
	if (panel) panel.SetHasClass("Locked", false);

	if (event.accepted) {
		$.Each(event.update_abilities, (abilities, player_id) => {
			ability_lists[player_id] = abilities;
		});

		_InitPlayers();
	} else {
		SWAP_BUTTON.SetHasClass("SwapCooldown", false);
	}
}

function SetBlockedAbilities(data) {
	blocked_combinations = data;
}

function SetPlayerState(data) {
	if (!data || data.player_id == undefined) return;

	let player_panel = $("#player_" + data.player_id);
	if (!player_panel) return;

	player_panel.SetHasClass("SelectingAbility", Boolean(data.state));
}

function ToggleIncomingSwapRequests(player_id, state) {
	disabled_swap_request[player_id] = state;
}

(function () {
	let map_info = Game.GetMapInfo();
	if (map_info.map_name == "maps/demo.vpk" || map_info.map_name == "maps/ffa.vpk") {
		PROPOSAL_CONTAINER.DeleteAsync(0);
		return;
	} else {
		GameUI.RegisterKeybind("SwapButton", "F7", ToggleSwap);
	}

	$.GetContextPanel().AddClass(map_info.map_display_name);

	const frame = GameEvents.NewProtectedFrame($.GetContextPanel());
	frame.SubscribeProtected("RefreshAbilityOrder", FillAbilities);
	frame.SubscribeProtected("swap_abilities:set_blocked", SetBlockedAbilities);
	frame.SubscribeProtected("swap_abilities:swap_proposed", SwapProposed);
	frame.SubscribeProtected("swap_abilities:lock_swapped", LockAbilities);
	frame.SubscribeProtected("swap_abilities:unlock_swapped", UnlockAbilities);
	frame.SubscribeProtected("swap_abilities:set_selecting_abilities", SetPlayerState);
	frame.SubscribeProtected("swap_abilities:set_abilities", SetAbilities);

	GameEvents.SendCustomGameEventToServer("swap_abilities:request_blocked", {});
	GameEvents.SendCustomGameEventToServer("swap_abilities:request_ability_lists", {});
})();
