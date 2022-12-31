Filters = Filters or {}

require("game/filters/damage")
require("game/filters/modifier")
require("game/filters/order")
require("game/filters/item")

function Filters:Init()
	local game_mode_entity = GameRules:GetGameModeEntity()

	self.aghsPreventPlayers = {} --stores the information for each player if they had the error msg displayed
	self.sequenceNumberConst = {} --stores sequence numbers for scepter components
	self.scepterComponentsHandles = {}	--stores item handles which will be refunded for scepter components

	game_mode_entity:SetModifierGainedFilter(Dynamic_Wrap(Filters, "ModifierFilter"), Filters)
	game_mode_entity:SetDamageFilter(Dynamic_Wrap(Filters, "DamageFilter"), Filters)
	game_mode_entity:SetModifyGoldFilter(Dynamic_Wrap(Filters, "ModifyGoldFilter"), Filters)
	game_mode_entity:SetExecuteOrderFilter(Dynamic_Wrap(Filters, "ExecuteOrderFilter"), Filters)
	game_mode_entity:SetItemAddedToInventoryFilter(Dynamic_Wrap(Filters, "ItemAddedToInventoryFilter"), Filters)
end

function Filters:ModifyGoldFilter(event)
	Timers:CreateTimer(GameRules:GetGameFrameTime(), function()
		GameMode:UpdatePlayerGold(event.player_id_const)
	end)
	return true
end
