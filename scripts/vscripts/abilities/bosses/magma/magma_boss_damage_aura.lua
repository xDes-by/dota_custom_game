magma_boss_damage_aura = class({})

LinkLuaModifier("modifier_magma_boss_damage_aura", "abilities/bosses/magma/magma_boss_damage_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magma_boss_damage_aura_aura_effect", "abilities/bosses/magma/magma_boss_damage_aura", LUA_MODIFIER_MOTION_NONE)

function magma_boss_damage_aura:GetIntrinsicModifierName()
    return "modifier_magma_boss_damage_aura"
end

modifier_magma_boss_damage_aura = class({})
--Classifications template
function modifier_magma_boss_damage_aura:IsHidden()
    return true
end

function modifier_magma_boss_damage_aura:IsDebuff()
    return false
end

function modifier_magma_boss_damage_aura:IsPurgable()
    return false
end

function modifier_magma_boss_damage_aura:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_magma_boss_damage_aura:IsStunDebuff()
    return false
end

function modifier_magma_boss_damage_aura:RemoveOnDeath()
    return false
end

function modifier_magma_boss_damage_aura:DestroyOnExpire()
    return false
end

function modifier_magma_boss_damage_aura:OnCreated()
    if not IsServer() then
        return
    end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 500, 0, 0 ) )
	self:AddParticle(effect_cast,false,false,-1,false,false)
	EmitSoundOn( "Hero_DoomBringer.ScorchedEarthAura", self:GetParent() )
end

function modifier_magma_boss_damage_aura:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf"
end

function modifier_magma_boss_damage_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_magma_boss_damage_aura:IsAura()
    return true
end

function modifier_magma_boss_damage_aura:GetModifierAura()
    return "modifier_magma_boss_damage_aura_aura_effect"
end

function modifier_magma_boss_damage_aura:GetAuraRadius()
    return 500
end

function modifier_magma_boss_damage_aura:GetAuraDuration()
    return 0.5
end

function modifier_magma_boss_damage_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_magma_boss_damage_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_magma_boss_damage_aura:GetAuraSearchFlags()
    return 0
end

modifier_magma_boss_damage_aura_aura_effect = class({})
--Classifications template
function modifier_magma_boss_damage_aura_aura_effect:IsHidden()
    return false
end

function modifier_magma_boss_damage_aura_aura_effect:IsDebuff()
    return true
end

function modifier_magma_boss_damage_aura_aura_effect:IsPurgable()
    return true
end

function modifier_magma_boss_damage_aura_aura_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_magma_boss_damage_aura_aura_effect:IsStunDebuff()
    return true
end

function modifier_magma_boss_damage_aura_aura_effect:RemoveOnDeath()
    return true
end

function modifier_magma_boss_damage_aura_aura_effect:DestroyOnExpire()
    return true
end

function modifier_magma_boss_damage_aura_aura_effect:DestroyOnExpire()
    return true
end

function modifier_magma_boss_damage_aura_aura_effect:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.damage = self:GetAbility():GetSpecialValueFor("damage") * 0.2
    self.abi = self:GetAbility()
    self:StartIntervalThink(0.2)
end

function modifier_magma_boss_damage_aura_aura_effect:OnIntervalThink()
    ApplyDamage({
        victim = self.parent,
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = 0,
        ability = self.abi
    })
end