tower_kill = class({})

function tower_kill:Spawn()
    if not IsServer() then
        return
    end
    if self:GetCaster():GetUnitName() ~= "npc_dota_custom_tower_dire_1" then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bane_nightmare_invulnerable", {})
    end
end

function tower_kill:OnOwnerDied()
    local unit = table.random(_G.Miniboses)
    _G.Miniboses = table.remove_item(_G.Miniboses, unit)
    local creep = CreateUnitByName(unit, self:GetCaster():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
    creep:SetBaseDamageMin(10000)
    creep:SetBaseDamageMax(12000)
    creep:SetPhysicalArmorBaseValue(900)
    creep:SetBaseMagicalResistanceValue(99)
    creep:SetMaxHealth(300000)
    creep:SetBaseMaxHealth(300000)
    creep:SetHealth(300000)
    Rules:difficality_modifier(creep)
    name = self:GetCaster():GetUnitName()
    if name == "npc_dota_custom_tower_dire_1" then
        local towers = Entities:FindAllByName("npc_dota_custom_tower_dire_1")
        local pass = true
        for k,v in pairs(towers) do
            if v:IsAlive() then
                pass = false
            end
        end
        if pass then
            local t = Entities:FindAllByName("npc_dota_custom_tower_dire_2")
            for _,tower in pairs(t) do
                local m = tower:FindModifierByName("modifier_bane_nightmare_invulnerable")
                if m then
                    m:Destroy()
                end
            end
        end
    end
    if name == "npc_dota_custom_tower_dire_2" then
        local towers = Entities:FindAllByName("npc_dota_custom_tower_dire_2")
        local pass = true
        for k,v in pairs(towers) do
            if v:IsAlive() then
                pass = false
            end
        end
        if pass then
            local t = Entities:FindAllByName("npc_dota_custom_tower_dire_3")
            for _,tower in pairs(t) do
                local m = tower:FindModifierByName("modifier_bane_nightmare_invulnerable")
                if m then
                    m:Destroy()
                end
            end
        end
    end
    if name == "npc_dota_custom_tower_dire_3" then
        local towers = Entities:FindAllByName("npc_dota_custom_tower_dire_3")
        local pass = true
        for k,v in pairs(towers) do
            if v:IsAlive() then
                pass = false
            end
        end
        if pass then
            local t = Entities:FindAllByName("npc_dota_custom_tower_dire_4")
            for _,tower in pairs(t) do
                local m = tower:FindModifierByName("modifier_bane_nightmare_invulnerable")
                if m then
                    m:Destroy()
                end
            end
        end
    end
    if name == "npc_dota_custom_tower_dire_4" then
        local towers = Entities:FindAllByName("npc_dota_custom_tower_dire_4")
        local pass = true
        for k,v in pairs(towers) do
            if v:IsAlive() then
                pass = false
            end
        end
        if pass then
            local tower = Entities:FindByName(nil, "badguys_creeps")
            if tower then
                local m = tower:FindModifierByName("modifier_bane_nightmare_invulnerable")
                if m then
                    m:Destroy()
                end
            end
            local tower = Entities:FindByName(nil, "badguys_comandirs")
            if tower then
                local m = tower:FindModifierByName("modifier_bane_nightmare_invulnerable")
                if m then
                    m:Destroy()
                end
            end
            local tower = Entities:FindByName(nil, "badguys_boss")
            if tower then
                local m = tower:FindModifierByName("modifier_bane_nightmare_invulnerable")
                if m then
                    m:Destroy()
                end
            end
        end
    end
end