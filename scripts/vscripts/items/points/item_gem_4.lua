item_gems_4 = class({})

function item_gems_4:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_gems_4:OnSpellStart()
	if IsServer() then
		if not GameRules:IsCheatMode() then
			if self:GetCaster():IsRealHero() then
					self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
					local pid = self:GetCaster():GetPlayerID()
						Smithy:add_gems({PlayerID = pid, type = 4, value = RandomInt(30,60)})
				UTIL_Remove(self)	
			end
		end
	end
end 