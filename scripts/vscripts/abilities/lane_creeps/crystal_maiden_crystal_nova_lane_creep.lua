crystal_maiden_crystal_nova_lane_creep = class({})

LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_lane_creep", "abilities/lane_creeps/crystal_maiden_crystal_nova_lane_creep", LUA_MODIFIER_MOTION_NONE )

function crystal_maiden_crystal_nova_lane_creep:OnSpellStart()
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        unit:AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_lane_creep", {duration = self:GetSpecialValueFor("duration")})
        ApplyDamage({victim = unit,
        damage = self:GetSpecialValueFor("nova_damage"),
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
    end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCursorPosition() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self:GetSpecialValueFor("radius"), 3, self:GetSpecialValueFor("radius") ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self:GetCursorPosition(), "Hero_Crystal.CrystalNova", self:GetCaster() )
end

modifier_crystal_maiden_crystal_nova_lane_creep = class({})
--Classifications template
function modifier_crystal_maiden_crystal_nova_lane_creep:IsHidden()
    return true
end

function modifier_crystal_maiden_crystal_nova_lane_creep:IsDebuff()
    return true
end

function modifier_crystal_maiden_crystal_nova_lane_creep:IsPurgable()
    return true
end

function modifier_crystal_maiden_crystal_nova_lane_creep:RemoveOnDeath()
    return true
end

function modifier_crystal_maiden_crystal_nova_lane_creep:DestroyOnExpire()
    return true
end

function modifier_crystal_maiden_crystal_nova_lane_creep:OnCreated()
    self.movespeed_slow = self:GetAbility():GetSpecialValueFor("movespeed_slow") * 0.01
    self.attack = self:GetParent():GetAttackSpeed() * self:GetAbility():GetSpecialValueFor("attackspeed_slow") * -0.01
end

function modifier_crystal_maiden_crystal_nova_lane_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_crystal_maiden_crystal_nova_lane_creep:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_slow
end

function modifier_crystal_maiden_crystal_nova_lane_creep:GetModifierAttackSpeedBonus_Constant()
    return self.attack
end