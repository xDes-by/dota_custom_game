ability_sand_storm_boss = class({})

LinkLuaModifier("modifier_ability_sand_storm_boss", "abilities/bosses/sand/ability_sand_storm_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_ability_burrowstrike_boss", "abilities/bosses/sand/ability_burrowstrike_boss", LUA_MODIFIER_MOTION_NONE )
function ability_sand_storm_boss:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_sand_storm_boss", {duration = 80})
end

modifier_ability_sand_storm_boss = class({})
--Classifications template
function modifier_ability_sand_storm_boss:IsHidden()
    return false
end

function modifier_ability_sand_storm_boss:IsDebuff()
    return false
end

function modifier_ability_sand_storm_boss:IsPurgable()
    return false
end

function modifier_ability_sand_storm_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_sand_storm_boss:IsStunDebuff()
    return false
end

function modifier_ability_sand_storm_boss:RemoveOnDeath()
    return true
end

function modifier_ability_sand_storm_boss:DestroyOnExpire()
    return true
end

function modifier_ability_sand_storm_boss:OnCreated()
    if not IsServer() then
        return
    end
	self.mod = self:GetCaster():FindModifierByName("modifier_ability_caustic_boss")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	EmitSoundOn( "Ability.SandKing_SandStorm.loop", self:GetParent() )
    self:StartIntervalThink(0.2)
end

function modifier_ability_sand_storm_boss:OnIntervalThink()
    local pos = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(300, 700))
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, 150,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,unit in pairs(units) do
        local duration = 2.2
        target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = duration })

        target:AddNewModifier(self:GetCaster(), self, "modifier_generic_knockback_lua", {duration = 0.52, z = 350, IsStun = true})

        self.mod:OnAttackLanded({target = unit, attacker = self:GetCaster()})
        
        ApplyDamage({
            victim = unit,
            attacker = self:GetCaster(),
            damage = 50000,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
        })
    end
end

function modifier_ability_sand_storm_boss:OnDestroy()
    if not IsServer() then
        return
    end
    if self.effect_cast then
        ParticleManager:DestroyParticle( self.effect_cast, false )
	    ParticleManager:ReleaseParticleIndex( self.effect_cast )
        StopSoundOn( "Ability.SandKing_SandStorm.loop", self:GetParent() )
    end
end

function modifier_ability_sand_storm_boss:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
    }
end

function modifier_ability_sand_storm_boss:GetModifierTotal_ConstantBlock(data)
    if RollPercentage(50) then
        return -data.original_damage
    end
end
--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ability_sand_storm_boss:IsAura()
    return true
end

function modifier_ability_sand_storm_boss:GetModifierAura()
    return "modifier_ability_sand_storm_boss_aura_effect"
end

function modifier_ability_sand_storm_boss:GetAuraRadius()
    return self.radius
end

function modifier_ability_sand_storm_boss:GetAuraDuration()
    return 0.2
end

function modifier_ability_sand_storm_boss:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_sand_storm_boss:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_sand_storm_boss:GetAuraSearchFlags()
    return 0
end

modifier_ability_sand_storm_boss_aura_effect = class({})
--Classifications template
function modifier_ability_sand_storm_boss_aura_effect:IsHidden()
    return true
end

function modifier_ability_sand_storm_boss_aura_effect:IsDebuff()
    return true
end

function modifier_ability_sand_storm_boss_aura_effect:IsPurgable()
    return false
end

function modifier_ability_sand_storm_boss_aura_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_sand_storm_boss_aura_effect:IsStunDebuff()
    return false
end

function modifier_ability_sand_storm_boss_aura_effect:RemoveOnDeath()
    return true
end

function modifier_ability_sand_storm_boss_aura_effect:DestroyOnExpire()
    return true
end

function modifier_ability_sand_storm_boss_aura_effect:OnCreated()
    if not IsServer() then
        return
    end
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.damage = self.parent:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage") * FrameTime()
    self.multiplier = 1
    self:StartIntervalThink(FrameTime())
end

function modifier_ability_sand_storm_boss_aura_effect:OnIntervalThink()
    ApplyDamage({
        victim = self.parent,
        attacker = self.caster,
        damage = self.damage * self.multiplier,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = 0,
        ability = self.ability
    })
    self.multiplier = self.multiplier + 0.03
    local direction = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin())
    direction.z = 0
    direction = direction:Normalized()
    FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin() + direction, true)
end