modifier_npc_dota_hero_vengefulspirit_str11 = class({})

function modifier_npc_dota_hero_vengefulspirit_str11:IsHidden()
	return true
end

function modifier_npc_dota_hero_vengefulspirit_str11:IsPurgable()
	return false
end

function modifier_npc_dota_hero_vengefulspirit_str11:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_vengefulspirit_str11:OnCreated( kv )
    if IsServer() then
        self.clone = EntIndexToHScript( kv.clone )
        self.caster = self:GetCaster()
    end
end

function modifier_npc_dota_hero_vengefulspirit_str11:OnRefresh( kv )
    self:OnCreated( kv )
end

function modifier_npc_dota_hero_vengefulspirit_str11:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_npc_dota_hero_vengefulspirit_str11:OnAttackLanded( params )
    local heal_amount = params.damage * 0.15 / 2
    self.caster:Heal(heal_amount, self:GetAbility())
    self:PlayEffect(self.caster)
    if self.clone and self.clone:IsAlive() then
        self.clone:Heal(heal_amount, self:GetAbility())
        self:PlayEffect(self.clone)
    end
end

function modifier_npc_dota_hero_vengefulspirit_str11:PlayEffect(target)
    local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end