modifier_lifestealer_infest_caster = class({})

function modifier_lifestealer_infest_caster:IsPurgable( ... )
	return false
end

function modifier_lifestealer_infest_caster:IsHidden() return self:GetStackCount() == 1 end

function modifier_lifestealer_infest_caster:OnCreated()
	local ability = self:GetAbility()

	self.self_regen = ability:GetSpecialValueFor("self_regen")
	self.radius = ability:GetSpecialValueFor("radius")

	if not IsServer() then return end
	self:GetParent():AddNoDraw()

	local damage  = ability:GetSpecialValueFor("damage")

	self.damage_table = {
		victim 			= nil,
		damage 			= damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= ability
	}
end

function modifier_lifestealer_infest_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end

function modifier_lifestealer_infest_caster:CheckState()
	return {
		[MODIFIER_STATE_OUT_OF_GAME] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_DISARMED] 			= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_MUTED] 				= true,
		[MODIFIER_STATE_ROOTED] 			= true,
	}
end

function modifier_lifestealer_infest_caster:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()

	if self.target_mod and not self.target_mod:IsNull() then
		self.target_mod:Destroy()
	end

	-- explosion goes here

	local particle_name = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", parent)
	local infest_particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:ReleaseParticleIndex(infest_particle)

	parent:StartGesture(ACT_DOTA_LIFESTEALER_INFEST_END)

	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(), 
		parent:GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
		
	for _, enemy in pairs(enemies) do
		self.damage_table.victim = enemy

		ApplyDamage(self.damage_table)
	end
	
	FindClearSpaceForUnit(parent, parent:GetAbsOrigin(), false)

	local ability = self:GetAbility()

	if ability and not ability:IsNull() then
		ability:SetAbilitiesHiddenState(false)
	end

	parent:EmitSound("Hero_LifeStealer.Consume")

	parent:RemoveNoDraw()
end


function modifier_lifestealer_infest_caster:GetModifierHealthRegenPercentage()
	return self.self_regen * (1 + self:GetStackCount())
end
