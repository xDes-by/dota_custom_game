ability_npc_titan_boss_spirit_passive = class({})

function ability_npc_titan_boss_spirit_passive:GetIntrinsicModifierName()
    return "modifier_ability_npc_titan_boss_spirit_passive"
end

modifier_ability_npc_titan_boss_spirit_passive = class({})

LinkLuaModifier("modifier_ability_npc_titan_boss_spirit_passive", "abilities/bosses/titan/ability_npc_titan_boss_spirit_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_titan_boss_spirit_passive_bonus_damage", "abilities/bosses/titan/ability_npc_titan_boss_spirit_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_titan_boss_spirit_passive_debuff", "abilities/bosses/titan/ability_npc_titan_boss_spirit_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_titan_boss_spirit_passive_return_stirit", "abilities/bosses/titan/ability_npc_titan_boss_spirit_passive", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_titan_boss_spirit_passive:IsHidden()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_spirit_passive:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive:RemoveOnDeath()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive:DestroyOnExpire()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive:OnCreated()
    self.parent = self:GetParent()
end

function modifier_ability_npc_titan_boss_spirit_passive:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_ability_npc_titan_boss_spirit_passive:OnAttackLanded(data)
    if data.target ~= self.parent then
        return
    end
    if RollPercentage(3) then
        local unit = CreateUnitByName("npc_elder_spirit", data.attacker:GetAbsOrigin(), false, nil, nil, self.parent:GetTeamNumber())
        unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_ability_npc_titan_boss_spirit_passive_return_stirit", {})
    end
end

modifier_ability_npc_titan_boss_spirit_passive_return_stirit = class({})

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:IsHidden()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:RemoveOnDeath()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:DestroyOnExpire()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.tbl = {}
    self:StartIntervalThink(FrameTime())
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 150,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,unit in pairs(units) do
        if not self.tbl[unit] then
            self.tbl[unit] = true
            unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_ability_npc_titan_boss_spirit_passive_debuff", {duration = 6})
        end
    end
    self.parent:MoveToNPC(self:GetCaster())
    if (self.parent:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() < 150 then
        local stacks = 0 
        for unit,_ in pairs(self.tbl) do
            if unit:IsRealHero() then
                stacks = stacks + 10
            else
                stacks = stacks + 1
            end
        end
        self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_titan_boss_spirit_passive_bonus_damage", {stacks = stacks, duration = 15})
        UTIL_Remove(self.parent)
    end
end

function modifier_ability_npc_titan_boss_spirit_passive_return_stirit:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

modifier_ability_npc_titan_boss_spirit_passive_bonus_damage = class({})
--Classifications template
function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:IsHidden()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:RemoveOnDeath()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:DestroyOnExpire()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:OnCreated(data)
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self:SetStackCount(data.stacks)
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount() * 1000
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_ability_npc_titan_boss_spirit_passive_bonus_damage:GetModifierMoveSpeedBonus_Percentage()
    return self:GetStackCount()
end

modifier_ability_npc_titan_boss_spirit_passive_debuff = class({})
--Classifications template
function modifier_ability_npc_titan_boss_spirit_passive_debuff:IsHidden()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:IsDebuff()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:IsPurgable()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:IsPurgeException()
    return true
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_spirit_passive_debuff:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:RemoveOnDeath()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:DestroyOnExpire()
    return true
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.armor = self.parent:GetPhysicalArmorValue(true) * -0.5
    self.magic = -50
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:GetModifierPhysicalArmorBonus()
    return self.armor
end

function modifier_ability_npc_titan_boss_spirit_passive_debuff:GetModifierMagicalResistanceBonus()
    return self.magic
end

