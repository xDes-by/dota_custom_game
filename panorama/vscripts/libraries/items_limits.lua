local maximumItemsForPlayersData = {}
-------------------------------------------------------------------------

function GetMaximumItemsForPlayer(itemName)
	local maximumItemsForPlayers = {}
	
	if PartyMode.infinite_paragon and PartyMode.infinite_paragon == true then
		maximumItemsForPlayers["item_upgrade_book"] = 7
	else
		maximumItemsForPlayers["item_upgrade_book"] = 1
	end
	
	return maximumItemsForPlayers[itemName]
end

-------------------------------------------------------------------------

function CDOTA_BaseNPC:IsMaxItemsForPlayer(item)
	local buyerEntIndex = self:GetEntityIndex()
	local itemName = item:GetAbilityName()
	local unique_key = itemName .. "_" .. buyerEntIndex
	local playerID = self:GetPlayerID()
	if not GetMaximumItemsForPlayer(itemName) or item.isTransfer then return true end

	local isPlayerBoughtMaxItems = item:CheckMaxItemsForPlayer(unique_key)

	if isPlayerBoughtMaxItems then
		maximumItemsForPlayersData[unique_key] = maximumItemsForPlayersData[unique_key] + 1
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "display_custom_error", { message = "you_cannot_buy_more_items_this_type" })
		return false
	end

	return true
end

-------------------------------------------------------------------------

function CDOTA_BaseNPC:RefundItem(item)
	self:ModifyGold(item:GetCost(), false, 0)
	UTIL_Remove(item)
end

-------------------------------------------------------------------------
function CDOTA_Item:CheckMaxItemsForPlayer(unique_key)
	if not GetMaximumItemsForPlayer(self:GetAbilityName()) then return true end
	if not maximumItemsForPlayersData[unique_key] then
		maximumItemsForPlayersData[unique_key] = 1
	end
	return maximumItemsForPlayersData[unique_key] <= GetMaximumItemsForPlayer(self:GetAbilityName())
end

-------------------------------------------------------------------------
