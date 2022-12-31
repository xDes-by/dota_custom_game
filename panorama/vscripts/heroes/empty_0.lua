empty_0 = class({})

function empty_0:OnItemEquipped(item)
	-- Prevent items from being sold for full price if they're in the players main inventory during a round
	Timers:CreateTimer(0, function()
		if not IsValidEntity(item) then return end
		if not self:GetCaster():IsAlive() then return end

		local slot = item:GetItemSlot()
		local current_time = GameRules:GetGameTime()

		if GameMode:IsTeamFighting(self:GetTeam()) and slot <= 5 and current_time - item:GetPurchaseTime() < 10 then
			item:SetPurchaseTime(current_time - 10)
		end
	end)
end