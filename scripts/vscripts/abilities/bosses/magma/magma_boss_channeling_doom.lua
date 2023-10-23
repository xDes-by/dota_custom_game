magma_boss_channeling_doom = class({})

LinkLuaModifier("modifier_channeling_doom", "abilities/bosses/magma/magma_boss_channeling_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_channeling_doom_doomed", "abilities/bosses/magma/magma_boss_channeling_doom", LUA_MODIFIER_MOTION_NONE)

function magma_boss_channeling_doom:OnSpellStart()
    self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_channeling_doom", {})
end

function magma_boss_channeling_doom:OnChannelFinish()
    self.mod:Destroy()
end

modifier_channeling_doom = class({})
--Classifications template
function modifier_channeling_doom:IsHidden()
    return true
end

function modifier_channeling_doom:IsDebuff()
    return false
end

function modifier_channeling_doom:IsPurgable()
    return false
end

function modifier_channeling_doom:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_channeling_doom:IsStunDebuff()
    return false
end

function modifier_channeling_doom:RemoveOnDeath()
    return true
end

function modifier_channeling_doom:DestroyOnExpire()
    return true
end

function modifier_channeling_doom:OnCreated()
    if not IsServer() then
        return
    end
    self.duration = self:GetAbility():GetSpecialValueFor("doom_duration")
    self:StartIntervalThink(1)
end

function modifier_channeling_doom:OnDestroy()
    if not IsServer() then
        return
    end
end

function modifier_channeling_doom:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 700,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #units == 0 then
        return
    end
    for _,unit in pairs(units) do
        if not unit:HasModifier("modifier_channeling_doom_doomed") then
            unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_channeling_doom_doomed", {duration = self.duration})
            return
        end
    end
end

function modifier_channeling_doom:CheckState()
    return {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }
end

function modifier_channeling_doom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }
end

function modifier_channeling_doom:GetActivityTranslationModifiers()
    return "doom_2021_taunt"
end

function modifier_channeling_doom:GetOverrideAnimation()
    return ACT_DOTA_TAUNT
end

function modifier_channeling_doom:GetOverrideAnimationRate()
    return 0.6
end

modifier_channeling_doom_doomed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_channeling_doom_doomed:IsHidden()
	return false
end

function modifier_channeling_doom_doomed:IsDebuff()
	return true
end

function modifier_channeling_doom_doomed:IsStunDebuff()
	return false
end

function modifier_channeling_doom_doomed:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_channeling_doom_doomed:OnCreated( kv )
	local damage = self:GetParent():GetMaxHealth() * 0.1
	self.interval = 1
	self.check_radius = 700

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(),
	}
	ApplyDamage( self.damageTable )

	self:StartIntervalThink( self.interval )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	self:AddParticle(effect_cast, false, false, MODIFIER_PRIORITY_SUPER_ULTRA, false, false )

	EmitSoundOn("Hero_DoomBringer.Doom", self:GetParent() )
end

function modifier_channeling_doom_doomed:OnRefresh( kv )
	local damage = self:GetParent():GetMaxHealth() * 0.1
	if not IsServer() then return end
	self.damageTable.damage = damage

	EmitSoundOn( "Hero_DoomBringer.Doom", self:GetParent() )
end

function modifier_channeling_doom_doomed:OnDestroy()
	if not IsServer() then return end
	StopSoundOn( "Hero_DoomBringer.Doom", self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_channeling_doom_doomed:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_channeling_doom_doomed:OnIntervalThink()
	-- Apply damage
	ApplyDamage( self.damageTable )

    local distance = (self:GetParent():GetOrigin()-self:GetCaster():GetOrigin()):Length2D()
    if distance<self.check_radius then
        -- increment duration
        self:SetDuration( self:GetRemainingTime() + 2, true )
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_channeling_doom_doomed:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function modifier_channeling_doom_doomed:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
