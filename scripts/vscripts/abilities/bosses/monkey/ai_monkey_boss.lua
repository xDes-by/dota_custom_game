ai_monkey_boss = class({})

function ai_monkey_boss:GetIntrinsicModifierName()
    return "modifier_ai_monkey_boss"
end

modifier_ai_monkey_boss = class({})

LinkLuaModifier("modifier_ai_monkey_boss", "abilities/bosses/monkey/ai_monkey_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_boss_gesture_controller", "abilities/bosses/monkey/ai_monkey_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ai_monkey_boss:IsHidden()
    return true
end

function modifier_ai_monkey_boss:IsDebuff()
    return false
end

function modifier_ai_monkey_boss:IsPurgable()
    return false
end

function modifier_ai_monkey_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_monkey_boss:IsStunDebuff()
    return false
end

function modifier_ai_monkey_boss:RemoveOnDeath()
    return false
end

function modifier_ai_monkey_boss:DestroyOnExpire()
    return true
end

function modifier_ai_monkey_boss:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_monkey_boss_gesture_controller", {})
    self.parent:StartGesture(ACT_DOTA_RUN)
    self.parent:RemoveGesture(ACT_DOTA_RUN)
    self.abi1 = self.parent:FindAbilityByName("monkey_king_wukongs_command_custom")
    self.abi2 = self.parent:FindAbilityByName("ability_boundless_strike_boss")
    self.abi3 = self.parent:FindAbilityByName("ability_bananas_boss")
    self:StartIntervalThink(1)
end

function modifier_ai_monkey_boss:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #units > 0 then
        if (units[1]:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > 400 then
            self:GetCaster():MoveToTargetToAttack(units[1])
        else
            if self.abi1:IsFullyCastable() then
                local direction = units[1]:GetAbsOrigin() - self.parent:GetAbsOrigin()
                direction.z = 0
                direction = direction:Normalized()
                self.parent:CastAbilityOnPosition(self.parent:GetAbsOrigin() + direction * 600, self.abi1, -1)
                return
            end
        end
        if self.abi2:IsFullyCastable() then
            if units[1] then
                self.parent:CastAbilityOnPosition(units[1]:GetAbsOrigin(), self.abi2, -1)
                return
            end
        end
        if self.abi3:IsFullyCastable() then
            self.parent:CastAbilityNoTarget(self.abi3, -1)
        end
    end
end



modifier_monkey_boss_gesture_controller = class({})
--Classifications template
function modifier_monkey_boss_gesture_controller:IsHidden()
    return true
end

function modifier_monkey_boss_gesture_controller:IsDebuff()
    return false
end

function modifier_monkey_boss_gesture_controller:IsPurgable()
    return false
end

function modifier_monkey_boss_gesture_controller:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_monkey_boss_gesture_controller:IsStunDebuff()
    return false
end

function modifier_monkey_boss_gesture_controller:RemoveOnDeath()
    return false
end

function modifier_monkey_boss_gesture_controller:DestroyOnExpire()
    return false
end

function modifier_monkey_boss_gesture_controller:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(FrameTime())
end

function modifier_monkey_boss_gesture_controller:OnIntervalThink()
    if self:GetParent():IsMoving() then
        StartAnimation(self:GetParent(), {duration = -1, activity = ACT_DOTA_RUN, translate = "walk"})
    else
        EndAnimation(self:GetParent())
    end
end

