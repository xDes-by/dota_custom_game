innate_unstoppable_force = class({})

LinkLuaModifier("modifier_innate_unstoppable_force", "heroes/innates/unstoppable_force", LUA_MODIFIER_MOTION_NONE)

function innate_unstoppable_force:GetIntrinsicModifierName()
	return "modifier_innate_unstoppable_force"
end



modifier_innate_unstoppable_force = class({})

function modifier_innate_unstoppable_force:IsHidden() return self:GetStackCount() == 0 end
function modifier_innate_unstoppable_force:IsDebuff() return false end
function modifier_innate_unstoppable_force:IsPurgable() return false end
function modifier_innate_unstoppable_force:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_unstoppable_force:OnCreated(keys)
	self.distance_moved = 0
	self:OnRefresh(keys)

	if IsClient() then return end

	self.particle = ParticleManager:CreateParticle("particles/custom/innates/unstoppable_force_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, 0, false, false)
end

function modifier_innate_unstoppable_force:OnRefresh(keys)
	local ability = self:GetAbility()
	self.unit_distance_stack_interval = ability:GetSpecialValueFor("unit_distance_stack_interval")
	self.pct_damage_boost_per_stack = ability:GetSpecialValueFor("pct_damage_boost_per_stack")
	self.pct_considered_massive_damage = ability:GetSpecialValueFor("pct_considered_massive_damage")
	self.duration = ability:GetSpecialValueFor("duration")

	if IsClient() then return end
	self:StartIntervalThink(0.1)
end

function modifier_innate_unstoppable_force:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_innate_unstoppable_force:GetModifierTotalDamageOutgoing_Percentage(kv)
	local outgoing_percentage = self:GetStackCount() * self.pct_damage_boost_per_stack
	
	-- We need the client to see the current percentage
	-- And not zero out as soon as we hover over the description
	if IsServer() then
		local target = kv.target
		if outgoing_percentage >= self.pct_considered_massive_damage then
			local explosion_pfx = ParticleManager:CreateParticle("particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(explosion_pfx, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_pfx)
			EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Unstoppable_Force.Overkill", self:GetParent())
		end

		if not self.activated then
			self.activated = true
			Timers:CreateTimer(self.duration, function()
				self.activated = false
				self:SetStackCount(0)
				ParticleManager:SetParticleControl(self.particle, 1, Vector(0,0,0))
			end)
		end	
	end

	return outgoing_percentage
end

function modifier_innate_unstoppable_force:OnIntervalThink()
	if not self.previous_location then
		self.previous_location = self:GetParent():GetAbsOrigin()
		return
	end

	local current_location = self:GetParent():GetAbsOrigin()
	self.distance_moved = self.distance_moved + (self.previous_location - current_location):Length2D()
	self.previous_location = current_location

	if self.distance_moved >= self.unit_distance_stack_interval then
		self:SetStackCount(self:GetStackCount() + math.floor(self.distance_moved / self.unit_distance_stack_interval))
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetStackCount(), 0, 0))
		self.distance_moved = self.distance_moved % self.unit_distance_stack_interval
	end
end

function modifier_innate_unstoppable_force:OnRoundStart(keys)
	if IsClient() then return end

	self.previous_location = nil
	self:SetStackCount(0)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0,0,0))
	self:StartIntervalThink(0.1)
end

function modifier_innate_unstoppable_force:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_unstoppable_force:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:SetStackCount(0)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0,0,0))
	self:StartIntervalThink(-1)
	self.activated = false
end
