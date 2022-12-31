-- Independent Stacks
function CDOTA_Modifier_Lua:AddIndependentStack(duration, limit, remove_on_expire, config)
	self.independent_stack_timers = self.independent_stack_timers or {}
	self.current_stack_count = self.current_stack_count or 0

	local stacks_increment = config and config.stacks or 1
	self.current_stack_count = self.current_stack_count + stacks_increment

	local timer_name = Timers:CreateTimer(duration or self:GetRemainingTime(), function(inner_timer_name)
		if not self or self:IsNull() then return end

		self.current_stack_count = self.current_stack_count - stacks_increment

		local new_stack_count = limit and math.min(self.current_stack_count, limit) or self.current_stack_count
		self:SetStackCount(new_stack_count)
		
		self.independent_stack_timers[inner_timer_name] = nil
		if new_stack_count == 0 and self:GetDuration() == -1 and remove_on_expire then self:Destroy() end
	end)

	self.independent_stack_timers[timer_name] = true

	local new_stack_count = limit and math.min(self.current_stack_count, limit) or self.current_stack_count
	self:SetStackCount(new_stack_count)
end


function CDOTA_Modifier_Lua:CancelIndependentStacks()
	for timer_name, _ in pairs(self.independent_stack_timers or {}) do
		Timers:RemoveTimer(timer_name)
		self.independent_stack_timers[timer_name] = nil
	end
	self.current_stack_count = 0
	self:SetStackCount(0)
end
