item_points_big = class({})

function item_points_big:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_points_big:OnSpellStart()
	if IsServer() then
		if self:GetCaster():IsRealHero() then
			self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:IsValidPlayer(nPlayerID) then		
					local player = PlayerResource:GetSelectedHeroEntity(nPlayerID )
					if not player:HasModifier("modifier_silent2") then
						CustomShop:AddRP(nPlayerID, 25, true, not DataBase:IsCheatMode())
						UTIL_Remove(self)
					end
				end
			end
		end
	end
end