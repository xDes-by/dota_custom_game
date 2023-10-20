ai_crystal_boss = class({})

function ai_crystal_boss:GetIntrinsicModifierName()
    return "modifier_ai_crystal_boss"
end

modifier_ai_crystal_boss = class({})

LinkLuaModifier("modifier_ai_crystal_boss", "abilities/bosses/crystal/ai_crystal_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ai_crystal_boss:IsHidden()
    return true
end

function modifier_ai_crystal_boss:IsDebuff()
    return false
end

function modifier_ai_crystal_boss:IsPurgable()
    return false
end

function modifier_ai_crystal_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_crystal_boss:IsStunDebuff()
    return false
end

function modifier_ai_crystal_boss:RemoveOnDeath()
    return false
end

function modifier_ai_crystal_boss:DestroyOnExpire()
    return false
end

function modifier_ai_crystal_boss:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.abi1 = self.parent:FindAbilityByName("ability_crystal_boss_nova")
    self.abi2 = self.parent:FindAbilityByName("ability_crystal_boss_freezing_field")
    self.abi3 = self.parent:FindAbilityByName("ability_crystal_boss_frost_bite")
    self.abi4 = self.parent:FindAbilityByName("ability_crystal_boss_create_spire")
    self:StartIntervalThink(1)
end

function modifier_ai_crystal_boss:OnIntervalThink()
    if self.parent:IsChanneling() then
        return
    end
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #units > 0 then
        if self.abi1:IsFullyCastable() then
            self:GetCaster():CastAbilityNoTarget(self.abi1, -1)
            return
        end
        if self.abi4:IsFullyCastable() then
            local pos = self:GetParent():GetAbsOrigin()
            self:GetCaster():CastAbilityOnPosition((units[RandomInt(1, #units)]:GetAbsOrigin() - pos) / 2 - pos, self.abi4, -1)
            return
        end
        if self.abi3:IsFullyCastable() then
            self:GetCaster():CastAbilityOnTarget(units[RandomInt(1, #units)], self.abi3, -1)
            return
        end
        if self.abi2:IsFullyCastable() then
            self:GetCaster():CastAbilityNoTarget(self.abi2, -1)
            return
        end
        self.parent:MoveToTargetToAttack(units[1])
    end
end



