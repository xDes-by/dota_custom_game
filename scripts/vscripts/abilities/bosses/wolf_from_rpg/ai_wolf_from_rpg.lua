ai_wolf_from_rpg = class({})

function ai_wolf_from_rpg:GetIntrinsicModifierName()
    return "modifier_ai_wolf_from_rpg"
end

modifier_ai_wolf_from_rpg = class({})

LinkLuaModifier("modifier_ai_wolf_from_rpg", "abilities/bosses/wolf_from_rpg/ai_wolf_from_rpg", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ai_wolf_from_rpg:IsHidden()
    return true
end

function modifier_ai_wolf_from_rpg:IsDebuff()
    return false
end

function modifier_ai_wolf_from_rpg:IsPurgable()
    return false
end

function modifier_ai_wolf_from_rpg:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_wolf_from_rpg:IsStunDebuff()
    return false
end

function modifier_ai_wolf_from_rpg:RemoveOnDeath()
    return false
end

function modifier_ai_wolf_from_rpg:DestroyOnExpire()
    return false
end

function modifier_ai_wolf_from_rpg:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.spawn_pos = self.parent:GetAbsOrigin()
    self.abi1 = self.parent:FindAbilityByName("ability_npc_boss_hell2_spell1")
    self.abi3 = self.parent:FindAbilityByName("ability_npc_boss_hell2_spell5")
    self:StartIntervalThink(1)
end

function modifier_ai_wolf_from_rpg:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
    if #units == 0 and (self.spawn_pos - self.parent:GetAbsOrigin()):Length2D() > 1000 then
        self.parent:MoveToPosition(self.spawn_pos)
    end
    if #units > 0 then
        if self.abi1:IsFullyCastable() then
            self:GetCaster():CastAbilityOnPosition(units[1]:GetAbsOrigin(), self.abi1, -1)
            return
        end
        if self.abi3:IsFullyCastable() then
            self:GetCaster():CastAbilityNoTarget(self.abi3, -1)
            return
        end
        self.parent:MoveToTargetToAttack(units[1])
    end
end



