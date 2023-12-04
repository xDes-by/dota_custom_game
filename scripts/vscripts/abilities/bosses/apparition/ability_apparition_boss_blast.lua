ability_apparition_boss_blast = class({})

LinkLuaModifier( "modifier_ability_apparition_boss_blast", "abilities/bosses/apparition/ability_apparition_boss_blast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_apparition_boss_blast_tick", "abilities/bosses/apparition/ability_apparition_boss_blast", LUA_MODIFIER_MOTION_NONE )

function ability_apparition_boss_blast:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_apparition_boss_blast", {duration = 8})
end

modifier_ability_apparition_boss_blast = class({})
--Classifications template
function modifier_ability_apparition_boss_blast:IsHidden()
    return true
end

function modifier_ability_apparition_boss_blast:IsDebuff()
    return false
end

function modifier_ability_apparition_boss_blast:IsPurgable()
    return false
end

function modifier_ability_apparition_boss_blast:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_apparition_boss_blast:IsStunDebuff()
    return false
end

function modifier_ability_apparition_boss_blast:RemoveOnDeath()
    return true
end

function modifier_ability_apparition_boss_blast:DestroyOnExpire()
    return true
end

function modifier_ability_apparition_boss_blast:OnCreated()
    if not IsServer() then
        return
    end
    self.count = 1
    self.part = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_marker.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.part, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.part, 1, Vector(self.count * 150, 1, 1))
    self.ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.ice_blast_particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.ice_blast_particle, 1, Vector(1,1,1))
    ParticleManager:SetParticleControl(self.ice_blast_particle, 5, Vector(2, 0, 0))
    ParticleManager:ReleaseParticleIndex(self.ice_blast_particle)
    EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Tracker", self:GetCaster())
    self.count = self.count + 1
    self:StartIntervalThink(2)
end

function modifier_ability_apparition_boss_blast:OnIntervalThink()
    if self.part then
        ParticleManager:DestroyParticle(self.part, false)
        ParticleManager:ReleaseParticleIndex(self.part)
    end
    EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Ancient_Apparition.IceBlast.Target", self:GetCaster())
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.count * 150,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,u in pairs(units) do
        u:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.5})
        u:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.5})
        ApplyDamage({
            victim = u,
            attacker = self:GetCaster(),
            damage = u:GetMaxHealth() * 0.1,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
    if self:GetRemainingTime() > 1 then
        self.part = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_marker.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(self.part, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(self.part, 1, Vector(self.count * 150, 1, 1))
        self.ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(self.ice_blast_particle, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(self.ice_blast_particle, 1, Vector(1,1,1))
        ParticleManager:SetParticleControl(self.ice_blast_particle, 5, Vector(2, 0, 0))
        ParticleManager:ReleaseParticleIndex(self.ice_blast_particle)
        self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Cast")
        self.count = self.count + 1
    end
end

function modifier_ability_apparition_boss_blast:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

modifier_ability_apparition_boss_blast_tick = class({})

function modifier_ability_apparition_boss_blast_tick:IsDebuff()		return true end
function modifier_ability_apparition_boss_blast_tick:IsPurgable()	return false end

function modifier_ability_apparition_boss_blast_tick:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_ability_apparition_boss_blast_tick:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_ability_apparition_boss_blast_tick:OnCreated(params)
	if not IsServer() then return end
	
	self.dot_damage		= self:GetParent():GetMaxHealth() * 0.01
	self.kill_pct		= 10
	
	self.caster = self:GetCaster()
	
	self.damage_table	= {
		victim 			= self:GetParent(),
		damage 			= self.dot_damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.caster,
		ability 		= self:GetAbility()
	}
	
	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_ability_apparition_boss_blast_tick:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_ability_apparition_boss_blast_tick:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")

	ApplyDamage(self.damage_table)
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.dot_damage, nil)
end

function modifier_ability_apparition_boss_blast_tick:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	}
end

function modifier_ability_apparition_boss_blast_tick:GetDisableHealing()
	return 1
end

function modifier_ability_apparition_boss_blast_tick:OnTakeDamageKillCredit(keys)
	if keys.target == self:GetParent() and (self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 <= self.kill_pct then
		if keys.attacker == self:GetParent() and not self:GetParent():IsInvulnerable() then
			self:GetParent():Kill(self:GetAbility(), self.caster)
		else
			self:GetParent():Kill(self:GetAbility(), keys.attacker)
		end
		
		if not self:GetParent():IsAlive() then
			local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(ice_blast_particle)
		end
	end
end