item_points_30 = class({})

function item_points_30:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_points_30:OnSpellStart()
	if IsServer() then
		if self:GetCaster():IsRealHero() then
			self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:IsValidPlayer(nPlayerID) then		
				pid = nPlayerID
					local player = PlayerResource:GetSelectedHeroEntity(pid )
					if not player:HasModifier("modifier_silent2") then
						CustomShop:AddRP(pid, 30, true, not DataBase:IsCheatMode())
						UTIL_Remove(self)
					end
				end
			end
		end
	end
end