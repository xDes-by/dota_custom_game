-- Editors:
--     Firetoad
--     AtroCty, 02.04.2017
--     naowin, 07.04.2018
--	   AltiV, 08.08.2018

-------------------------------------------
--				SADIST
-------------------------------------------

LinkLuaModifier("modifier_imba_sadist", "heroes/hero_necrolyte/necrolyte_sadist/necrolyte_sadist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sadist_stack", "heroes/hero_necrolyte/necrolyte_sadist/necrolyte_sadist", LUA_MODIFIER_MOTION_NONE)

imba_necrolyte_sadist = imba_necrolyte_sadist or class({})

function imba_necrolyte_sadist:GetAbilityTextureName()
	return "necrolyte_sadist"
end

function imba_necrolyte_sadist:GetIntrinsicModifierName()
	return "modifier_imba_sadist"
end

function imba_necrolyte_sadist:IsInnateAbility()
	return true
end

modifier_imba_sadist = class({})
function modifier_imba_sadist:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_sadist:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_sadist = "modifier_imba_sadist_stack"

	-- Ability specials
	self.regen_duration = self.ability:GetSpecialValueFor("regen_duration")
	self.hero_multiplier = self.ability:GetSpecialValueFor("hero_multiplier")
end

function modifier_imba_sadist:IsHidden()
	return true
end

function modifier_imba_sadist:OnAttackLanded( params )
	if IsServer() then

		-- If this is an illusion, do nothing
		if not params.attacker:IsRealHero() then
			return nil
		end

		-- If target has break, do nothing
		if params.attacker:PassivesDisabled() then
			return nil
		end

		if self.caster:HasTalent("special_bonus_imba_necrolyte_2") then
			if params.attacker == self.caster and params.target:IsHero() then

				-- If the caster doesn't have the modifier, add it
				if not self.caster:HasModifier(self.modifier_sadist) then
					self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_sadist_stack", {duration = self.regen_duration})
				end

				-- Increment a stack
				local modifier_sadist_handler = self.caster:FindModifierByName(self.modifier_sadist)
				if modifier_sadist_handler then
					modifier_sadist_handler:IncrementStackCount()
					modifier_sadist_handler:ForceRefresh()
				end
			end
		end
	end
end

function modifier_imba_sadist:OnDeath(params)
	if IsServer() then
		local unit = params.unit

		if params.attacker == self:GetParent() then
			-- If this is an illusion, do nothing
			if not params.attacker:IsRealHero() then
				return nil
			end

			-- If target has break, do nothing
			if params.attacker:PassivesDisabled() then
				return nil
			end

			-- Initialize stacks
			local stacks = 1

			-- If the target was a real hero, increase stack count
			if unit:IsRealHero() then
				stacks = self.hero_multiplier
			end

			-- If the caster doesn't have the modifier, add it
			if not self.caster:HasModifier(self.modifier_sadist) then
				self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_sadist_stack", {duration = self.regen_duration})
			end

			-- Increment stacks
			local modifier_sadist_handler = self.caster:FindModifierByName(self.modifier_sadist)
			if modifier_sadist_handler then
				for i = 1, stacks do
					modifier_sadist_handler:IncrementStackCount()
					modifier_sadist_handler:ForceRefresh()
				end
			end
		end
	end
end


modifier_imba_sadist_stack = modifier_imba_sadist_stack or class({})

function modifier_imba_sadist_stack:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Ability specials
		self.regen_duration = self.ability:GetSpecialValueFor("regen_duration")
		self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
		self.health_regen = self.ability:GetSpecialValueFor("health_regen")
		self.regen_minimum = self.ability:GetSpecialValueFor("regen_minimum")

		-- Initialize table
		self.stacks_table = {}

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_sadist_stack:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.regen_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:GetParent():RemoveModifierByName("modifier_imba_sadist_stack")

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:GetParent():RemoveModifierByName("modifier_imba_sadist_stack")
		end
	end
end

function modifier_imba_sadist_stack:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_sadist_stack:IsHidden() return false end
function modifier_imba_sadist_stack:IsPurgable() return false end
function modifier_imba_sadist_stack:IsDebuff() return false end

function modifier_imba_sadist_stack:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}

	return decFunc
end

function modifier_imba_sadist_stack:GetModifierConstantManaRegen()
	if not IsServer() then return end
	if self.caster and self.mana_regen and self.regen_minimum then 
		local mana_regen = self.mana_regen + self.caster:FindTalentValue("special_bonus_imba_necrolyte_6")
		mana_regen = mana_regen * self:GetStackCount() * self:GetParent():GetMaxMana() * 0.01
		local regen_minimum = self.regen_minimum * self:GetStackCount()
		return math.max(mana_regen, regen_minimum)
	end
end

function modifier_imba_sadist_stack:GetModifierConstantHealthRegen()
	if not IsServer() then return end
	if self.caster and self.health_regen and self.regen_minimum then 	
		local health_regen = self.health_regen + self.caster:FindTalentValue("special_bonus_imba_necrolyte_6")
		health_regen = health_regen * self:GetStackCount() * self:GetParent():GetMaxHealth() * 0.01
		local regen_minimum = self.regen_minimum * self:GetStackCount()
		return math.max(health_regen, regen_minimum)
	end
end