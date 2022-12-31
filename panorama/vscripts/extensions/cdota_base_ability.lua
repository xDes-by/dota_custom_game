_G.innate_exceptions = {
	modifier_faceless_void_time_walk_tracker = true,
	modifier_weaver_timelapse = true,
	--modifier_ember_spirit_fire_remnant_remnant_tracker = true,
	modifier_ember_spirit_fire_remnant_charge_counter = true,
	modifier_ember_spirit_fire_remnant_thinker = true,
	modifier_ember_spirit_fire_remnant_timer = true,
	--modifier_ember_spirit_fire_remnant = true, -- Can crash game if we leave this modifier on hero after ability deletion
}


function CDOTABaseAbility:ReduceCooldown(cooldown_reduction)
	if self.frozen_cooldown then return end

	local current_cooldown = self:GetCooldownTimeRemaining()
	local reduced_cooldown = current_cooldown - cooldown_reduction
	self:EndCooldown()
	if reduced_cooldown > 0 then
		self:StartCooldown(reduced_cooldown)
	end
	if self.charge_modifier then
		self.charge_modifier:ReduceCooldown(cooldown_reduction)
	end
end


function CDOTABaseAbility:HasBehavior(behavior)
	if not self or self:IsNull() then return end
	local abilityBehavior = tonumber(tostring(self:GetBehavior()))
	return bit.band(abilityBehavior, behavior) == behavior
end


function CDOTABaseAbility:ClearFalseInnateModifiers(leave_exceptions)
	if self:GetKeyValue("HasInnateModifiers") ~= 1 then
		for _,v in ipairs(self:GetCaster():FindAllModifiers()) do
			if v:GetAbility() == self then
				if not leave_exceptions or not _G.innate_exceptions[v:GetName()] then
					v:Destroy()
				end
			end
		end
	end
end


function CDOTABaseAbility:Disable()
	if self:IsChanneling() then
		self:SetChanneling(false)
	end
	if self:GetToggleState() then
		self:ToggleAbility()
	end
	if self:GetAutoCastState() then
		self:ToggleAutoCast()
	end
	self:ClearFalseInnateModifiers(true) -- remove ability modifiers before set level to prevent crash Dark Pact
	self:SetLevel(0)
	self:ClearFalseInnateModifiers(true) -- remove intrinsic ability modifiers that applies after set level
	self:SetHidden(true)
	self:OnChannelFinish(true)
end


function CDOTABaseAbility:SetRemovalTimer()
	self.removal_timer = Timers:CreateTimer(1, function()
		if self and not self:IsNull() and self.removal_timer then
			if self:NumModifiersUsingAbility() > 0 or self:IsChanneling() then return 1 end
			self:ClearFalseInnateModifiers(true)
			self.removal_timer = nil
			self:RemoveSelf()
		end
	end)
end


function CDOTABaseAbility:CancelRemovalTimer(level, hidden)
	if self.removal_timer then
		Timers:RemoveTimer(self.removal_timer)
		self.removal_timer = nil
		self:SetHidden(hidden or false)
		self:SetLevel(level or 1)
		return true
	end
end
