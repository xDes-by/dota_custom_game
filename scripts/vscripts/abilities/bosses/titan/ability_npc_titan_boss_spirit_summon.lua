ability_npc_titan_boss_spirit_summon = class({})

LinkLuaModifier("modifier_ability_npc_titan_boss_spirit_summon", "abilities/bosses/titan/ability_npc_titan_boss_spirit_summon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spirit_moving", "abilities/bosses/titan/ability_npc_titan_boss_spirit_summon", LUA_MODIFIER_MOTION_NONE)

function ability_npc_titan_boss_spirit_summon:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_titan_boss_spirit_summon", {duration = 3})
end

modifier_ability_npc_titan_boss_spirit_summon = class({})
--Classifications template
function modifier_ability_npc_titan_boss_spirit_summon:IsHidden()
    return true
end

function modifier_ability_npc_titan_boss_spirit_summon:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_summon:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_spirit_summon:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_spirit_summon:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_summon:RemoveOnDeath()
    return true
end

function modifier_ability_npc_titan_boss_spirit_summon:DestroyOnExpire()
    return true
end

function modifier_ability_npc_titan_boss_spirit_summon:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.parent:SetForwardVector(self:GetParent():GetRightVector() * -1)
    self:StartIntervalThink(1)
    self:OnIntervalThink()
end

function modifier_ability_npc_titan_boss_spirit_summon:OnIntervalThink()
    self.parent:SetForwardVector(self:GetParent():GetRightVector())
    self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ANCESTRAL_SPIRIT, 1.1)
    local unit = CreateUnitByName("npc_elder_spirit", self.parent:GetAbsOrigin(), true, nil, nil, self.parent:GetTeamNumber())
    unit.stomp_type = self:GetParent().stomp_type
    local position = self:GetParent():GetForwardVector() * 500 + self:GetParent():GetAbsOrigin()
    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_spirit_moving", {position_x = position.x, position_y = position.y, position_z = position.z})
end

function modifier_ability_npc_titan_boss_spirit_summon:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true
    }
end



modifier_spirit_moving = class({})
--Classifications template
function modifier_spirit_moving:IsHidden()
    return true
end

function modifier_spirit_moving:IsDebuff()
    return false
end

function modifier_spirit_moving:IsPurgable()
    return false
end

function modifier_spirit_moving:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_spirit_moving:IsStunDebuff()
    return false
end

function modifier_spirit_moving:RemoveOnDeath()
    return true
end

function modifier_spirit_moving:DestroyOnExpire()
    return true
end

function modifier_spirit_moving:OnCreated(data)
    if not IsServer() then
        return
    end
    self.abi = self:GetParent():FindAbilityByName("ability_npc_titan_boss_spirit_summon")
    self.position = Vector(data.position_x, data.position_y, data.position_z)
    self:StartIntervalThink(FrameTime())
end

function modifier_spirit_moving:OnIntervalThink()
    if (self:GetParent():GetAbsOrigin() - self.position):Length2D() < 100 then
        self:Destroy()
        return
    end
    self:GetParent():MoveToPosition(self.position)
end

function modifier_spirit_moving:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():CastAbilityNoTarget(self:GetParent():FindAbilityByName("ability_npc_titan_boss_stomp"), -1)
end

function modifier_spirit_moving:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }
end

function modifier_spirit_moving:CheckState()
    return {
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS ] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end

function modifier_spirit_moving:GetModifierMoveSpeed_Absolute()
    return 500
end