item_gems_3 = class({})

function item_gems_3:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_gems_3:OnSpellStart()
	if IsServer() then
		if not GameRules:IsCheatMode() then
			if self:GetCaster():IsRealHero() then
					self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
					local pid = self:GetCaster():GetPlayerID()
					CustomShop:AddGems(pid, { [3] = RandomInt(40,80) }, false)
				UTIL_Remove(self)	
			end
		end
	end
end 