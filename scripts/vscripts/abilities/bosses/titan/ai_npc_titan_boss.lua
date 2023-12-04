ai_npc_titan_boss = class({})

function ai_npc_titan_boss:GetIntrinsicModifierName()
    return "modifier_ai_npc_titan_boss"
end

modifier_ai_npc_titan_boss = class({})

LinkLuaModifier("modifier_ai_npc_titan_boss", "abilities/bosses/titan/ai_npc_titan_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ai_npc_titan_boss:IsHidden()
    return true
end

function modifier_ai_npc_titan_boss:IsDebuff()
    return false
end

function modifier_ai_npc_titan_boss:IsPurgable()
    return false
end

function modifier_ai_npc_titan_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_npc_titan_boss:IsStunDebuff()
    return false
end

function modifier_ai_npc_titan_boss:RemoveOnDeath()
    return false
end

function modifier_ai_npc_titan_boss:DestroyOnExpire()
    return false
end

function modifier_ai_npc_titan_boss:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.abi1 = self:GetParent():FindAbilityByName("ability_npc_titan_boss_spirit_summon")
    self.abi2 = self:GetParent():FindAbilityByName("ability_npc_titan_boss_stomp")
    self.abi3 = self:GetParent():FindAbilityByName("ability_npc_titan_boss_trample")
    self.abi4 = self:GetParent():FindAbilityByName("ability_npc_titan_boss_skewer")
    self:StartIntervalThink(1.5)
end

function modifier_ai_npc_titan_boss:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if self.parent:HasModifier("modifier_ability_npc_titan_boss_trample") then
        if #units > 1 then
            self.parent:MoveToNPC(units[2])
            self:StartIntervalThink(0.2)
        else
            self.parent:MoveToPosition(self:GetParent():GetAbsOrigin() + RandomVector(300))
            self:StartIntervalThink(0.5)
        end
        return
    else
        self:StartIntervalThink(1.5)
    end
    if #units > 0 then
        if (units[1]:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > 400 then
            self:GetCaster():MoveToTargetToAttack(units[1])
        end
        if self.abi2:IsFullyCastable() then
            self.parent:CastAbilityNoTarget(self.abi2, -1)
            return
        end
        if self.abi1:IsFullyCastable() then
            self.parent:CastAbilityNoTarget(self.abi1, -1)
            return
        end
        if self.abi3:IsFullyCastable() then
            self.parent:CastAbilityNoTarget(self.abi3, -1)
        end
        if self.abi4:IsFullyCastable() then
            local direction = units[1]:GetAbsOrigin() - self.parent:GetAbsOrigin()
            direction.z = 0
            direction = direction:Normalized()
            self.parent:CastAbilityOnPosition(direction * 900, self.abi4, -1)
            return
        end
    end
end


