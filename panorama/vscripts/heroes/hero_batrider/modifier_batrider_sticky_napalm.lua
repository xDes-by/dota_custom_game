modifier_batrider_sticky_napalm_lua = class({}) ---@class modifier_batrider_sticky_napalm_lua:CDOTA_Modifier_Lua

-- "Sticky Napalm triggers on any damage instance caused by Batrider, except from Orb of Venom, Radiance, Spirit Vessel, Urn of Shadows and damage with the no-reflection flag."
-- Orb of Venom seems to already be taken care of innately so it doesn't have to be added to this list
modifier_batrider_sticky_napalm_lua.non_trigger_inflictors = {
	["batrider_sticky_napalm"]	= true,
	["item_cloak_of_flames"]	= true,
	["item_radiance"]			= true,
	["item_urn_of_shadows"]		= true,
	["item_spirit_vessel"]		= true,
	["item_torture_pipe_1"]		= true,
	["item_torture_pipe_2"]		= true,
}

function modifier_batrider_sticky_napalm_lua:IsDebuff()
	return true
end

function modifier_batrider_sticky_napalm_lua:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_napalm_damage_debuff.vpcf"
end

function modifier_batrider_sticky_napalm_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_stickynapalm.vpcf"
end

function modifier_batrider_sticky_napalm_lua:OnCreated()
	local ability = self:GetAbility()

	self.max_stacks			= ability:GetSpecialValueFor("max_stacks")
	self.movement_speed_pct	= ability:GetSpecialValueFor("movement_speed_pct")
	self.turn_rate_pct		= ability:GetSpecialValueFor("turn_rate_pct")
	self.damage				= ability:GetSpecialValueFor("damage")
	
	if not IsServer() then return end
	
	self.damage_table = {
		victim 			= self:GetParent(),
		damage 			= nil,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_PROPERTY_FIRE,
		attacker 		= self:GetCaster(),
		ability 		= ability
	}
	
	self:SetStackCount(1)
	
	self.stack_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_batrider/batrider_stickynapalm_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl(self.stack_particle, 1, Vector(math.floor(self:GetStackCount() / 10), self:GetStackCount() % 10, 0))
	self:AddParticle(self.stack_particle, false, false, -1, false, true)

	self:ApplyDamage(ability:GetSpecialValueFor("application_damage"))
end

function modifier_batrider_sticky_napalm_lua:OnRefresh()
	local ability = self:GetAbility()

	self.max_stacks			= ability:GetSpecialValueFor("max_stacks")
	self.movement_speed_pct	= ability:GetSpecialValueFor("movement_speed_pct")
	self.turn_rate_pct		= ability:GetSpecialValueFor("turn_rate_pct")
	self.damage				= ability:GetSpecialValueFor("damage")

	if not IsServer() then return end

	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()
	end
	
	if self.stack_particle then
		ParticleManager:SetParticleControl(self.stack_particle, 1, Vector(math.floor(self:GetStackCount() / 10), self:GetStackCount() % 10, 0))
	end

	self:ApplyDamage(ability:GetSpecialValueFor("application_damage"))
end

function modifier_batrider_sticky_napalm_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, 
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_batrider_sticky_napalm_lua:GetModifierMoveSpeedBonus_Percentage()
	return math.min(self:GetStackCount(), self.max_stacks) * self.movement_speed_pct
end

function modifier_batrider_sticky_napalm_lua:GetModifierTurnRate_Percentage()
	return self.turn_rate_pct
end

function modifier_batrider_sticky_napalm_lua:OnTakeDamage(keys)
	local ability = self:GetAbility()
	local parent = self:GetParent()

	if not IsValidEntity(ability) then 
		self:Destroy()
		return 
	end

	if keys.attacker == self:GetCaster() and keys.unit == parent 
	and (not keys.inflictor or not self.non_trigger_inflictors[keys.inflictor:GetName()]) 
	and IsBitOff(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then
		local damage_debuff_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_napalm_damage_debuff.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(damage_debuff_particle)
		
		self:ApplyDamage(self.damage)
	end
end

function modifier_batrider_sticky_napalm_lua:ApplyDamage(damage)
	local parent = self:GetParent()

	self.damage_table.damage = damage * self:GetStackCount()

	if parent:IsCreep() or parent:IsCreepHero() then
		self.damage_table.damage = self.damage_table.damage * 0.5
	end
	
	ApplyDamage(self.damage_table)
end

function modifier_batrider_sticky_napalm_lua:OnTooltip()
	local parent = self:GetParent()
	if parent:IsCreep() or parent:IsCreepHero() then
		return self.damage * 0.5 * self:GetStackCount()
	else
		return self.damage * self:GetStackCount()
	end
end
