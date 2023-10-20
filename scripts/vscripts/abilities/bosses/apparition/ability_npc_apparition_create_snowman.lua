ability_npc_apparition_create_snowman = class({})

LinkLuaModifier("modifier_ability_npc_apparition_snowman", "abilities/bosses/apparition/ability_npc_apparition_snowman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_apparition_snowman_hidden", "abilities/bosses/apparition/ability_npc_apparition_snowman", LUA_MODIFIER_MOTION_NONE)

function ability_npc_apparition_create_snowman:Spawn()
    if not IsServer() then
        return
    end
    local pos = self:GetCaster():GetAbsOrigin()
    local team = self:GetCaster():GetTeamNumber()
    self.tbl = {}
    for i=1,20 do
        local unit = CreateUnitByName("npc_apparition_snowman", pos, false, nil, nil, team)
        unit:AddNewModifier(unit, self, "modifier_ability_npc_apparition_snowman_hidden", {})
        table.insert( self.tbl, unit )
    end
end

function ability_npc_apparition_create_snowman:OnOwnerDied()
    if not IsServer() then
        return
    end
    for _,unit in pairs(self.tbl) do
        UTIL_Remove(unit)
    end
end

function ability_npc_apparition_create_snowman:OnSpellStart()
    local pos = self:GetCaster():GetAbsOrigin()
    for _,unit in pairs(self.tbl) do
        unit:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_apparition_snowman", {})
        FindClearSpaceForUnit(unit, pos + RandomVector(RandomInt(200, 900)), true)
    end
end