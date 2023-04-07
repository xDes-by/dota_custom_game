LinkLuaModifier("modifier_npc_dota_hero_medusa_agi_last", "heroes/hero_medusa/x2_damage", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_medusa_agi_last = class({})

function npc_dota_hero_medusa_agi_last:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_medusa_agi_last"
end

if modifier_npc_dota_hero_medusa_agi_last == nil then 
    modifier_npc_dota_hero_medusa_agi_last = class({})
end

function modifier_npc_dota_hero_medusa_agi_last:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_npc_dota_hero_medusa_agi_last:IsHidden()
	return true
end

function modifier_npc_dota_hero_medusa_agi_last:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_medusa_agi_last:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_medusa_agi_last:OnCreated(kv)
    self.radius = self:GetCaster():Script_GetAttackRange()
    self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()
end

function modifier_npc_dota_hero_medusa_agi_last:OnIntervalThink()
    local ability = self:GetCaster():FindAbilityByName( "medusa_split_shot_lua" )
    if ability ~= nil and ability:GetLevel() >= 1 then
        local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            self:GetCaster():GetOrigin(),
            nil,
            self.radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            0,
            false
        )
        if #enemies < 2 and ability:GetToggleState() then
            self:SetStackCount(100)
        else 
            self:SetStackCount(0)
        end
    end
end

function modifier_npc_dota_hero_medusa_agi_last:GetModifierDamageOutgoing_Percentage(params)
    return self:GetStackCount()
end