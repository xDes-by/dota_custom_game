magma_boss_channeling_meteors = class({})

LinkLuaModifier("modifier_channeling_meteor", "abilities/bosses/magma/magma_boss_channeling_meteors", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_channeling_meteor_thinker", "abilities/bosses/magma/magma_boss_channeling_meteors", LUA_MODIFIER_MOTION_NONE)

function magma_boss_channeling_meteors:OnSpellStart()
    self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_channeling_meteor", {duration = self:GetSpecialValueFor("duration")})
end

function magma_boss_channeling_meteors:OnChannelFinish()
    self.mod:Destroy()
end

function magma_boss_channeling_meteors:GetChannelAnimation()
    return ACT_DOTA_GENERIC_CHANNEL_1
end

modifier_channeling_meteor = class({})
--Classifications template
function modifier_channeling_meteor:IsHidden()
    return true
end

function modifier_channeling_meteor:IsDebuff()
    return false
end

function modifier_channeling_meteor:IsPurgable()
    return false
end

function modifier_channeling_meteor:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_channeling_meteor:IsStunDebuff()
    return false
end

function modifier_channeling_meteor:RemoveOnDeath()
    return true
end

function modifier_channeling_meteor:DestroyOnExpire()
    return true
end

function modifier_channeling_meteor:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
end

function modifier_channeling_meteor:OnIntervalThink()
    CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_channeling_meteor_thinker", {}, self:GetParent():GetOrigin() + RandomVector(RandomInt(300,700)), self:GetCaster():GetTeamNumber(), false)
end



modifier_channeling_meteor_thinker = class({})

function modifier_channeling_meteor_thinker:IsHidden()
	return true
end

function modifier_channeling_meteor_thinker:OnCreated( kv )
	if IsServer() then
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = 1.3
		
		self.interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
		

		-- variables
		self.fallen = false

		self:StartIntervalThink( self.delay )

		self:PlayEffects1()
	end
end

function modifier_channeling_meteor_thinker:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( "Hero_Invoker.ChaosMeteor.Loop", self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.ChaosMeteor.Destroy", self:GetCaster() )
	end
end

function modifier_channeling_meteor_thinker:OnIntervalThink()
	if not self.fallen then
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
        self:Destroy()
	end
end

function modifier_channeling_meteor_thinker:Burn()
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = enemy:GetMaxHealth() * 0.1,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = 0,
		}
		ApplyDamage( self.damageTable )
	end
end

function modifier_channeling_meteor_thinker:PlayEffects1()
	local effect_cast = ParticleManager:CreateParticle( "particles/boses/magma_meteor.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, 1000 ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, 0) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self.caster_origin, "Hero_Invoker.ChaosMeteor.Cast", self:GetCaster() )
end
