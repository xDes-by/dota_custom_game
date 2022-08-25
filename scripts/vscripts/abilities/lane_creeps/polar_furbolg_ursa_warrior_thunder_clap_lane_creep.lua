polar_furbolg_ursa_warrior_thunder_clap_lane_creep = class({})

LinkLuaModifier( "modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep", "abilities/lane_creeps/polar_furbolg_ursa_warrior_thunder_clap_lane_creep", LUA_MODIFIER_MOTION_NONE )

function polar_furbolg_ursa_warrior_thunder_clap_lane_creep:OnSpellStart()
    local radius = self:GetSpecialValueFor("radius")
    local pos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 50 
    local pfx = ParticleManager:CreateParticle("particles/neutral_fx/ursa_thunderclap.vpcf", PATTACH_POINT, self:GetCaster())
    ParticleManager:SetParticleControl(pfx, 0, pos)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pfx)
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        unit:AddNewModifier(self:GetCaster(), self, "modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep", {duration = self:GetSpecialValueFor("duration")})
    end
	EmitSoundOn( "n_creep_Ursa.Clap", self:GetCaster() )
end

modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep = class({})
--Classifications template
function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:IsHidden()
    return false
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:IsDebuff()
    return true
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:IsPurgable()
    return true
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:RemoveOnDeath()
    return true
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:DestroyOnExpire()
    return true
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:OnCreated()
    self.movespeed_slow = self:GetAbility():GetSpecialValueFor("movespeed_slow") * 0.01
    self.attack = self:GetParent():GetAttackSpeed() * self:GetAbility():GetSpecialValueFor("attackspeed_slow") * -0.01
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_slow
end

function modifier_polar_furbolg_ursa_warrior_thunder_clap_lane_creep:GetModifierAttackSpeedBonus_Constant()
    return self.attack
end