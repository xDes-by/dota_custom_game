item_gems_1 = class({})

function item_gems_1:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

function item_gems_1:OnSpellStart()
	if IsServer() then
		if not GameRules:IsCheatMode() then
			if self:GetCaster():IsRealHero() then
					self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
					local pid = self:GetCaster():GetPlayerID()
					CustomShop:AddGems(pid, { [1] = RandomInt(40,80) }, false )
				UTIL_Remove(self)	
			end
		end
	end
end 