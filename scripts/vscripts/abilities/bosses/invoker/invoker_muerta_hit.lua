invoker_muerta_hit = class({})

LinkLuaModifier("modifier_invoker_muerta_hit", "abilities/bosses/invoker/invoker_muerta_hit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_muerta_hit_effect", "abilities/bosses/invoker/invoker_muerta_hit", LUA_MODIFIER_MOTION_NONE)

function invoker_muerta_hit:GetIntrinsicModifierName()
    return "modifier_invoker_muerta_hit"
end

modifier_invoker_muerta_hit = class({})
--Classifications template
function modifier_invoker_muerta_hit:IsHidden()
    return true
end

function modifier_invoker_muerta_hit:IsDebuff()
    return false
end

function modifier_invoker_muerta_hit:IsPurgable()
    return false
end

function modifier_invoker_muerta_hit:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_invoker_muerta_hit:IsStunDebuff()
    return false
end

function modifier_invoker_muerta_hit:RemoveOnDeath()
    return false
end

function modifier_invoker_muerta_hit:DestroyOnExpire()
    return false
end

function modifier_invoker_muerta_hit:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_invoker_muerta_hit:OnAttackLanded(data)
    if data.attacker == self:GetCaster() and self:GetAbility():IsCooldownReady() then
        data.target:AddNewModifier(self:GetCaster(), self, "modifier_invoker_muerta_hit_effect", {duration = 3})
        self:GetAbility():UseResources(false, false, false, true)
    end
end

modifier_invoker_muerta_hit_effect = class({})

--Classifications template
function modifier_invoker_muerta_hit_effect:IsHidden()
    return false
end

function modifier_invoker_muerta_hit_effect:IsDebuff()
    return false
end

function modifier_invoker_muerta_hit_effect:IsPurgable()
    return false
end

function modifier_invoker_muerta_hit_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_invoker_muerta_hit_effect:IsStunDebuff()
    return false
end

function modifier_invoker_muerta_hit_effect:RemoveOnDeath()
    return false
end

function modifier_invoker_muerta_hit_effect:DestroyOnExpire()
    return true
end

function modifier_invoker_muerta_hit_effect:OnCreated()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	self:AddParticle(effect_cast, false, false, -1, false, false)
    if not IsServer() then
        return
    end
	EmitSoundOn( "Hero_DarkWillow.Shadow_Realm", self:GetParent() )
    ProjectileManager:ProjectileDodge(self:GetParent())
end

function modifier_invoker_muerta_hit_effect:OnDestroy()
    if not IsServer() then
        return
    end
	StopSoundOn( "Hero_DarkWillow.Shadow_Realm", self:GetParent() )
end

function modifier_invoker_muerta_hit_effect:CheckState()
    return {
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }
end

function modifier_invoker_muerta_hit_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end


