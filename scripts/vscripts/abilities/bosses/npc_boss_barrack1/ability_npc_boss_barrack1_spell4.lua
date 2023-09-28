ability_npc_boss_barrack1_spell4 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell4","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell4", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_barrack1_spell4:OnSpellStart()
    local damage_spell_persent = self:GetSpecialValueFor("damage_spell_persent") * 0.01
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        local cloud = CreateUnitByName("npc_dota_zeus_cloud", unit:GetOrigin(), true, nil, nil, self:GetCaster():GetTeam())
        cloud:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_barrack1_spell4", {})
        cloud:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 7})
        local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", PATTACH_POINT, unit)
        ParticleManager:ReleaseParticleIndex(pfx)
        ApplyDamage({victim = unit,
        damage = unit:GetMaxHealth()* damage_spell_persent * 2,
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

modifier_ability_npc_boss_barrack1_spell4 = class({})
--Classifications template
function modifier_ability_npc_boss_barrack1_spell4:IsHidden()
    return true
end

function modifier_ability_npc_boss_barrack1_spell4:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack1_spell4:OnCreated()
    EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetParent())
    local nimbus_interval = self:GetAbility():GetSpecialValueFor("nimbus_interval")
    self.bolt_radius = self:GetAbility():GetSpecialValueFor("bolt_radius")
    self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
    self.numbus_health_persent = self:GetAbility():GetSpecialValueFor("numbus_health_persent") * 0.01
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(pfx, 1, Vector(self.bolt_radius, 0, 0))
	self:AddParticle(pfx,false,false,-1,false,false)
    if IsClient() then
        return
    end
    local health = self:GetAbility():GetSpecialValueFor("health")
    self:GetParent():SetHealth(health)
    self:StartIntervalThink(nimbus_interval)
    self:OnIntervalThink()
end

function modifier_ability_npc_boss_barrack1_spell4:OnIntervalThink()
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.bolt_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        ApplyDamage({victim = enemies[1],
        damage = enemies[1]:GetMaxHealth() * self.numbus_health_persent,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
        enemies[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
        EmitSoundOn("Hero_Zuus.LightningBolt.Cloud", enemies[1])
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_POINT, self:GetParent())
        ParticleManager:SetParticleControl(pfx, 1, enemies[1]:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(pfx)
    end
end

function modifier_ability_npc_boss_barrack1_spell4:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACKED
    }
end

function modifier_ability_npc_boss_barrack1_spell4:OnAttacked(data)
    if IsClient() then
        return
    end
    if data.attacker:IsRealHero() and data.target == self:GetParent() then
        self:GetParent():SetHealth( self:GetParent():GetHealth() - 1 )
        if self:GetParent():GetHealth() == 0 then 
            self:GetParent():ForceKill(false)
        end
    end
end