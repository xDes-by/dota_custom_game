--[[ Written by Blasphemy Incarnate
		Updated 28/07/2020 ]]

LinkLuaModifier('modifier_slark_essence_shift_lua', 'heroes/hero_slark/slark_essence_shift_lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_slark_essence_shift_buff_custom', 'heroes/hero_slark/modifier_slark_essence_shift_buff_custom', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_slark_essence_shift_debuff_custom', 'heroes/hero_slark/modifier_slark_essence_shift_debuff_custom', LUA_MODIFIER_MOTION_NONE)

slark_essence_shift_lua = class({})

function slark_essence_shift_lua:GetIntrinsicModifierName()
	return 'modifier_slark_essence_shift_lua'
end

--------------------------------------------------------------------------------
--== Main Modifier ==--

modifier_slark_essence_shift_lua = class({})

function modifier_slark_essence_shift_lua:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_slark_essence_shift_lua:IsDebuff() return false end
function modifier_slark_essence_shift_lua:IsPurgable() return false end

function modifier_slark_essence_shift_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_slark_essence_shift_lua:OnRefresh(keys)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.creep_agi_gain = self.ability:GetSpecialValueFor('creep_agi_gain')
end

-- Cleanup hero stack modifier
function modifier_slark_essence_shift_lua:OnDestroy()
	if self.hero_modifier and not self.hero_modifier:IsNull() then self.hero_modifier:Destroy() end
end

-- Set creep stacks to 0 when entering the fountain
function modifier_slark_essence_shift_lua:OnModifierAdded(keys)
	if IsServer() and keys.unit == self.parent and self.parent:HasModifier('modifier_hero_refreshing') then self:SetStackCount(0) end
end

function modifier_slark_essence_shift_lua:OnDeath(keys)
	local unit = keys.unit

	if unit == self.parent then 
		self:SetStackCount(0)
		return
	end

	local modifier = unit:FindModifierByName("modifier_slark_essence_shift_debuff_custom")
	if modifier and modifier:GetCaster() == self.parent and (self.parent == keys.attacker or unit:GetRangeToUnit(self.parent) <= 300) then
		local permanent_buff = self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_permanent_buff", nil)

		if permanent_buff then
			permanent_buff:IncrementStackCount()
		end

		unit:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_permanent_debuff", nil):IncrementStackCount()
	end
end

-- Attacking enemy creeps or creatures
function modifier_slark_essence_shift_lua:GetModifierProcAttack_Feedback(keys)
	if self.parent:IsIllusion() or self.parent:PassivesDisabled() then return end
	if keys.target:GetTeam() == self.parent:GetTeam() or keys.target:IsOther() then return end

	if keys.target:IsCreep() or keys.target:IsCreature() then
		self:IncrementStackCount()
	else
		local duration = self.ability:GetSpecialValueFor("duration") + self.parent:FindTalentValue("special_bonus_unique_slark_4")
		
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_buff_custom", { duration = duration })
		
		keys.target:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_debuff_custom", { duration = duration })
		keys.target:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_permanent_debuff", nil)
	end

	-- Purple slash effect
	local particle_cast = ParticleManager:GetParticleReplacement('particles/units/heroes/hero_slark/slark_essence_shift.vpcf', self.parent)
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControl(effect_cast, 0, keys.target:GetAbsOrigin() + Vector(0, 0, 64))
	ParticleManager:SetParticleControl(effect_cast, 1, self.parent:GetAbsOrigin() + Vector(0, 0, 64))
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

-- Agility
function modifier_slark_essence_shift_lua:GetModifierBonusStats_Agility()
	return self:GetStackCount() * (self.creep_agi_gain or 0)
end
