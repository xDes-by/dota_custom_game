item_points_30 = class({})

function item_points_30:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_points_30:OnSpellStart()
	if IsServer() then
		if not GameRules:IsCheatMode() then
		if self:GetCaster():IsRealHero() then
				self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
				for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
					if PlayerResource:IsValidPlayer(nPlayerID) then		
					pid = nPlayerID
						local player = PlayerResource:GetSelectedHeroEntity(pid )
						if not player:HasModifier("modifier_silent2") then

						local shop = CustomNetTables:GetTableValue("shopinfo", tostring(pid ))
						shop["mmrpoints"] = tonumber(shop["mmrpoints"]) + 30
						Shop.pShop[tonumber(pid )]["mmrpoints"] = shop["mmrpoints"]
						CustomNetTables:SetTableValue("shopinfo", tostring(pid ), shop)				
						arr = { sid = PlayerResource:GetSteamAccountID( nPlayerID ), give = 30, }	
									local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/drop-item?key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) .. '&sid=' .. arr['sid'] )
									arr = json.encode(arr)
									req:SetHTTPRequestGetOrPostParameter('arr',arr)
									req:SetHTTPRequestAbsoluteTimeoutMS(100000)
									req:Send(function(res)
									if res.StatusCode == 200 then
									end
								end)
							UTIL_Remove(self)
						end
					end
				end
			end
		end
	end
end