if AdminPanel == nil then
    _G.AdminPanel = class({})
end

function AdminPanel:init()
    CustomGameEventManager:RegisterListener("AdminPanelChangeGold",function(_, keys)
        self:ChangeGold(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelDropItems",function(_, keys)
        self:DropItems(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelGiveSouls",function(_, keys)
        self:GiveSouls(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelGiveBooks",function(_, keys)
        self:GiveBooks(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelTalents",function(_, keys)
        self:Talents(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelTalentsDrop",function(_, keys)
        self:TalentsDrop(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelHeroLevel",function(_, keys)
        self:HeroLevel(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelChangeGems",function(_, keys)
        self:ChangeGems(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelBattlePassAddExperience",function(_, keys)
        self:BattlePassAddExperience(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelBattlePassDrop",function(_, keys)
        self:BattlePassDrop(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelBattlePassPremium",function(_, keys)
        self:BattlePassPremium(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelAddCoins",function(_, keys)
        self:AddCoins(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelMidOff",function(_, keys)
        self:MidOff(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelMidOn",function(_, keys)
        self:MidOn(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelLocalize",function(_, keys)
        self:Localize(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelCreateBot",function(_, keys)
        self:CreateBot(keys)
    end)
    CustomGameEventManager:RegisterListener("AdminPanelTest",function(_, keys)
        self:Test(keys)
    end)
end


function AdminPanel:ChangeGold(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    if t.amount > 0 then
        hero:ModifyGoldFiltered(t.amount, true, 0)
    else
        local totalgold = hero:GetTotalGold()
        if totalgold + t.amount > 0 then
            hero:ModifyGoldFiltered(t.amount, true, 0)
        else
            hero:ModifyGoldFiltered(-totalgold, true, 0)
        end
    end
end

function AdminPanel:DropItems(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    local heroPoint = hero:GetAbsOrigin()
    local itemsList = {
        {vector = Vector(heroPoint.x + -300, heroPoint.y + 300), name = "item_assault_lua"},
        {vector = Vector(heroPoint.x + -250, heroPoint.y + 300), name = "item_desolator_lua"},
        {vector = Vector(heroPoint.x + -200, heroPoint.y + 300), name = "item_butterfly_lua"},
        {vector = Vector(heroPoint.x + -300, heroPoint.y + 250), name = "item_monkey_king_bar_lua"},
        {vector = Vector(heroPoint.x + -250, heroPoint.y + 250), name = "item_vladmir_lua"},
        {vector = Vector(heroPoint.x + -200, heroPoint.y + 250), name = "item_hood_sword_lua"},
        {vector = Vector(heroPoint.x + -300, heroPoint.y + 200), name = "item_greater_crit_lua"},
        {vector = Vector(heroPoint.x + -250, heroPoint.y + 200), name = "item_moon_shard_lua"},
        {vector = Vector(heroPoint.x + -200, heroPoint.y + 200), name = "item_satanic_lua"},

        {vector = Vector(heroPoint.x + -100, heroPoint.y + 300), name = "item_kaya_custom_lua"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + 250), name = "item_bloodstone_lua"},
        {vector = Vector(heroPoint.x + -100, heroPoint.y + 200), name = "item_kaya_lua"},
        {vector = Vector(heroPoint.x + -50, heroPoint.y + 300), name = "item_sheepstick_lua"},
        {vector = Vector(heroPoint.x + -50, heroPoint.y + 250), name = "item_veil_of_discord_lua"},
        {vector = Vector(heroPoint.x + -50, heroPoint.y + 200), name = "item_shivas_guard_lua"},

        {vector = Vector(heroPoint.x + 50, heroPoint.y + 300), name = "item_pudge_heart_lua"},
        {vector = Vector(heroPoint.x + 50, heroPoint.y + 250), name = "item_mage_heart_lua"},
        {vector = Vector(heroPoint.x + 50, heroPoint.y + 200), name = "item_agility_heart_lua"},

        {vector = Vector(heroPoint.x + 150, heroPoint.y + 300), name = "item_heart_lua"},
        {vector = Vector(heroPoint.x + 200, heroPoint.y + 300), name = "item_crimson_guard_lua"},
        {vector = Vector(heroPoint.x + 250, heroPoint.y + 300), name = "item_octarine_core_lua"},
        {vector = Vector(heroPoint.x + 150, heroPoint.y + 250), name = "item_ring_of_flux_lua"},
        {vector = Vector(heroPoint.x + 200, heroPoint.y + 250), name = "item_meteor_hammer_lua"},
        {vector = Vector(heroPoint.x + 250, heroPoint.y + 250), name = "item_radiance_lua"},
        {vector = Vector(heroPoint.x + 150, heroPoint.y + 200), name = "item_ethereal_blade_lua"},
        {vector = Vector(heroPoint.x + 200, heroPoint.y + 200), name = "item_mjollnir_lua"},
        {vector = Vector(heroPoint.x + 250, heroPoint.y + 200), name = "item_bfury_lua"},

        {vector = Vector(heroPoint.x + -50, heroPoint.y + 100), name = "item_tank_cuirass8"},
        {vector = Vector(heroPoint.x + 0, heroPoint.y + 100), name = "item_tank_crimson8"},
        {vector = Vector(heroPoint.x + 50, heroPoint.y + 100), name = "item_tank_hell8"},
    }

    for _, item in pairs(itemsList) do
        local newItem = CreateItem( item.name, nil, nil )
        newItem:SetLevel(t.level)
        local drop = CreateItemOnPositionForLaunch( heroPoint, newItem )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, item.vector )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
    end
end

function AdminPanel:GiveSouls(t)
    for i = 1, 6 do
        sInv:AddSoul("item_forest_soul", t.PlayerID)
        sInv:AddSoul("item_village_soul", t.PlayerID)
        sInv:AddSoul("item_mines_soul", t.PlayerID)
        sInv:AddSoul("item_dust_soul", t.PlayerID)
        sInv:AddSoul("item_swamp_soul", t.PlayerID)
        sInv:AddSoul("item_snow_soul", t.PlayerID)
        sInv:AddSoul("item_divine_soul", t.PlayerID)
        sInv:AddSoul("item_cemetery_soul", t.PlayerID)
        sInv:AddSoul("item_magma_soul", t.PlayerID)
        sInv:AddSoul("item_antimage_soul", t.PlayerID)
        sInv:AddSoul("item_dragon_soul", t.PlayerID)
        sInv:AddSoul("item_dragon_soul_2", t.PlayerID)
        sInv:AddSoul("item_dragon_soul_3", t.PlayerID)
    end
end

function AdminPanel:GiveBooks(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    local spawnPoint = hero:GetAbsOrigin()
    for _,item_name in pairs({"item_greed_agi","item_greed_int","item_greed_str"}) do
        local newItem = CreateItem( item_name, owner, owner )
        newItem:SetCurrentCharges(100)
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        local dropRadius = RandomFloat( 50, 100 )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
        newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
    end
end

function AdminPanel:Talents(t)
    local pid = t.PlayerID
    Talents:RemoveAllTalentsCheat(t)
    Talents:FillTablesFromDatabase(pid, Talents.data_base[pid], true)
    Talents.player[pid].index = PlayerResource:GetSelectedHeroEntity( pid ):entindex()
    Talents:UpdateTable(pid)
end

function AdminPanel:TalentsDrop(t)
    talants:unset(t)
end

function AdminPanel:HeroLevel(t)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    for i = 1, tonumber(t.amount) do
        hero:HeroLevelUp(true)
    end
end

function AdminPanel:ChangeGems(t)
    for i = 1, 5 do
        CustomShop:AddGems(t.PlayerID, { [i] = t.amount }, false)
    end
end

function AdminPanel:BattlePassAddExperience(t)
    BattlePass:AddExperience(t.PlayerID, t.amount, false)
end
function AdminPanel:BattlePassDrop(t)
    BattlePass:ResetProgress(t.PlayerID)
end
function AdminPanel:BattlePassPremium(t)
    BattlePass:ActivatePremium(t.PlayerID)
end
function AdminPanel:AddCoins(t)
    CustomShop:AddCoins(t.PlayerID, 100, true, true)
end
function AdminPanel:MidOff(t)
    _G.spawnCreeps = false
    CustomGameEventManager:Send_ServerToAllClients( "SendToPlayerError", {error = "МИД ВЫКЛ"} )
end
function AdminPanel:MidOn(t)
    _G.spawnCreeps = true
    CustomGameEventManager:Send_ServerToAllClients( "SendToPlayerError", {error = "МИД ВКЛ"} )
end
function AdminPanel:Localize(t)
    -- local main_file = "addon_russian"
    -- local compare_to = "addon_english"
    -- print(LoadKeyValues("scripts/kv/addon_english.txt"))
    -- print(LoadKeyValues("scripts/kv/addon_russian2.txt"))
    local main_kv = LoadKeyValues("scripts/kv/addon_russian.txt")["Tokens"]
    local compare_kv = LoadKeyValues("scripts/kv/addon_english.txt")["Tokens"]
    for k,v in pairs(main_kv) do
        if compare_kv[k] == nil then
            print('"'..k..'"','"'..v..'"')
        end
    end
end
function AdminPanel:CreateBot(t)
    local pid = t.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    -- local unit = CreateUnitByName( "npc_dota_hero_axe", Vector(-1295.685547, 4705.719727, 384.000000), true, nil, nil, DOTA_TEAM_GOODGUYS )
    -- unit:SetControllableByPlayer(pid, true)
    -- unit:SetOwner(hero)
    -- unit:SetLevel(500)
    local unit = CreateUnitByName("npc_dota_hero_axe", Vector(-1295.685547, 4705.719727, 384.000000), false, nil, nil, DOTA_TEAM_GOODGUYS)
    -- unit:AddItemByName("item_heart_lua"):SetLevel(11)
    unit:AddItemByName("item_assault_lua"):SetLevel(11)
    unit:AddItemByName("item_desolator_lua"):SetLevel(11)
    unit:AddItemByName("item_heart_lua"):SetLevel(11)
    unit:AddItemByName("item_radiance_lua"):SetLevel(11)
    unit:AddItemByName("item_kaya_custom_lua"):SetLevel(11)
    unit:AddItemByName("item_bloodstone_lua"):SetLevel(11)

    -- b1 = 0
    -- while b1 < 6 do
    --     add_item = avaliable_creeps_items[RandomInt(1,#avaliable_creeps_items)]
    --     while not unit:HasItemInInventory(add_item) do
    --         b1 = b1 + 1
    --         unit:AddItemByName(add_item):SetLevel(5)
    --     end
    -- end
    -- Timers:CreateTimer(1, function()
    --     
    --     unit:AddItemByName("item_assault_lua"):SetLevel(11)
    --     unit:AddItemByName("item_desolator_lua"):SetLevel(11)
    --     unit:AddItemByName("item_heart_lua"):SetLevel(11)
    --     unit:AddItemByName("item_radiance_lua"):SetLevel(11)
    --     unit:AddItemByName("item_kaya_custom_lua"):SetLevel(11)
    --     unit:AddItemByName("item_bloodstone_lua"):SetLevel(11)
    -- end)
    Timers:CreateTimer(0, function()
        ExecuteOrderFromTable({
            UnitIndex = unit:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
            Position = Vector(-1295.685547, 4705.719727, 384.000000),
        })
        return 10
    end)
end
function AdminPanel:Test(t)
    local pid = t.PlayerID
    -- Talents:SaveData(pid)
    DataBase:EndGameSession(pid, 20)
end

AdminPanel:init()