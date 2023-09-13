ability_npc_snow_boss = class({})

LinkLuaModifier("modifier_ability_npc_snow_boss", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_VERTICAL)

function ability_npc_snow_boss:OnSpellStart()
    local direction = self:GetCaster():GetForwardVector()
    local pos = self:GetCaster():GetAbsOrigin()
    for i=1,3 do 
        local dir = RotatePosition( Vector(0,0,0), QAngle( 0, 120 * i, 0 ), direction )
        local unit = CreateUnitByName("npc_snow_boss_feeld_caster", pos + dir * 600, true, nil, nil, self:GetCaster():GetTeamNumber())
        unit:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_snow_boss", {duration = 5.6})
    end
end

modifier_ability_npc_snow_boss = class({})
--Classifications template
function modifier_ability_npc_snow_boss:IsHidden()
    return true
end

function modifier_ability_npc_snow_boss:IsDebuff()
    return false
end

function modifier_ability_npc_snow_boss:IsPurgable()
    return false
end

function modifier_ability_npc_snow_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_snow_boss:IsStunDebuff()
    return false
end

function modifier_ability_npc_snow_boss:RemoveOnDeath()
    return true
end

function modifier_ability_npc_snow_boss:DestroyOnExpire()
    return true
end

function modifier_ability_npc_snow_boss:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.pos = self.parent:GetAbsOrigin()
    self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_snow_boss:OnIntervalThink()
    local pos = self.pos + RandomVector(RandomFloat(100, 400))
    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden_persona/cm_persona_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(p, 0, pos)
    ParticleManager:ReleaseParticleIndex(p)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),pos,nil,300,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,0,false)
    for _,unit in pairs(enemies) do
        ApplyDamage({
            victim = unit,
            attacker = self.parent,
            damage = unit:GetHealth() * 0.2,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
end

function modifier_ability_npc_snow_boss:OnDestroy()
    UTIL_Remove(self.parent)
end

function modifier_ability_npc_snow_boss:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end