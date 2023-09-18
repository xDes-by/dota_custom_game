ability_npc_patrool2_zoomby_alt_lifesteal = class({})

function ability_npc_patrool2_zoomby_alt_lifesteal:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool2_zoomby_alt_lifesteal"
end

modifier_ability_npc_patrool2_zoomby_alt_lifesteal = class({})

LinkLuaModifier("modifier_ability_npc_patrool2_zoomby_alt_lifesteal", "abilities/lane_creeps/ability_npc_patrool2_zoomby_alt_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:IsHidden()
    return true
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:IsDebuff()
    return false
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:IsPurgable()
    return false
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:RemoveOnDeath()
    return false
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:OnCreated()
    self.parent = self:GetParent()
    self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal") * 0.01
    self.bush_chance = self:GetAbility():GetSpecialValueFor("bush_chance")
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:OnDestroy()

end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_patrool2_zoomby_alt_lifesteal:GetModifierProcAttack_Feedback(data)
    self.parent:HealWithParams(data.damage * self.lifesteal, self:GetAbility(), true, true, self.parent, false)
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, data.target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
    if RandomInt(1, 100) < self.bush_chance then
        data.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_stunned", {duration = 1.5})
        local d = data.target:GetMaxHealth() * 0.05
        ApplyDamage({
            victim = data.target,
            attacker = data.attacker,
            damage = d,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
        SendOverheadEventMessage( self.parent, OVERHEAD_ALERT_DAMAGE, self.parent, d, nil )
    end
end