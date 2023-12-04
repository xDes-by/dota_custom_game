ai_bara_boss = class({})

LinkLuaModifier( "modifier_ai_bara_boss", "abilities/bosses/bara/ai_bara_boss", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ai_bara_boss_return", "abilities/bosses/bara/ai_bara_boss", LUA_MODIFIER_MOTION_NONE )

function ai_bara_boss:GetIntrinsicModifierName()
    return "modifier_ai_bara_boss"
end

modifier_ai_bara_boss = class({})
--Classifications template
function modifier_ai_bara_boss:IsHidden()
    return true
end

function modifier_ai_bara_boss:IsDebuff()
    return false
end

function modifier_ai_bara_boss:IsPurgable()
    return false
end

function modifier_ai_bara_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_bara_boss:IsStunDebuff()
    return false
end

function modifier_ai_bara_boss:RemoveOnDeath()
    return true
end

function modifier_ai_bara_boss:DestroyOnExpire()
    return false
end

function modifier_ai_bara_boss:OnCreated()
    if not IsServer() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_elder_titan_echo_stomp", {})
    Timers:CreateTimer(0.03,function()
        self:GetParent().return_position = self:GetParent():GetAbsOrigin()
    end)
    self.abi1 = self:GetCaster():FindAbilityByName("ability_npc_bara_boss_charge")
    self.abi2 = self:GetCaster():FindAbilityByName("ability_npc_bara_boss_nether_strike")
    self.abi3 = self:GetCaster():FindAbilityByName("ability_npc_bara_boss_firestorm")
    self.abi4 = self:GetCaster():FindAbilityByName("ability_npc_bara_boss_kabanchiki")
    self.Phase = "AFK"
    self:StartIntervalThink(FrameTime())
end

function modifier_ai_bara_boss:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    local m = self:GetCaster():FindModifierByName("modifier_elder_titan_echo_stomp")
    if m then
        if #units ~= 0 then
            self.Phase = "AFK"
            if m then
                m:Destroy()
                self:StartIntervalThink(5)
            end
        end
        return
    end
    local IsOnSpawnPos = (self:GetParent().return_position - self:GetCaster():GetAbsOrigin()):Length2D() < 200
    if self.Phase == "Figting_Spawn_pos" and (self.focus_target and self.focus_target:IsAlive()) then
        if not IsOnSpawnPos then
            self.Phase = "AFK"
        end
        if self.abi3:IsFullyCastable() then
            self:GetCaster():CastAbilityNoTarget(self.abi3, -1)
            return
        end
        if self.abi4:IsFullyCastable() then
            self:GetCaster():CastAbilityNoTarget(self.abi4, -1)
            return
        end
        return
    end
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if IsOnSpawnPos and #units > 0 and self.Phase ~= "Figting_Spawn_pos" then
        self.Phase = "Figting_Spawn_pos"
        self:GetCaster():CastAbilityNoTarget(self.abi4, -1)
        self.focus_target = units[1]
        self:GetCaster():MoveToTargetToAttack(self.focus_target)
        return
    end

    if self.Phase == "Figting" or self.Phase == "Nether_strike" then
        self.Phase = "Return"
        self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ai_bara_boss_return", {})
        self:StartIntervalThink(1)
        return
    end
    if self.Phase == "Return" then
        if IsOnSpawnPos then
            self.mod:Destroy()
            self.Phase = "AFK"
            self:StartIntervalThink(5)
            return
        end
    end
    if self.Phase == "AFK" then
        local players = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        if not self.abi2:IsFullyCastable() then
            if #players > 0 then
                local r = table.random(players)
                if not r:IsInRangeOfShop(DOTA_SHOP_HOME, false) then
                    self:GetCaster():CastAbilityOnTarget(table.random(players), self.abi1, -1)
                    self.Phase = "Charge"
                    self:StartIntervalThink(1)
                    return
                end
            end
        else
            local pID = RandomInt(0, PlayerResource:GetPlayerCount() - 1)
            if PlayerResource:IsValidPlayerID(pID) then
                local hTarget = PlayerResource:GetSelectedHeroEntity(pID)
                if not hTarget:IsInRangeOfShop(DOTA_SHOP_HOME, false) then
                    self:GetCaster():CastAbilityOnTarget(hTarget, self.abi2, -1)
                    self.Phase = "Nether_strike"
                    self:StartIntervalThink(17.5)
                    return
                end
            end
        end
    end
    if not self:GetCaster():HasModifier("modifier_spirit_breaker_charge_of_darkness_lua") and self.Phase == "Charge" then
        self.Phase = "Figting"
    end
    if self.Phase == "Figting" then
        self:GetCaster():CastAbilityNoTarget(self.abi3, -1)
        self:StartIntervalThink(7)
        return
    end
end





















modifier_ai_bara_boss_return = class({})
--Classifications template
function modifier_ai_bara_boss_return:IsHidden()
    return true
end

function modifier_ai_bara_boss_return:IsDebuff()
    return false
end

function modifier_ai_bara_boss_return:IsPurgable()
    return false
end

function modifier_ai_bara_boss_return:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ai_bara_boss_return:IsStunDebuff()
    return false
end

function modifier_ai_bara_boss_return:RemoveOnDeath()
    return true
end

function modifier_ai_bara_boss_return:DestroyOnExpire()
    return true
end

function modifier_ai_bara_boss_return:OnCreated(data)
    if not IsServer() then
        return
    end
    self.returnn = self:GetParent().return_position
    EmitGlobalSound("Dota_Boss.bara_charge_return")
    self:StartIntervalThink(FrameTime())
end

function modifier_ai_bara_boss_return:OnIntervalThink()
    self:GetCaster():MoveToPosition(self.returnn)
end

function modifier_ai_bara_boss_return:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }
end

function modifier_ai_bara_boss_return:CheckState()
    return {
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS ] = true,

    }
end

function modifier_ai_bara_boss_return:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
end

function modifier_ai_bara_boss_return:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ai_bara_boss_return:GetOverrideAnimation()
    return ACT_DOTA_SPIRIT_BREAKER_ULT_RUN
end

function modifier_ai_bara_boss_return:GetModifierMoveSpeed_Absolute()
    return 2000
end