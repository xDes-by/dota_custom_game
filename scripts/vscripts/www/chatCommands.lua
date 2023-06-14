LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cheat_move", "modifiers/modifier_cheat_move", LUA_MODIFIER_MOTION_NONE )

if ChatCommands == nil then
    _G.ChatCommands = class({})
end

function ChatCommands:init()
    ListenToGameEvent("player_chat", Dynamic_Wrap( self, "OnChat" ), self )
end

function ChatCommands:IsAdmin(sid)
    local admins = {
        1062658804, 81459554, --Ваня
        393187346, -- Витя
        455872541, -- Я
        -- Тестері
        120578788, -- Dыnьka ;3
        111684601, --Андрей (deal with it)
        103583376, -- headmower1q
        351759722, 487111321,
    }
    return table.has_value(admins, sid)
end

function ChatCommands:SplitString(string)
    local result = {}
    for word in string.gmatch(string, "%S+") do
        table.insert(result, word)
    end
    return result
end

function ChatCommands:Font()
    return "<font color='#df2170'>"
end

function ChatCommands:OnChat(t)
    local text = t.text
    local pid = t.playerid
    local sid = PlayerResource:GetSteamAccountID(pid)
    if self:IsAdmin(sid) then
        self:ActivateGodMode(pid, text)
        self:DeactivateGodMode(pid, text)
        self:Gold(pid, text)
        self:LevelUp(pid, text)
        self:CreateUnit(pid, text)
        self:ForceKillUnits(pid, text)
        self:DropItems(pid, text)
        self:DropBooks(pid, text)
        self:DropBag(pid, text)
        self:TestTalents(pid, text)
        self:Effect(pid, text)
        self:GiveSouls(pid, text)
        self:Box(pid, text)
        
        Timers:CreateTimer(0.1 ,function()
            self:CreateInfo(text)
            self:Info(text)
        end)
    end
end

function ChatCommands:Info(text)
    if text ~= "-info" then return end
	self:ActivateGodMode(-1)
    self:DeactivateGodMode(-1)
    self:Effect(-1)
    self:Gold(-1)
    self:LevelUp(-1)
    self:GiveSouls(-1)
    self:Box(-1)
    self:CreateUnit(-1)
    self:ForceKillUnits(-1)
    self:DropItems(-1)
    self:DropBooks(-1)
    self:DropBag(-1)
    self:TestTalents(-1)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:ActivateGodMode(pid, text)
    local keyword = {"-god","a1","я гей"}
    if pid < 0 then
        self:ActivateGodModeMessage(keyword)
        return
    end
    if not table.has_value(keyword, text) then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    hero:SetBaseIntellect(hero:GetBaseIntellect() + 1000000)
    hero:SetBaseAgility(hero:GetBaseAgility() + 1000000)
    hero:SetBaseStrength(hero:GetBaseStrength() + 1000000)    
    hero:AddNewModifier( hero, nil, "modifier_cheat_move", {} )
    hero:AddNewModifier( hero, nil, "modifier_magic_immune", {} )
end

function ChatCommands:ActivateGodModeMessage(keyword)
    local message = self:Font()
    for i = 1, #keyword do
        message = message .. keyword[i]
        if i < #keyword then
            message = message .. " / "
        end
    end
    message = message .. "</font> Включить режима бога"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:DeactivateGodMode(pid, text)
    local keyword = {"--god","a2","я нормальный пидр"}
    if pid < 0 then
        self:DeactivateGodModeMessage(keyword)
        return
    end
    if not table.has_value(keyword, text) then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if hero:GetBaseIntellect() >= 1000000 and hero:GetBaseAgility() >= 1000000 and hero:GetBaseStrength() >= 1000000 then
        hero:SetBaseIntellect(hero:GetBaseIntellect() - 1000000)
        hero:SetBaseAgility(hero:GetBaseAgility() - 1000000)
        hero:SetBaseStrength(hero:GetBaseStrength() - 1000000)
        hero:RemoveModifierByName( "modifier_cheat_move" )
        hero:RemoveModifierByName( "modifier_magic_immune" )
    end
end

function ChatCommands:DeactivateGodModeMessage(keyword)
    local message = self:Font()
    for i = 1, #keyword do
        message = message .. keyword[i]
        if i < #keyword then
            message = message .. " / "
        end
    end
    message = message .. "</font> Отключить режима бога"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:Effect(pid, text)
    if pid < 0 then
        self:EffectMessage(keyword)
        return
    end
    local modifiers = {"modifier_cheat_move", "modifier_magic_immune"}
    local keyword = "-effect [move|immune] {игрок}"
    local split = self:SplitString(text)
    if split[1] ~= '-effect' then return end
    for _, m in pairs(modifiers) do
        modifier_name = m
        if string.find(modifier_name, split[2]) then
            break
        end
    end
    if not modifier_name then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if split[3] and tonumber(split[3]) and PlayerResource:IsValidPlayer(tonumber(split[3])) then
        hero = PlayerResource:GetSelectedHeroEntity(tonumber(split[3]))
    end
    if hero:HasModifier(modifier_name) then
        hero:RemoveModifierByName(modifier_name)
    else
        hero:AddNewModifier(hero, nil, modifier_name, {})
    end
