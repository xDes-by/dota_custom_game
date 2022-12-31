modifier_charge_counter = class({})

function modifier_charge_counter:IsHidden()
	return true
end

function modifier_charge_counter:DestroyOnExpire() 	return false end
function modifier_charge_counter:IsPurgable() 		return false end
function modifier_charge_counter:RemoveOnDeath() 	return false end
function modifier_charge_counter:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_charge_counter:OnCreated(keys)
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_illusion") then
		self:Destroy()
		return
	end

	-- track time for TIME_BASED charges, otherwise listen to round end
	if keys.charge_type == TIME_BASED then
		self:StartIntervalThink(0.2)
	else
		AbilityCharges:RegisterRoundEndListener(self)
	end

	self.ability_name = self:GetAbility():GetName()
	self.ability = self:GetAbility()
end

function modifier_charge_counter:OnIntervalThink()
	local ability = self.ability

	if not ability or ability:IsNull() then 
		self:Destroy()
		return 
	end

	local remaining_time = self:GetRemainingTimeCustom()
	if remaining_time > 0 and ability:GetCooldownTimeRemaining() - remaining_time > 1 then
		ability:EndCooldown()
		ability:StartCooldown(remaining_time)
	end

	-- Add charges if max charges count increased
	local max_charges = ability:GetMaxCharges()
	if self.old_max_charges and max_charges > self.old_max_charges then
		self.ability:IncrementCharges(max_charges - self.old_max_charges)
	end
	self.old_max_charges = max_charges

	if remaining_time >= 0.1 or self:GetStackCount() >= max_charges then return end

	ability:IncrementCharges()

	if self:GetStackCount() >= max_charges then return end

	self:SetRemainingTimeCustom(ability:GetChargeCooldown())
	self:SetDuration(ability:GetChargeCooldown(), true)
end

function modifier_charge_counter:OnRoundEnded()
	local ability = self.ability
	if not ability or ability:IsNull() then
		if self and not self:IsNull() then 
			self:Destroy()
		end
		return 
	end
	
	local current_charges = ability:GetCurrentCharges()

	ability.current_round_used_charges = 0

	if current_charges < ability:GetMaxCharges() then
		if ability:GetCurrentChargeCooldown() + 1 >= ability:GetChargeCooldown() then
			ability:IncrementCharges()
			ability:EndCooldown()
			ability:SetActivated(true)
		else
			self.passed_rounds = self.passed_rounds + 1
		end
	end
end

function modifier_charge_counter:GetRemainingTimeCustom()
	if not self.game_time or not self.duration then
		self.game_time = GameRules:GetGameTime()
		self.duration = self:GetRemainingTime()
		return self.duration
	end
	local delta_time = GameRules:GetGameTime() - self.game_time
	return self.duration - delta_time
end

function modifier_charge_counter:SetRemainingTimeCustom(new_time)
	self.duration = new_time
	self.game_time = GameRules:GetGameTime()
	CustomNetTables:SetTableValue("ability_charges", "ability_charges_"..self:GetAbility():entindex(), { start = self.game_time, dur = new_time })
end

function modifier_charge_counter:ReduceCooldown(value)
	if not self or self:IsNull() then return end
	if self.charge_type == ROUND_BASED then return end
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then self:Destroy() return end

	local stack_count = self:GetStackCount()
	if stack_count >= ability:GetMaxCharges() then return end

	local charge_cooldown = self.duration
	local elapsed_time = GameRules:GetGameTime() - self.game_time
 	local duration_sum = elapsed_time + value

	if duration_sum < charge_cooldown then
		self.game_time = self.game_time - value
		CustomNetTables:SetTableValue("ability_charges", "ability_charges_"..self:GetAbility():entindex(), { start = self.game_time, dur = self.duration })
	else
		local charges_to_add = math.floor(duration_sum / charge_cooldown)
		local new_elapsed_time = duration_sum % charge_cooldown

		local new_charges = stack_count + charges_to_add
		
		if new_charges >= ability:GetMaxCharges() then 
			new_charges = ability:GetMaxCharges()
		else
			self.game_time = GameRules:GetGameTime() - new_elapsed_time
			self.duration = ability:GetChargeCooldown()
			CustomNetTables:SetTableValue("ability_charges", "ability_charges_"..ability:entindex(), { start = self.game_time, dur = self.duration })
		end

		AbilityCharges:SetCharges(ability, stack_count, new_charges)
	end
end
