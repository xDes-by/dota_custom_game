ai_apparition_boss = class({})

function ai_apparition_boss:GetIntrinsicModifierName()
    return "modifier_ai_apparition_boss"
end

modifier_ai_apparition_boss = class({})

LinkLuaModifier("modifier_ai_apparition_boss", "abilities/bosses/apparition/ai_apparition_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ai_apparition_boss:IsHidden()
    return true
end

function modifier_ai_apparition_boss:IsDebuff()
    return false
end

function modifier_ai_apparition_boss:IsPurgable()
    return false
end

function modifier_ai_apparition_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_apparition_boss:IsStunDebuff()
    return false
end

function modifier_ai_apparition_boss:RemoveOnDeath()
    return false
end

function modifier_ai_apparition_boss:DestroyOnExpire()
    return true
end

function modifier_ai_apparition_boss:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.abi1 = self.parent:FindAbilityByName("ability_apparition_boss_vortex")
    self.abi2 = self.parent:FindAbilityByName("ability_apparition_boss_chilling_touch"):ToggleAutoCast()
    self.abi3 = self.parent:FindAbilityByName("ability_apparition_boss_blast")
    self.abi4 = self.parent:FindAbilityByName("ability_npc_apparition_create_snowman")
    self:StartIntervalThink(1)
end

function modifier_ai_apparition_boss:OnIntervalThink()
    if self.parent:HasModifier("modifier_ability_apparition_boss_blast") then
        return
    end
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #units > 0 then
        if self.abi4:IsFullyCastable() then
            self:GetCaster():CastAbilityNoTarget(self.abi4, -1)
            return
        end
        if self.abi3:IsFullyCastable() then
            if (self:GetParent():GetAbsOrigin() - units[1]:GetAbsOrigin()):Length2D() < 300 then
                self:GetCaster():CastAbilityNoTarget(self.abi3, -1)
                return
            end
        end
        if self.abi3:IsFullyCastable() then
            for i=1,5 do
                ExecuteOrderFromTable({
                    UnitIndex = self.parent:entindex(),
                    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
                    Position = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(200, 700)),
                    AbilityIndex = self.abi1:entindex(),
                    Queue = false,
                })
            end
            self.abi3:StartCooldown(5)
        end
        self:GetParent():MoveToTargetToAttack(units[1])
    end
end