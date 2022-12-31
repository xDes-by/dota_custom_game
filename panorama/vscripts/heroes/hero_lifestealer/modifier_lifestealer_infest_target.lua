modifier_lifestealer_infest_target = class({})

function modifier_lifestealer_infest_target:IsPurgable( ... )
	return false
end

function modifier_lifestealer_infest_target:RemoveOnDeath()
	return true
end

function modifier_lifestealer_infest_target:OnCreated()
	local ability = self:GetAbility()

	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_movement_speed = ability:GetSpecialValueFor("bonus_movement_speed")

	local parent = self:GetParent()
	local caster = self:GetCaster()

	self.ally = parent:IsRealHero() and parent:GetTeamNumber() == caster:GetTeamNumber()

	if parent:IsRealHero() and parent:GetTeamNumber() ~= caster:GetTeamNumber() then
		self:SetDuration(ability:GetSpecialValueFor("enemy_hero_infest_duration"), true)
	end

	if not IsServer() then return end

	local infest_overhead_particle = ParticleManager:CreateParticleForTeam(
		"particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", 
		PATTACH_OVERHEAD_FOLLOW, 
		parent, 
		caster:GetTeamNumber()
	)

	self:AddParticle(infest_overhead_particle, false, false, 1, true, false)

	-- Scepter makes Lifestealer attack inside enemy heroes
	if caster:HasScepter() then
	if caster:GetTeam() ~= parent:GetTeam() and parent:IsHero() then
		self:StartIntervalThink(ability:GetSpecialValueFor("enemy_hero_attack_interval"))
	end
	end
end

function modifier_lifestealer_infest_target:OnIntervalThink()
	self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, false)
end

function modifier_lifestealer_infest_target:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_UNIT_MOVED, -- OnUnitMoved
	}
end

function modifier_lifestealer_infest_target:OnDestroy()
	if not IsServer() then return end

	if self.caster_mod and not self.caster_mod:IsNull() then
		self.caster_mod:Destroy()
	end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if parent:IsCreature() or (parent:IsCreep() and not parent:HasAbility("creature_ancient")) then
		parent:Kill(ability, caster)
	end

	if ability and not ability:IsNull() then
		ability.casted = false
	end

end


function modifier_lifestealer_infest_target:GetModifierExtraHealthBonus()
	if not self.ally then return end
	return self.bonus_health
end

function modifier_lifestealer_infest_target:GetModifierMoveSpeedBonus_Percentage()
	if not self.ally then return end
	return self.bonus_movement_speed
end

-- sync movement with one we got into
function modifier_lifestealer_infest_target:OnUnitMoved(params)
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end
	if not self.caster_mod or self.caster_mod:IsNull() then return end

	local parent = self.caster_mod:GetParent()
	if parent and not parent:IsNull() then
		parent:SetAbsOrigin(params.unit:GetAbsOrigin())
	end
end
