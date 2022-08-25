venomancer_venomous_gale_lane_creep = class({})

LinkLuaModifier( "modifier_venomancer_venomous_gale_lane_creep", "abilities/lane_creeps/venomancer_venomous_gale_lane_creep", LUA_MODIFIER_MOTION_NONE )

function venomancer_venomous_gale_lane_creep:OnSpellStart()
    local direction = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
    local info = {
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),

		bDeleteOnHit = false,

		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

		EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		fDistance = self:GetSpecialValueFor("distanse"),
		fStartRadius = self:GetSpecialValueFor("radius"),
		fEndRadius = self:GetSpecialValueFor("radius"),
		vVelocity = direction * self:GetSpecialValueFor("distanse"),
	}
	ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOn( "Hero_Venomancer.VenomousGale", self:GetCaster() )
end

function venomancer_venomous_gale_lane_creep:OnProjectileHit(hTarget, vLocation)
    if hTarget then
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( "Hero_Venomancer.VenomousGale", hTarget )
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_venomancer_venomous_gale_lane_creep", {duration = self:GetSpecialValueFor("duration")})
        ApplyDamage({victim = hTarget,
        damage = self:GetSpecialValueFor("strike_damage"),
        damage_type = self:GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
    end
end

modifier_venomancer_venomous_gale_lane_creep = class({})
--Classifications template
function modifier_venomancer_venomous_gale_lane_creep:IsHidden()
    return false
end

function modifier_venomancer_venomous_gale_lane_creep:IsDebuff()
    return true
end

function modifier_venomancer_venomous_gale_lane_creep:IsPurgable()
    return true
end

function modifier_venomancer_venomous_gale_lane_creep:RemoveOnDeath()
    return true
end

function modifier_venomancer_venomous_gale_lane_creep:DestroyOnExpire()
    return true
end

function modifier_venomancer_venomous_gale_lane_creep:OnCreated()
    self.movespeed_slow = self:GetAbility():GetSpecialValueFor("movespeed_slow") * 0.01
    self.damage = self:GetAbility():GetSpecialValueFor("tick_damage")
    if IsClient() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_venomancer_venomous_gale_lane_creep:OnIntervalThink()
    ApplyDamage({victim = self:GetParent(),
    damage = self.damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
end

function modifier_venomancer_venomous_gale_lane_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_venomancer_venomous_gale_lane_creep:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_slow * self:GetRemainingTime() / self:GetDuration()
end

function modifier_venomancer_venomous_gale_lane_creep:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf"
end

function modifier_venomancer_venomous_gale_lane_creep:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end