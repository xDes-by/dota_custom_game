ability_npc_apparition_snowman = class({})

function ability_npc_apparition_snowman:GetIntrinsicModifierName()
    return "modifier_ability_npc_apparition_snowman_hidden"
end

modifier_ability_npc_apparition_snowman = class({})

LinkLuaModifier("modifier_ability_npc_apparition_snowman", "abilities/bosses/apparition/ability_npc_apparition_snowman", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_apparition_snowman_hidden", "abilities/bosses/apparition/ability_npc_apparition_snowman", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_apparition_snowman:IsHidden()
    return true
end

function modifier_ability_npc_apparition_snowman:IsDebuff()
    return false
end

function modifier_ability_npc_apparition_snowman:IsPurgable()
    return false
end

function modifier_ability_npc_apparition_snowman:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_apparition_snowman:IsStunDebuff()
    return false
end

function modifier_ability_npc_apparition_snowman:RemoveOnDeath()
    return false
end

function modifier_ability_npc_apparition_snowman:DestroyOnExpire()
    return false
end

function modifier_ability_npc_apparition_snowman:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    local m = self:GetParent():FindModifierByName("modifier_ability_npc_apparition_snowman_hidden")
    if m then
        m:Destroy()
    end
    self:StartIntervalThink(FrameTime())
end

function modifier_ability_npc_apparition_snowman:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 150,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #units > 0 then
        for _,unit in pairs(units) do
            unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.3})
        end
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_apparition_snowman_hidden", {})
        self:Destroy()
        local p = ParticleManager:CreateParticle("particles/econ/events/snowman/snowman_projectile_explosion_c.vpcf", PATTACH_POINT_FOLLOW, nil)
        ParticleManager:ReleaseParticleIndex(p)
        return
    end
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 600,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #units > 0 then
        self:GetParent():MoveToPosition(units[1]:GetAbsOrigin())
    else
        self:GetParent():MoveToPosition(self:GetCaster():GetAbsOrigin())
    end
    if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() < 150 then
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_apparition_snowman_hidden", {})
    end
end

function modifier_ability_npc_apparition_snowman:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf"
end

function modifier_ability_npc_apparition_snowman:CheckState()
	return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

modifier_ability_npc_apparition_snowman_hidden = class({})
--Classifications template
function modifier_ability_npc_apparition_snowman_hidden:IsHidden()
    return true
end

function modifier_ability_npc_apparition_snowman_hidden:IsDebuff()
    return false
end

function modifier_ability_npc_apparition_snowman_hidden:IsPurgable()
    return false
end

function modifier_ability_npc_apparition_snowman_hidden:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_apparition_snowman_hidden:IsStunDebuff()
    return false
end

function modifier_ability_npc_apparition_snowman_hidden:RemoveOnDeath()
    return false
end

function modifier_ability_npc_apparition_snowman_hidden:DestroyOnExpire()
    return true
end

function modifier_ability_npc_apparition_snowman_hidden:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():AddNoDraw()
end

function modifier_ability_npc_apparition_snowman_hidden:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveNoDraw()
end

function modifier_ability_npc_apparition_snowman_hidden:CheckState()
    return {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true
    }   
end