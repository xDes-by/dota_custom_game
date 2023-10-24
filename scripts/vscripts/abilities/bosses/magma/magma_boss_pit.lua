magma_boss_pit = class({})
LinkLuaModifier( "modifier_magma_boss_pit", "abilities/bosses/magma/magma_boss_pit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magma_boss_pit_cooldown", "abilities/bosses/magma/magma_boss_pit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magma_boss_pit_thinker", "abilities/bosses/magma/magma_boss_pit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magma_boss_firestorm_thinker", "abilities/bosses/magma/magma_boss_pit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magma_boss_firestorm", "abilities/bosses/magma/magma_boss_pit", LUA_MODIFIER_MOTION_NONE )

function magma_boss_pit:OnAbilityPhaseStart()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )

	self.effect_cast = ParticleManager:CreateParticleForTeam( "particles/units/heroes/heroes_underlord/underlord_pitofmalice_pre.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 1, 1 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationForAllies( point, "Hero_AbyssalUnderlord.PitOfMalice.Start", self:GetCaster() )

	self.effect_cast1 = ParticleManager:CreateParticleForTeam( "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast1, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast1, 1, Vector( 2, 2, 2 ) )
	EmitSoundOnLocationWithCaster( point, "Hero_AbyssalUnderlord.Firestorm.Start", self:GetCaster() )
	return true
end

function magma_boss_pit:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
	ParticleManager:DestroyParticle( self.effect_cast1, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast1 )

end

function magma_boss_pit:OnSpellStart()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	ParticleManager:DestroyParticle( self.effect_cast1, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast1 )

	local duration = self:GetSpecialValueFor( "pit_duration" )
	CreateModifierThinker(self:GetCaster(),self,"modifier_magma_boss_pit_thinker",{ duration = duration },self:GetCursorPosition(),self:GetCaster():GetTeamNumber(),false)
	CreateModifierThinker(self:GetCaster(), self, "modifier_magma_boss_firestorm_thinker", {duration = duration}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	
end

modifier_magma_boss_pit_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magma_boss_pit_thinker:IsHidden()
	return false
end

function modifier_magma_boss_pit_thinker:IsDebuff()
	return false
end

function modifier_magma_boss_pit_thinker:IsPurgable()
	return false
end

function modifier_magma_boss_pit_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.pit_damage = self:GetAbility():GetSpecialValueFor( "pit_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "ensnare_duration" )

	if not IsServer() then 
        return 
    end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self:StartIntervalThink( FrameTime() )
	self:OnIntervalThink()

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/underlord_pitofmalice.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetDuration(), 0, 0 ) )
	self:AddParticle(effect_cast, false, false, -1, false, false)
	EmitSoundOn( "Hero_AbyssalUnderlord.PitOfMalice", self:GetParent() )
end

function modifier_magma_boss_pit_thinker:OnDestroy()
	if not IsServer() then 
        return 
    end
	UTIL_Remove( self:GetParent() )
end

function modifier_magma_boss_pit_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		local modifier = enemy:FindModifierByNameAndCaster( "modifier_magma_boss_pit_cooldown", self:GetCaster() )
		if not modifier then
			enemy:AddNewModifier(self.caster, self:GetAbility(), "modifier_magma_boss_pit", { duration = self.duration })
		end
	end
end

modifier_magma_boss_pit_cooldown = class({})

function modifier_magma_boss_pit_cooldown:IsHidden()
	return true
end

function modifier_magma_boss_pit_cooldown:IsDebuff()
	return true
end

function modifier_magma_boss_pit_cooldown:IsPurgable()
	return false
end

function modifier_magma_boss_pit_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end


modifier_magma_boss_pit = class({})

function modifier_magma_boss_pit:IsHidden()
	return false
end

function modifier_magma_boss_pit:IsDebuff()
	return true
end

function modifier_magma_boss_pit:IsStunDebuff()
	return false
end

function modifier_magma_boss_pit:IsPurgable()
	return true
end

function modifier_magma_boss_pit:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_magma_boss_pit:OnCreated( kv )
	local interval = self:GetAbility():GetSpecialValueFor( "pit_interval" )

	if not IsServer() then return end

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_magma_boss_pit_cooldown", {duration = interval,})

	local hero = self:GetParent():IsHero()
	local sound_cast = "Hero_AbyssalUnderlord.Pit.TargetHero"
	if not hero then
		sound_cast = "Hero_AbyssalUnderlord.Pit.Target"
	end
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_magma_boss_pit:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}
end

function modifier_magma_boss_pit:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_pitofmalice_stun.vpcf"
end

function modifier_magma_boss_pit:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_magma_boss_firestorm_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magma_boss_firestorm_thinker:IsHidden()
	return true
end

function modifier_magma_boss_firestorm_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_magma_boss_firestorm_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage = self.ability:GetSpecialValueFor( "wave_damage" )
	local delay = self.ability:GetSpecialValueFor( "first_wave_delay" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.count = self.ability:GetSpecialValueFor( "wave_count" )
	self.interval = self.ability:GetSpecialValueFor( "wave_interval" )

	self.burn_duration = self.ability:GetSpecialValueFor( "burn_duration" )
	self.burn_interval = self.ability:GetSpecialValueFor( "burn_interval" )
	self.burn_damage = self.ability:GetSpecialValueFor( "burn_damage" )

	if not IsServer() then return end

	-- init
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = self.caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( delay )
end

function modifier_magma_boss_firestorm_thinker:OnRefresh( kv )
	
end

function modifier_magma_boss_firestorm_thinker:OnRemoved()
end

function modifier_magma_boss_firestorm_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_magma_boss_firestorm_thinker:OnIntervalThink()
	if not self.delayed then
		self.delayed = true
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		return
	end
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),self.parent:GetOrigin(),nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(self.caster,self.ability,"modifier_magma_boss_firestorm",{duration = self.burn_duration,interval = self.burn_interval,damage = self.burn_damage,})
	end
	self:PlayEffects()
	self.wave = self.wave + 1
	if self.wave>=self.count then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_magma_boss_firestorm_thinker:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm", self.parent )
end

modifier_magma_boss_firestorm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magma_boss_firestorm:IsHidden()
	return false
end

function modifier_magma_boss_firestorm:IsDebuff()
	return true
end

function modifier_magma_boss_firestorm:IsStunDebuff()
	return false
end

function modifier_magma_boss_firestorm:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_magma_boss_firestorm:OnCreated( kv )
	if not IsServer() then return end
	local interval = kv.interval
	self.damage_pct = kv.damage/100
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}
	self:StartIntervalThink( interval )
end

function modifier_magma_boss_firestorm:OnRefresh( kv )
	if not IsServer() then return end
	self.damage_pct = kv.damage/100
end

function modifier_magma_boss_firestorm:OnIntervalThink()
	local damage = self:GetParent():GetMaxHealth() * self.damage_pct
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end

function modifier_magma_boss_firestorm:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_magma_boss_firestorm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end