end

function ChatCommands:EffectMessage(keyword)
    local message = self:Font() .. "</font> Добавть/Убрать єффект. Скорость, маг имун"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:Gold(pid, text)
    local keyword = {"-gold", "gold", "g"}
    if pid < 0 then
        self:GoldMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if not table.has_value(keyword, split[1]) then return end
    if split[1] == "-gold" and GameRules:IsCheatMode() then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if split[3] and tonumber(split[3]) and PlayerResource:IsValidPlayer(tonumber(split[3])) then
        hero = PlayerResource:GetSelectedHeroEntity(tonumber(split[3]))
    end
    if not split[2] or not tonumber(split[2]) then
        hero:ModifyGoldFiltered(2000000000, true, 0)
    else
        hero:ModifyGoldFiltered(tonumber(split[2]), true, 0)
    end
    
end

function ChatCommands:GoldMessage(keyword)
    local message = self:Font()
    for i = 1, #keyword do
        message = message .. keyword[i]
        if i < #keyword then
            message = message .. " / "
        end
    end
    message = message .. " {значение} {игрок}</font> Деньги. Некоторые значения можно не указывать"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:LevelUp(pid, text)
    local keyword = "-lvlup {значение} {игрок}"
    if pid < 0 then
        self:LevelUpMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if split[1] ~='-lvlup' then return end
    if GameRules:IsCheatMode() then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if split[3] and tonumber(split[3]) and PlayerResource:IsValidPlayer(tonumber(split[3])) then
        hero = PlayerResource:GetSelectedHeroEntity(tonumber(split[3]))
    end
    if not split[2] or not tonumber(split[2]) then return end
    for i = 1, tonumber(split[2]) do
        hero:HeroLevelUp(true)
    end
end

function ChatCommands:LevelUpMessage(keyword)
    local message = self:Font() .. keyword .. "</font> Повысить уровень"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:GiveSouls(pid, text)
    local keyword = {"-soul", "s"}
    if pid < 0 then
        self:GiveSoulsMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if not table.has_value(keyword, split[1]) then return end
    local give = function (PlayerID)
        for i = 1, 6 do
            sInv:AddSoul("item_forest_soul", PlayerID)
            sInv:AddSoul("item_village_soul", PlayerID)
            sInv:AddSoul("item_mines_soul", PlayerID)
            sInv:AddSoul("item_dust_soul", PlayerID)
            sInv:AddSoul("item_swamp_soul", PlayerID)
            sInv:AddSoul("item_snow_soul", PlayerID)
        end
    end
    if split[2] and tonumber(split[2]) and PlayerResource:IsValidPlayer(tonumber(split[2])) then
        give(tonumber(split[2]))
    else
        give(pid)
    end
end
function ChatCommands:GiveSoulsMessage(keyword)
    local message = self:Font()
    for i = 1, #keyword do
        message = message .. keyword[i]
        if i < #keyword then
            message = message .. " / "
        end
    end
    message = message .. " {игрок}</font> Выдать души"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:CreateUnit(pid, text)
    local keyword = "-createhero {название} [enemy]"
    if pid < 0 then
        self:CreateUnitMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if split[1] ~= "-createhero" then return end
    if split[2] == nil then return end
    if GameRules:IsCheatMode() then return end
    if self.callingUnits == nil then self.callingUnits = {} end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    for key,_ in pairs(LoadKeyValues("scripts/npc/npc_units_custom.txt")) do
        if string.find(key, split[2]) then
            local side = DOTA_TEAM_GOODGUYS
            if split[3] == "enemy" then
                side = DOTA_TEAM_BADGUYS
            end
            local unit = CreateUnitByName( key, hero:GetAbsOrigin(), true, nil, nil, side )
            unit:SetControllableByPlayer(pid, true)
            unit:SetOwner(hero)
            if diff_wave.wavedef == "Easy" then
                unit:AddNewModifier(unit, nil, "modifier_easy", {})
            end
            if diff_wave.wavedef == "Normal" then
                unit:AddNewModifier(unit, nil, "modifier_normal", {})
            end
            if diff_wave.wavedef == "Hard" then
                unit:AddNewModifier(unit, nil, "modifier_hard", {})
            end	
            if diff_wave.wavedef == "Ultra" then
                unit:AddNewModifier(unit, nil, "modifier_ultra", {})
            end	
            if diff_wave.wavedef == "Insane" then
                unit:AddNewModifier(unit, nil, "modifier_insane", {})
            end	
            table.insert(self.callingUnits, unit)
            break
        end
    end
