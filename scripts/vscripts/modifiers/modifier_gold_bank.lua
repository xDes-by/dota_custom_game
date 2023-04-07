require("libraries/table")
modifier_gold_bank = class({})

function modifier_gold_bank:RemoveOnDeath()
    return false
end

function modifier_gold_bank:IsHidden()
    return false
    -- if self:GetStackCount() > 0 then 
    --     return false
    -- end
    -- return true
end

function modifier_gold_bank:GetTexture()
    return "alchemist_goblins_greed"
end

function modifier_gold_bank:OnCreated()
   if not IsServer() then return end

    --    local parent = self:GetParent()

    --    local player = PlayerResource:GetPlayer(parent:GetPlayerID()):GetAssignedHero()

    --    self.accountID = PlayerResource:GetSteamAccountID(player:GetPlayerID())

    --    if _G.PlayerGoldBank[self.accountID] == nil then return end
   
   self:StartIntervalThink(0.1)
end

function modifier_gold_bank:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_gold_bank:OnTooltip()
    return self:GetStackCount()
end

function modifier_gold_bank:OnIntervalThink()
    -- print("modifier_gold_bank")
    -- local parent = self:GetParent()
    -- local player = PlayerResource:GetPlayer(parent:GetPlayerID()):GetAssignedHero()

    -- if player:GetGold() < 99999 then
    --     local takeFromBank = 99999 - player:GetGold()

    --     if _G.PlayerGoldBank[self.accountID] < takeFromBank then
    --         takeFromBank = _G.PlayerGoldBank[self.accountID]
    --     end

    --     if takeFromBank < 0 then return end

    --     _G.PlayerGoldBank[self.accountID] = _G.PlayerGoldBank[self.accountID] - takeFromBank
    --     player:ModifyGold(takeFromBank, false, 98)

    --     CustomNetTables:SetTableValue("modify_gold_bank", "game_info", { 
    --       userEntIndex = player:GetEntityIndex(),
    --       amount = _G.PlayerGoldBank[self.accountID],
    --       r = RandomInt(1, 999), 
    --       z = RandomInt(1, 999)
    --     })

    --     --CustomGameEventManager:Send_ServerToPlayer(parent, "modify_gold_bank", {
    --     --    amount = _G.PlayerGoldBank[self.accountID]
    --     --})
    -- end
end