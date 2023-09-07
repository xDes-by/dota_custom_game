modifier_talent_hp_per_level = class({})

function modifier_talent_hp_per_level:IsHidden()
	return true
end

function modifier_talent_hp_per_level:IsPurgable()
	return false
end

function modifier_talent_hp_per_level:RemoveOnDeath()
	return false
end
modifier_talent_hp_per_level.value = {150, 200, 250, 300, 350, 400}
function modifier_talent_hp_per_level:OnCreated()
	self.caster = self:GetCaster()
	self.hp_per_level = self.value[self:GetStackCount()]
end

function modifier_talent_hp_per_level:OnRefresh()
	self.caster = self:GetCaster()
	self.hp_per_level = self.value[self:GetStackCount()]	
end

function modifier_talent_hp_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
end

function modifier_talent_hp_per_level:GetModifierExtraHealthBonus()
	return self.hp_per_level
end