end

function ChatCommands:CreateUnitMessage(keyword)
    local message = self:Font() .. keyword .. "</font> Создать юнита под вашим контролем. Для вывода имен боссов напиши " .. self:Font() .. "-createinfo</font>"
    GameRules:SendCustomMessage(message,0,0)
end

function ChatCommands:CreateInfo(text)
    if text ~= "-createinfo" then return end
    GameRules:SendCustomMessage(self:Font() .. "squirrel_copy" .. "</font> Белка"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "raid_boss" .. "</font> xDes"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "raid_boss2" .. "</font> Lufigan"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "raid_boss3" .. "</font> Dota_Boss"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "raid_boss4" .. "</font> Виверна(Глотаю кончу)",0,0)
    GameRules:SendCustomMessage(self:Font() .. "new_year" .. "</font> Апарат"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "forest_boss" .. "</font> Фурион"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "village_boss" .. "</font> Пудж"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "mines_boss" .. "</font> Земля"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "dust_boss" .. "</font> Никс"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "swamp_boss" .. "</font> Змея"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "snow_boss" .. "</font> Тини"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "boss_location8" .. "</font> Бабка"  ,0,0)
    GameRules:SendCustomMessage(self:Font() .. "boss_earthshaker" .. "</font> Шейкер"  ,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:ForceKillUnits(pid, text)
    local keyword = "-killall"
    if pid < 0 then
        self:ForceKillUnitsMessage(keyword)
        return
    end
    if text ~= keyword then return end
    for _, unit in pairs(self.callingUnits) do
        if unit then
            unit:ForceKill(true)
        end
    end
    self.callingUnits = {}
end
function ChatCommands:ForceKillUnitsMessage(keyword)
    local message = self:Font() .. keyword .. "</font> Убийство всех созданных юнитов"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:DropItems(pid, text)
    local keyword = {"-drop","geycock"}
    if pid < 0 then
        self:DropItemsMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if not table.has_value(keyword, split[1]) then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    local owner = hero
    if split[2] and split[2] == "public" then
        owner = nil
    end
    local heroPoint = hero:GetAbsOrigin()
    local itemsList = {
        {vector = Vector(heroPoint.x + 0, heroPoint.y + 275), name = "item_assault_lua8"},
        {vector = Vector(heroPoint.x + -50, heroPoint.y + 250), name = "item_sheepstick_lua8"},
        {vector = Vector(heroPoint.x + 50, heroPoint.y + 250), name = "item_satanic_lua8"},
        {vector = Vector(heroPoint.x + -75, heroPoint.y + 225), name = "item_ring_of_flux_lua8"},
        {vector = Vector(heroPoint.x + 75, heroPoint.y + 225), name = "item_bloodstone_lua8"},

        {vector = Vector(heroPoint.x + -100, heroPoint.y + -150), name = "item_radiance_lua8"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + -75), name = "item_desolator_lua8"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + 0), name = "item_butterfly_lua8"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + 75), name = "item_monkey_king_bar_lua8"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + 150), name = "item_bfury_lua8"},

        {vector = Vector(heroPoint.x + 100, heroPoint.y + -150), name = "item_veil_of_discord_lua8"},
        {vector = Vector(heroPoint.x + 100, heroPoint.y + -75), name = "item_shivas_guard_lua8"},
        {vector = Vector(heroPoint.x + 100, heroPoint.y + 0), name = "item_crimson_guard_lua8"},
        {vector = Vector(heroPoint.x + 100, heroPoint.y + 75), name = "item_heart_lua8"},
        {vector = Vector(heroPoint.x + 100, heroPoint.y + 150), name = "item_greater_crit_lua8"},

        {vector = Vector(heroPoint.x + -137, heroPoint.y + -210), name = "item_kaya_custom_lua8"},
        {vector = Vector(heroPoint.x + 137, heroPoint.y + -210), name = "item_ethereal_blade_lua8"},
        {vector = Vector(heroPoint.x + -160, heroPoint.y + -260), name = "item_vladmir_lua8"},
        {vector = Vector(heroPoint.x + 160, heroPoint.y + -260), name = "item_pipe_lua8"},
        {vector = Vector(heroPoint.x + -137, heroPoint.y + -312), name = "item_octarine_core_lua8"},
        {vector = Vector(heroPoint.x + 137, heroPoint.y + -312), name = "item_skadi_lua8"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + -335), name = "item_mjollnir_lua8"},
        {vector = Vector(heroPoint.x + 100, heroPoint.y + -335), name = "item_pudge_heart_lua8"},
        {vector = Vector(heroPoint.x + -62, heroPoint.y + -297), name = "item_mage_heart_lua8"},
        {vector = Vector(heroPoint.x + 62, heroPoint.y + -297), name = "item_agility_heart_lua8"},
        {vector = Vector(heroPoint.x + -25, heroPoint.y + -260), name = "item_moon_shard_lua8"},
        {vector = Vector(heroPoint.x + 25, heroPoint.y + -260), name = "item_hood_sword_lua8"},
    }

    for _, item in pairs(itemsList) do
        local newItem = CreateItem( item.name, owner, owner )
        local drop = CreateItemOnPositionForLaunch( heroPoint, newItem )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, item.vector )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
    end
