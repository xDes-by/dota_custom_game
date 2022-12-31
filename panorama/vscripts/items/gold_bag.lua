item_enfos_gold_bag = class({})
item_enfos_gold_bag_2 = item_enfos_gold_bag
item_enfos_gold_bag_3 = item_enfos_gold_bag
item_enfos_gold_bag_4 = item_enfos_gold_bag
item_enfos_gold_bag_5 = item_enfos_gold_bag
item_enfos_gold_bag_6 = item_enfos_gold_bag



function item_enfos_gold_bag:OnSpellStart()
	local team = self:GetCaster():GetTeam()
	local gold = self:GetSpecialValueFor("bonus_gold")
	local gold_tick = gold * 0.1

	for _, hero in pairs(Enfos:GetAllMainHeroes()) do
		if hero:GetTeam() == team then
			hero:EmitSound("General.CoinsBig")

			local ticks = 10
			local player_id = hero:GetPlayerID()

			Timers:CreateTimer(0, function()
				RoundManager:GiveGoldToPlayer(player_id, gold_tick, false, ROUND_MANAGER_GOLD_SOURCE_GIFTS)

				ticks = ticks - 1
				if ticks > 0 then
					return 0.25
				end
			end)
		end
	end

	self:Destroy()
end
