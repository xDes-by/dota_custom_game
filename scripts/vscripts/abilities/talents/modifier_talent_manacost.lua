modifier_talent_manacost = class({})

function modifier_talent_manacost:IsHidden()
	return true
end

function modifier_talent_manacost:IsPurgable()
	return false
end

function modifier_talent_manacost:RemoveOnDeath()
	return false
end

function modifier_talent_manacost:OnCreated( kv )
	self.value = {0.075, 0.1, 0.125, 0.15, 0.175, 0.2}
	self.caster = self:GetCaster()
	self.manacost_level = self.value[self:GetStackCount()]
end

function modifier_talent_manacost:OnRefresh( kv )
	self.manacost_level = self.value[self:GetStackCount()]
end

function modifier_talent_manacost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end

function modifier_talent_manacost:GetModifierSpellAmplify_Percentage()
	return self.manacost_level
end