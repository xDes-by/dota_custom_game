LinkLuaModifier("modifier_invoker_meteor", "abilities/bosses/invoker/invoker_meteor", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_invoker_meteor_thinker", "abilities/bosses/invoker/invoker_meteor", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_invoker_meteor_burn", "abilities/bosses/invoker/invoker_meteor", LUA_MODIFIER_MOTION_VERTICAL)

invoker_meteor = class({})

function invoker_meteor:OnSpellStart()

	self.mod_caster = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invoker_meteor", {duration = 3})
end

------------------------------------------------------------------------------

modifier_invoker_meteor = class({})

function modifier_invoker_meteor:IsHidden()
    return true
end

function modifier_invoker_meteor:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(self.interval)
end


function modifier_invoker_meteor:OnIntervalThink()
if not IsServer() then return end
	local caster_pos = self:GetCaster():GetAbsOrigin()
		for i = 1, 2 do
			local angle = RandomInt(0, 360)
			local variance = RandomInt(-self.radius, self.radius)
			local dy = math.sin(angle) * variance
			local dx = math.cos(angle) * variance
			local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
			
			CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_invoker_meteor_thinker", {}, target_point, self:GetCaster():GetTeamNumber(), false)
		
		self:StartIntervalThink(-1)
		self:StartIntervalThink(self.interval)
	end
end

--------------------------------------------------------------------------

modifier_invoker_meteor_thinker = class({})

function modifier_invoker_meteor_thinker:IsHidden()
	return true
end

function modifier_invoker_meteor_thinker:OnCreated( kv )
	if IsServer() then
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = self:GetAbility():GetSpecialValueFor( "land_time" )
		self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.distance = self:GetAbility():GetSpecialValueFor( "travel_distance")
		self.speed = self:GetAbility():GetSpecialValueFor( "travel_speed" )
		self.vision = self:GetAbility():GetSpecialValueFor( "vision_distance" )
		self.vision_duration = self:GetAbility():GetSpecialValueFor( "end_vision_duration" )
		
		self.interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
		self.duration = self:GetAbility():GetSpecialValueFor( "burn_duration" )
		

		-- variables
		self.fallen = false

		self:GetParent():SetDayTimeVisionRange( self.vision )
		self:GetParent():SetNightTimeVisionRange( self.vision )

		self:StartIntervalThink( self.delay )

		self:PlayEffects1()
	end
end

function modifier_invoker_meteor_thinker:OnRefresh( kv )
	
end

function modifier_invoker_meteor_thinker:OnDestroy( kv )
	if IsServer() then
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.vision, self.vision_duration, false)

		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
	end
end

function modifier_invoker_meteor_thinker:OnIntervalThink()
	if not self.fallen then
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
	else
		self:Move_Burn()
	end
end

function modifier_invoker_meteor_thinker:Burn()
	local damage = self:GetAbility():GetSpecialValueFor( "main_damage" )
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = enemy:GetMaxHealth()/100*damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage( self.damageTable )

		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_invoker_meteor_burn", { duration = self.duration } )
	end
end

function modifier_invoker_meteor_thinker:Move_Burn()
	local parent = self:GetParent()

	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	self:Burn()
	
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:Destroy()
		return
	end
end


function modifier_invoker_meteor_thinker:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	local height = 1000
	local height_target = -0

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_invoker_meteor_thinker:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )

	self:AddParticle( effect_cast, false, false, -1, false, false )

	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
	EmitSoundOn( sound_loop, self:GetParent() )
end


------------------------------------------------------------------

modifier_invoker_meteor_burn = class({})

function modifier_invoker_meteor_burn:IsHidden()
	return false
end

function modifier_invoker_meteor_burn:IsDebuff()
	return true
end

function modifier_invoker_meteor_burn:IsStunDebuff()
	return false
end

function modifier_invoker_meteor_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_invoker_meteor_burn:IsPurgable()
	return true
end

function modifier_invoker_meteor_burn:OnCreated( kv )
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor( "burn_dps" )
		local delay = 1
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetParent():GetMaxHealth()/100*damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}

		self:StartIntervalThink( delay )
	end
end

function modifier_invoker_meteor_burn:OnIntervalThink()
	ApplyDamage( self.damageTable )
	EmitSoundOn( "Hero_Invoker.ChaosMeteor.Damage", self:GetParent() )
end

function modifier_invoker_meteor_burn:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_invoker_meteor_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
