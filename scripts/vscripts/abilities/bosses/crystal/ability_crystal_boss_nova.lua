ability_crystal_boss_nova = class({})

LinkLuaModifier("modifier_ability_crystal_boss_nova", "abilities/bosses/crystal/ability_crystal_boss_nova", LUA_MODIFIER_MOTION_NONE)

function ability_crystal_boss_nova:OnSpellStart()
    local pos = self:GetCaster():GetAbsOrigin()
    local dur = self:GetSpecialValueFor("duration")
    if RandomInt(1, 2) == 1 then
        direction = self:GetCaster():GetForwardVector() * 600
    else
        direction = self:GetCaster():GetForwardVector() * -600
    end
    for i=1,3 do
        direction = RotatePosition(Vector(0,0,0), QAngle(0, 90 * i, 0), direction)
        local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos + direction, nil, 600,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _,unit in pairs(units) do
            unit:AddNewModifier(self:GetCaster(), self, "modifier_ability_crystal_boss_nova", {duration = dur})
            ApplyDamage({
                victim = unit,
                attacker = self:GetCaster(),
                damage = unit:GetMaxHealth() * 0.1,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = 0,
                ability = self
            })
        end
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( effect_cast, 0, pos + direction )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( 600, 3, 600 ) )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOnLocationWithCaster( pos + direction, "Hero_Crystal.CrystalNova", self:GetCaster() )
    end
end

modifier_ability_crystal_boss_nova = class({})

function modifier_ability_crystal_boss_nova:IsHidden()
	return false
end

function modifier_ability_crystal_boss_nova:IsDebuff()
	return true
end

function modifier_ability_crystal_boss_nova:IsPurgable()
	return true
end

function modifier_ability_crystal_boss_nova:OnCreated( kv )
	self.as_slow = self:GetParent():GetAttackSpeed() * -0.7
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
end

function modifier_ability_crystal_boss_nova:OnRefresh( kv )
	self.as_slow = self:GetParent():GetAttackSpeed() * -0.7
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )	
end

function modifier_ability_crystal_boss_nova:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_ability_crystal_boss_nova:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_ability_crystal_boss_nova:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_ability_crystal_boss_nova:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_ability_crystal_boss_nova:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end