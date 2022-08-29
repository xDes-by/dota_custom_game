zuus_boss_nimbus = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell4","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell4", LUA_MODIFIER_MOTION_NONE )

function zuus_boss_nimbus:OnSpellStart()
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        local cloud = CreateUnitByName("npc_dota_zeus_cloud", unit:GetOrigin(), true, nil, nil, self:GetCaster():GetTeam())
        cloud:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_barrack1_spell4", {})
        cloud:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 7})
        local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", PATTACH_POINT, unit)
        ParticleManager:ReleaseParticleIndex(pfx)
        ApplyDamage({victim = unit,
        damage = unit:GetMaxHealth()* 0.05,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
    end
    EmitGlobalSound("Hero_Zuus.GodsWrath.PreCast.Arcana")
    local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_POINT, self:GetCaster())
    ParticleManager:ReleaseParticleIndex(pfx)
    ParticleManager:ReleaseParticleIndex(pfx)
end