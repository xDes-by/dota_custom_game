ability_npc_patrool4_zoomby = class({})

LinkLuaModifier("modifier_ability_npc_patrool4_zoomby", "abilities/lane_creeps/ability_npc_patrool4_zoomby.lua", LUA_MODIFIER_MOTION_NONE)

function ability_npc_patrool4_zoomby:OnSpellStart()
    local unit = CreateUnitByName("npc_patrool4_tomb", self:GetCursorPosition(), true, nil, nil, self:GetCaster():GetTeamNumber())
    unit:SetMaxHealth(20)
    unit:SetHealth(20)
    unit:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_patrool4_zoomby", {})
    unit:AddNewModifier(self:GetCaster(), self, "modifier_pips", {pips_count = 20})
    unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 30})
end

modifier_ability_npc_patrool4_zoomby = class({})
--Classifications template
function modifier_ability_npc_patrool4_zoomby:IsHidden()
    return true
end

function modifier_ability_npc_patrool4_zoomby:IsDebuff()
    return false
end

function modifier_ability_npc_patrool4_zoomby:IsPurgable()
    return false
end

function modifier_ability_npc_patrool4_zoomby:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool4_zoomby:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool4_zoomby:RemoveOnDeath()
    return true
end

function modifier_ability_npc_patrool4_zoomby:DestroyOnExpire()
    return true
end

function modifier_ability_npc_patrool4_zoomby:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.pos = self:GetParent():GetOrigin()
    self:StartIntervalThink(0.5)
end

function modifier_ability_npc_patrool4_zoomby:OnIntervalThink()
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.pos, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
    if #enemies > 0 then
        local unit = CreateUnitByName("npc_dota_unit_undying_zombie",self.pos, true, nil, nil, self:GetCaster():GetTeamNumber())
        unit:SetForceAttackTarget(enemies[1])
        unit:AddNewModifier(self:GetCaster(), self, "modifier_pips", {pips_count = 2})
    end
end

function modifier_ability_npc_patrool4_zoomby:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_ability_npc_patrool4_zoomby:OnDeath(data)
    if data.unit == self.parent then
        local g1 = data.attacker:GetGold()
        local g2 = data.attacker:FindModifierByName("modifier_gold_bank"):GetStackCount()
        data.attacker:ModifyGoldFiltered(data.attacker:GetPlayerOwnerID(), (g1 + g2) * 0.1, true, 0)
    end
end