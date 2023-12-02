item_crystal = class({})

function item_crystal:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_crystal:OnSpellStart()
	if self:GetCaster():IsRealHero() then
		self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:IsValidPlayer(nPlayerID) then		
				pid = nPlayerID
				local player = PlayerResource:GetSelectedHeroEntity(pid )
				if not player:HasModifier("modifier_silent2") then
					CustomShop:AddCoins(pid, 1, true, not DataBase:IsCheatMode())
					UTIL_Remove(self)
				end
			end
		end
	end
end 