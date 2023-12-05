if _G.MultiplierManager == nil then
    _G.MultiplierManager = class({})
end

function MultiplierManager:init()
    self.talent_experience = {}
    self.talent_experience_list = {}
    self.currency_rp = {}
    self.currency_rp_list = {}
    for i = 0, 4 do
        self.talent_experience[i] = 1
        self.talent_experience_list[i] = {}
        self.currency_rp[i] = 1
        self.currency_rp_list[i] = {}
    end
end

function MultiplierManager:SetPlayerData(pid, items)
    self:CalculateFinalRpMultiplier(pid)
    self:UpdateExperienceMultiplier(pid)
    for _, value in pairs(items) do
        if value.name == "booster_experience" then
            print("booster_experience",value.value)
            self:InsertTalentExperienceList(pid, {
                multiplier = value.value,
                remaining_games_count = value.remaining_games_count,
            })
        end
        if value.name == "booster_rp" then
            print("booster_rp",value.value)
            self:InsertCurrencyRpList(pid, {
                multiplier = value.value,
                remaining_games_count = value.remaining_games_count,
            })
        end
    end
    DeepPrintTable(items)
    self:UpdateRpMultiplier(pid)
    self:UpdateExperienceMultiplier(pid)
end
function MultiplierManager:InsertTalentExperienceList(pid, value)
    table.insert(self.talent_experience_list[pid],value)
    self:CalculateFinalExperienceMultiplier(pid)
end
function MultiplierManager:InsertCurrencyRpList(pid, value)
    table.insert(self.currency_rp_list[pid],value)
    self:CalculateFinalRpMultiplier(pid)
end
function MultiplierManager:GetCurrencyRpMultiplier(pid)
    return self.currency_rp[pid]
end
function MultiplierManager:GetTalentExperienceMultiplier(pid)
    return self.talent_experience[pid]
end
function MultiplierManager:CalculateFinalExperienceMultiplier(pid)
    local multiplier = 1
    for _, value in pairs(self.talent_experience_list[pid]) do
        multiplier = multiplier + (value.multiplier-1)
    end
    self.talent_experience[pid] = multiplier
    self:UpdateExperienceMultiplier(pid)
end
function MultiplierManager:UpdateExperienceMultiplier(pid)
    local GameInfo = CustomNetTables:GetTableValue("GameInfo", tostring(pid))
    local data = {
        multiplier = self.talent_experience[pid],
        list = self.talent_experience_list[pid],
    }
    GameInfo["talent_multiplier"] = data
    CustomNetTables:SetTableValue("GameInfo", tostring(pid), GameInfo)
end
function MultiplierManager:CalculateFinalRpMultiplier(pid)
    local multiplier = 1
    for _, value in pairs(self.currency_rp_list[pid]) do
        multiplier = multiplier + (value.multiplier-1)
    end
    self.currency_rp[pid] = multiplier
    self:UpdateRpMultiplier(pid)
end
function MultiplierManager:UpdateRpMultiplier(pid)
    local GameInfo = CustomNetTables:GetTableValue("GameInfo", tostring(pid))
    local data = {
        multiplier = self.currency_rp[pid],
        list = self.currency_rp_list[pid],
    }
    GameInfo["rp_multiplier"] = data
    CustomNetTables:SetTableValue("GameInfo", tostring(pid), GameInfo)
end


MultiplierManager:init()