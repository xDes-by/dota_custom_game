ability_caustic_boss = class({})

function ability_caustic_boss:GetIntrinsicModifierName()
    return "modifier_ability_caustic_boss"
end

modifier_ability_caustic_boss = class({})

LinkLuaModifier("modifier_ability_caustic_boss", "abilities/bosses/sand/ability_caustic_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_caustic_boss_debuff", "abilities/bosses/sand/ability_caustic_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_caustic_boss:IsHidden()
    return true
end

function modifier_ability_caustic_boss:IsDebuff()
    return false
end

function modifier_ability_caustic_boss:IsPurgable()
    return false
end

function modifier_ability_caustic_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_caustic_boss:IsStunDebuff()
    return false
end

function modifier_ability_caustic_boss:RemoveOnDeath()
    return false
end

function modifier_ability_caustic_boss:DestroyOnExpire()
    return false
end

function modifier_ability_caustic_boss:OnCreated()
    self.parent = self:GetParent()
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_ability_caustic_boss:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_ability_caustic_boss:OnAttackLanded(data)
    if data.attacker ~= self.parent then
        return
    end
    data.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_ability_caustic_boss_debuff", {duration = self.duration})
end


modifier_ability_caustic_boss_debuff = class({})
--Classifications template
function modifier_ability_caustic_boss_debuff:IsHidden()
    return false
end

function modifier_ability_caustic_boss_debuff:IsDebuff()
    return true
end

function modifier_ability_caustic_boss_debuff:IsPurgable()
    return true
end

function modifier_ability_caustic_boss_debuff:IsPurgeException()
    return true
end

-- Optional Classifications
function modifier_ability_caustic_boss_debuff:IsStunDebuff()
    return false
end

function modifier_ability_caustic_boss_debuff:RemoveOnDeath()
    return true
end

function modifier_ability_caustic_boss_debuff:DestroyOnExpire()
    return true
end

function modifier_ability_caustic_boss_debuff:OnCreated()
    self.parent = self:GetParent()
    self.damage = self:GetAbility():GetSpecialValueFor("damage") / 100
end

function modifier_ability_caustic_boss_debuff:OnRefresh()
    self:OnDestroy()
end

function modifier_ability_caustic_boss_debuff:OnDestroy()
    if not IsServer() then
        return
    end
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 300,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,u in pairs(units) do
        ApplyDamage({
            victim = u,
            attacker = self:GetCaster(),
            damage = u:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Ability.SandKing_CausticFinale", self:GetParent() )
end

function modifier_ability_caustic_boss_debuff:GetEffectName()
	return "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf"
end

function modifier_ability_caustic_boss_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end