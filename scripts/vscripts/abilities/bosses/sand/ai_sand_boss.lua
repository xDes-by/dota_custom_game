ai_sand_boss = class({})

function ai_sand_boss:GetIntrinsicModifierName()
    return "modifier_ai_sand_boss"
end

modifier_ai_sand_boss = class({})

LinkLuaModifier("modifier_ai_sand_boss", "abilities/bosses/sand/ai_sand_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ai_sand_boss_return", "abilities/bosses/sand/ai_sand_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ai_sand_boss:IsHidden()
    return true
end

function modifier_ai_sand_boss:IsDebuff()
    return false
end

function modifier_ai_sand_boss:IsPurgable()
    return false
end

function modifier_ai_sand_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_sand_boss:IsStunDebuff()
    return false
end

function modifier_ai_sand_boss:RemoveOnDeath()
    return false
end

function modifier_ai_sand_boss:DestroyOnExpire()
    return false
end

function modifier_ai_sand_boss:OnCreated()
    if not IsServer() then
        return
    end
    self.spawn_pos = self:GetParent():GetAbsOrigin()
    self:GetAbility().spawn_pos = self:GetParent():GetAbsOrigin()
    self.parent = self:GetParent()
    self.abi1 = self.parent:FindAbilityByName("ability_sand_storm_boss")
    self.abi2 = self.parent:FindAbilityByName("ability_burrowstrike_boss")
    self.think = 0
    self:StartIntervalThink(1)
end

function modifier_ai_sand_boss:OnIntervalThink()
    if not IsServer() then
        return
    end
    local IsInSpawnRadius = (self.spawn_pos - self:GetCaster():GetAbsOrigin()):Length2D() < 1000
    if not IsInSpawnRadius then
        if self.think >= 3 then
            self.think = 0
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ai_sand_boss_return", {})
            
        else
            self.think = self.think + 1
        end
    end
    if self.abi1:IsFullyCastable() then
        self:GetCaster():CastAbilityNoTarget(self.abi1, -1)
    end
    if self.abi2:IsFullyCastable() and not self:GetCaster():HasModifier("modifier_ai_sand_boss_return") then
        self:GetCaster():CastAbilityOnPosition(self.parent:GetAbsOrigin(), self.abi2, -1)
    end
end

modifier_ai_sand_boss_return = class({})
--Classifications template
function modifier_ai_sand_boss_return:IsHidden()
    return true
end

function modifier_ai_sand_boss_return:IsDebuff()
    return false
end

function modifier_ai_sand_boss_return:IsPurgable()
    return false
end

function modifier_ai_sand_boss_return:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_sand_boss_return:IsStunDebuff()
    return false
end

function modifier_ai_sand_boss_return:RemoveOnDeath()
    return true
end

function modifier_ai_sand_boss_return:DestroyOnExpire()
    return true
end

function modifier_ai_sand_boss_return:OnCreated()
    if not IsServer() then
        return
    end
    self.spawn_pos = self:GetParent():GetAbsOrigin()
    self:StartIntervalThink(FrameTime())
end

function modifier_ai_sand_boss_return:OnIntervalThink()
    if (self.spawn_pos - self:GetCaster():GetAbsOrigin()):Length2D() < 200 then
        self:Destroy()
    end
    self:GetCaster():MoveToPosition(self.spawn_pos)
end

function modifier_ai_sand_boss_return:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

function modifier_ai_sand_boss_return:CheckState()
    return {
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,

    }
end

function modifier_ai_sand_boss_return:GetModifierMoveSpeed_Absolute()
    return 2000
end

function modifier_ai_sand_boss_return:GetModifierConstantHealthRegen()
    return self:GetCaster():GetMaxHealth() * 0.01
end