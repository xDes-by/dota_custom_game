modifier_lion_finger_of_death_creep_delay = class({})

function modifier_lion_finger_of_death_creep_delay:IsHidden() return true end
function modifier_lion_finger_of_death_creep_delay:IsDebuff() return false end
function modifier_lion_finger_of_death_creep_delay:IsPurgable() return false end
function modifier_lion_finger_of_death_creep_delay:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_lion_finger_of_death_creep_delay:DeclareFunctions()
	if IsServer() then return { MODIFIER_EVENT_ON_DEATH } end
end

function modifier_lion_finger_of_death_creep_delay:OnDeath(keys)
	if keys.unit ~= self:GetParent() then return end

	local caster = self:GetCaster()

	if caster and (not caster:IsNull()) then
		local creep_stack_modifier = caster:FindModifierByName("modifier_lion_finger_of_death_creep_stack_counter") or caster:AddNewModifier(caster, self:GetAbility(), "modifier_lion_finger_of_death_creep_stack_counter", {})

		if creep_stack_modifier then creep_stack_modifier:IncrementStackCount() end
	end
end



modifier_lion_finger_of_death_creep_stack_counter = class({})

function modifier_lion_finger_of_death_creep_stack_counter:IsHidden() return true end
function modifier_lion_finger_of_death_creep_stack_counter:IsDebuff() return false end
function modifier_lion_finger_of_death_creep_stack_counter:IsPurgable() return false end
function modifier_lion_finger_of_death_creep_stack_counter:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_lion_finger_of_death_creep_stack_counter:OnCreated()
	if IsClient() then return end

	self.creeps_per_kill_charge = self:GetAbility():GetSpecialValueFor("creeps_per_kill_charge")
end

function modifier_lion_finger_of_death_creep_stack_counter:OnStackCountChanged()
	if IsClient() then return end

	-- Needs to account for multicast most likely. Normal lion aghs with multicast allows for gaining multiple hero_deaths worth of damage from one hero.
	while self:GetStackCount() >= self.creeps_per_kill_charge do
		self:SetStackCount(self:GetStackCount() - self.creeps_per_kill_charge)

		local parent = self:GetParent()

		if parent and (not parent:IsNull()) then
			local damage_modifier = parent:FindModifierByName("modifier_lion_finger_of_death_kill_counter")
			if damage_modifier then 
				damage_modifier:IncrementStackCount() 
				parent:EmitSound("Hero_Lion.KillCounter")
			end
		end
	end
end
