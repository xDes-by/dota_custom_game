modifier_necrolyte_heartstopper_aura_buff = class({})

function modifier_necrolyte_heartstopper_aura_buff:IsHidden()
    return false
end

function modifier_necrolyte_heartstopper_aura_buff:IsDebuff()
    return false
end

function modifier_necrolyte_heartstopper_aura_buff:IsPurgable()
    return false
end

function modifier_necrolyte_heartstopper_aura_buff:RemoveOnDeath()
    return true
end

function modifier_necrolyte_heartstopper_aura_buff:OnCreated( kv )
    self.mana_regen = self:GetManaRegenValue()
    self.health_regen = self:GetHealthRegenValue()
    self.duration = self:GetAbility():GetSpecialValueFor("regen_duration")
    if not IsServer() then return end
    self.stack_table = {}
    self:StartIntervalThink(0.2)
end

function modifier_necrolyte_heartstopper_aura_buff:OnRefresh( kv )
    self.mana_regen = self:GetManaRegenValue()
    self.health_regen = self:GetHealthRegenValue()
    self.duration = self:GetAbility():GetSpecialValueFor("regen_duration")
end

function modifier_necrolyte_heartstopper_aura_buff:GetManaRegenValue()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_str6") then
		return self:GetAbility():GetSpecialValueFor("mana_regen") * 1.4
	end
	return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_necrolyte_heartstopper_aura_buff:GetHealthRegenValue()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_str6") then
		return self:GetAbility():GetSpecialValueFor("health_regen") * 1.4
	end
	return self:GetAbility():GetSpecialValueFor("health_regen")
end

function modifier_necrolyte_heartstopper_aura_buff:OnIntervalThink()
	local repeat_needed = #self.stack_table > 0
	while repeat_needed do
		if GameRules:GetGameTime() - self.stack_table[1] >= self.duration then
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				table.remove(self.stack_table, 1)
				self:DecrementStackCount()
			end
		else
			repeat_needed = false
		end
	end
end

function modifier_necrolyte_heartstopper_aura_buff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		self:ForceRefresh()
	end
end

function modifier_necrolyte_heartstopper_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_necrolyte_heartstopper_aura_buff:GetModifierConstantManaRegen()
	return self:GetStackCount() * self.mana_regen
end

function modifier_necrolyte_heartstopper_aura_buff:GetModifierConstantHealthRegen()
	return self:GetStackCount() * self.health_regen
end