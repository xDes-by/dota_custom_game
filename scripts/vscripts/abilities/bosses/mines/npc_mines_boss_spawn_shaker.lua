npc_mines_boss_spawn_shaker = class({})

LinkLuaModifier("modifier_npc_mines_boss_spawn_shaker_controller", "abilities/bosses/mines/npc_mines_boss_spawn_shaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

function npc_mines_boss_spawn_shaker:GetIntrinsicModifierName()
	return "modifier_earthshaker_fissure_shard_pathing"
end

function npc_mines_boss_spawn_shaker:OnSpellStart()
    local pos = self:GetCaster():GetAbsOrigin()
    local p1 = pos + self:GetCaster():GetRightVector() * 400
    local p2 = pos + self:GetCaster():GetRightVector() * -400
	local units = FindUnitsInRadius(self:GetCaster():GetTeam(), pos, nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    if units[1] then
        local point = units[1]:GetAbsOrigin()
        local distance = (point - pos):Length2D()

        local unit = CreateUnitByName("npc_mine_earthshaker", p1, true, nil, nil, self:GetCaster():GetTeamNumber())
        for i=1,3 do
            self:GetCaster():GetAbilityByIndex(i):SetLevel(4)
        end
        unit:AddNewModifier(self:GetCaster(),self,"modifier_generic_arc_lua", {
            target_x = point.x, target_y = point.y, distance = distance, duration = 1.5, height = 500, fix_end = true,
            isForward = true, duration = 1.5, isStun = true, activity = ACT_DOTA_OVERRIDE_ABILITY_2})
        unit:AddNewModifier(self:GetCaster(), self, "modifier_npc_mines_boss_spawn_shaker_controller", {})

        local unit = CreateUnitByName("npc_mine_earthshaker", p2, true, nil, nil, self:GetCaster():GetTeamNumber())
        for i=1,3 do
            self:GetCaster():GetAbilityByIndex(i):SetLevel(4)
        end
        unit:AddNewModifier(self:GetCaster(),self,"modifier_generic_arc_lua", {
            target_x = point.x, target_y = point.y, distance = distance, duration = 1.5, height = 500, fix_end = true,
            isForward = true, duration = 1.5, isStun = true, activity = ACT_DOTA_OVERRIDE_ABILITY_2})
        unit:AddNewModifier(self:GetCaster(), self, "modifier_npc_mines_boss_spawn_shaker_controller", {})
    end
end

modifier_npc_mines_boss_spawn_shaker_controller = class({})
--Classifications template
function modifier_npc_mines_boss_spawn_shaker_controller:IsHidden()
    return true
end

function modifier_npc_mines_boss_spawn_shaker_controller:IsDebuff()
    return false
end

function modifier_npc_mines_boss_spawn_shaker_controller:IsPurgable()
    return false
end

function modifier_npc_mines_boss_spawn_shaker_controller:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_npc_mines_boss_spawn_shaker_controller:IsStunDebuff()
    return false
end

function modifier_npc_mines_boss_spawn_shaker_controller:RemoveOnDeath()
    return true
end

function modifier_npc_mines_boss_spawn_shaker_controller:DestroyOnExpire()
    return true
end

function modifier_npc_mines_boss_spawn_shaker_controller:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
	local units = FindUnitsInRadius(self.parent:GetTeam(), self.parent:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    if units[1] then 
        self:StartIntervalThink(1.51)
    else
        UTIL_Remove(self.parent)
    end
end

function modifier_npc_mines_boss_spawn_shaker_controller:OnIntervalThink()
    ExecuteOrderFromTable({
        UnitIndex = self.parent:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        AbilityIndex = self.parent:FindAbilityByName("earthshaker_echo_slam"):entindex(),
        Queue = false,
    })
    Timers:CreateTimer(0.1,function()
        UTIL_Remove(self.parent)
    end)
end