end
function ChatCommands:DropItemsMessage(keyword)
    local message = self:Font()
    for i = 1, #keyword do
        message = message .. keyword[i]
        if i < #keyword then
            message = message .. " / "
        end
    end
    message = message .. " [public]</font> Получить предметы последнего уровня"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:DropBooks(pid, text)
    local keyword = "-books"
    if pid < 0 then
        self:DropBooksMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if keyword ~= split[1] then return end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    local owner = hero
    if split[2] and split[2] == "public" then
        owner = nil
    end
    spawnPoint = hero:GetAbsOrigin()
    for _,item_name in pairs({"item_greed_agi","item_greed_int","item_greed_str"}) do
        local newItem = CreateItem( item_name, owner, owner )
        newItem:SetCurrentCharges(1000)
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        local dropRadius = RandomFloat( 50, 100 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
    end
end
function ChatCommands:DropBooksMessage(keyword)
    local message = self:Font() .. keyword .. " [public]</font> Получить книги атрибутов"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:DropBag(pid, text)
    local keyword = "-bags"
    if pid < 0 then
        self:DropBagMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if keyword ~= split[1] then return end
    if split[2] == nil or not tonumber(split[2]) then return end
    local count = tonumber(split[2])
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if split[4] and tonumber(split[4]) and PlayerResource:IsValidPlayer(tonumber(split[4])) then
        hero = PlayerResource:GetSelectedHeroEntity(tonumber(split[4]))
    end
    local step = 0
    local delay = 0.1
    if split[3] and tonumber(split[3]) then
        delay = tonumber(split[3])
    end
    Timers:CreateTimer(0 ,function()
        local spawnPoint = hero:GetAbsOrigin()
        local newItem = CreateItem( "item_bag_of_gold_big", nil, nil )
        -- newItem:SetCurrentCharges(1000)
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        local dropRadius = RandomFloat( 50, 100 )

        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
        step = step + 1
        if step < count then
            return delay
        end
        return nil
    end)
end
-- -bags 5000 3 4
function ChatCommands:DropBagMessage(keyword)
    local message = self:Font() .. keyword .. " {количество} {интервал} {игрок} </font> Из героя сыпятся мешки с золотом"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:Box(pid, text)
    local keyword = "box"
    if pid < 0 then
        self:BoxMessage(keyword)
        return
    end
    local split = self:SplitString(text)
    if keyword ~= split[1] then return end
    local chest_level = 1
    if split[2] ~= nil and tonumber(split[2]) then 
        chest_level = tonumber(split[2])
    end
    local count = 1
    if split[3] ~= nil and tonumber(split[3]) then 
        count = tonumber(split[3])
    end
    local interval = 0
    if split[4] ~= nil and tonumber(split[4]) then 
        interval = tonumber(split[4])
    end
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    Timers:CreateTimer(0 ,function()
        local item_box = hero:AddItemByName('item_box_'..chest_level)
        item_box:OnSpellStart(hero:GetAbsOrigin())
        count = count-1
        if count == 0 then return end
        return interval
    end)
    
end
function ChatCommands:BoxMessage(keyword)
    local message = self:Font() .. keyword .. " [1|2|3] {количество} {интервал} </font> Сундучок"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
function ChatCommands:TestTalents(pid, text)
    local keyword = {"-talent", "я талант", "t"}
    if pid < 0 then
        self:TestTalentsMessage(keyword)
        return
    end
    if not table.has_value(keyword, text) then return end
	talants.testing[pid] = true
	talants:unset({PlayerID = pid})
	talants:fillTabel(pid, true, false)
end
function ChatCommands:TestTalentsMessage(keyword)
    local message = self:Font()
    for i = 1, #keyword do
        message = message .. keyword[i]
        if i < #keyword then
            message = message .. " / "
        end
    end
    message = message .. "</font> Режим тестирования талантов"
    GameRules:SendCustomMessage(message,0,0)
end
---------------------------------------------------------------------------------------------------
ChatCommands:init()