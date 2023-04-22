boss_4_hole = class({})

LinkLuaModifier( "modifier_boss_4_hole_thinker", "abilities/bosses/line/boss_4/boss_4_hole", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_4_hole_helper", "abilities/bosses/line/boss_4/boss_4_hole", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_4_hole_black_hole", "abilities/bosses/line/boss_4/boss_4_hole", LUA_MODIFIER_MOTION_HORIZONTAL )


function boss_4_hole:GetIntrinsicModifierName()
    return "modifier_boss_4_hole_helper"
end

modifier_boss_4_hole_helper = class({})

function modifier_boss_4_hole_helper:IsHidden()
    return true
end

function modifier_boss_4_hole_helper:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_boss_4_hole_helper:OnIntervalThink()
	if IsServer() and self:GetAbility() and self:GetCaster():IsAlive() and not self:GetParent():PassivesDisabled() then
		if self:GetAbility():IsCooldownReady() then
			if not IsServer() then return end
			local caster = self:GetParent()
			local point = self:GetParent():GetAbsOrigin()
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			self.thinker = CreateModifierThinker(caster,self:GetAbility(),"modifier_boss_4_hole_thinker",{ duration = duration },point+RandomVector(RandomInt(1,700)),caster:GetTeamNumber(),false)
			self:GetAbility():UseResources(false, false,false, true)
		end
	end
end

modifier_boss_4_hole_thinker = class({})

function modifier_boss_4_hole_thinker:IsHidden()
	return false
end

function modifier_boss_4_hole_thinker:IsPurgable()
	return false
end

function modifier_boss_4_hole_thinker:OnCreated( kv )
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0

	if IsServer() then
		-- precache damage
		local damage = self:GetAbility():GetSpecialValueFor( "near_damage" )
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			--damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
		}
		self:StartIntervalThink( self.interval )
		self:PlayEffects()
	end
end

function modifier_boss_4_hole_thinker:OnRemoved()
	if IsServer() then
		if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
			self:OnIntervalThink()
		end

		UTIL_Remove( self:GetParent() )
	end
end

function modifier_boss_4_hole_thinker:OnDestroy()
	if IsServer() then
	 StopSoundOn("Hero_Enigma.Black_Hole",  self:GetParent())
	end
end

function modifier_boss_4_hole_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetParent():GetOrigin(),nil,250,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = enemy:GetMaxHealth()/100*self:GetAbility():GetSpecialValueFor("near_damage")
		ApplyDamage( self.damageTable )
	end

	self.tick = self.tick+1
end

function modifier_boss_4_hole_thinker:IsAura()
	return true
end

function modifier_boss_4_hole_thinker:GetModifierAura()
	return "modifier_boss_4_hole_black_hole"
end

function modifier_boss_4_hole_thinker:GetAuraRadius()
	return 250
end

function modifier_boss_4_hole_thinker:GetAuraDuration()
	return 0.1
end

function modifier_boss_4_hole_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_boss_4_hole_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_boss_4_hole_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_boss_4_hole_thinker:PlayEffects()
	local particle_cast = "particles/enigma_blackhole_custom.vpcf"
	local sound_cast = "Hero_Enigma.Black_Hole"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())

	self:AddParticle(effect_cast,false, false,-1,false,false)
	EmitSoundOn( sound_cast, self:GetParent() )
end

modifier_boss_4_hole_black_hole = class({})

function modifier_boss_4_hole_black_hole:IsHidden()
	return false
end

function modifier_boss_4_hole_black_hole:IsDebuff()
	return true
end

function modifier_boss_4_hole_black_hole:IsStunDebuff()
	return true
end

function modifier_boss_4_hole_black_hole:IsPurgable()
	return true
end

function modifier_boss_4_hole_black_hole:OnCreated( kv )
	if IsServer() then
		self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_boss_4_hole_black_hole:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_boss_4_hole_black_hole:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
end

function modifier_boss_4_hole_black_hole:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_boss_4_hole_black_hole:GetOverrideAnimationRate()
	return 0.2
end

function modifier_boss_4_hole_black_hole:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_boss_4_hole_black_hole:UpdateHorizontalMotion( me, dt )
	local target = self:GetParent():GetOrigin()-self.center
	target.z = 0

	local targetL = target:Length2D()-30*dt

	local targetN = target:Normalized()
	local deg = math.atan2( targetN.y, targetN.x )
	local targetN = Vector( math.cos(deg+0.25*dt), math.sin(deg+0.25*dt), 0 );

	self:GetParent():SetOrigin( self.center + targetN * targetL )
end

function modifier_boss_4_hole_black_hole:OnHorizontalMotionInterrupted()
	self:Destroy()
end