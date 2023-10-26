modifier_talent_mp_regen_level = class({})

function modifier_talent_mp_regen_level:IsHidden()
	return true
end

function modifier_talent_mp_regen_level:IsPurgable()
	return false
end

function modifier_talent_mp_regen_level:RemoveOnDeath()
	return false
end

function modifier_talent_mp_regen_level:OnCreated( kv )
	self.value = {2, 2.5, 3, 3.5, 4, 4.5}
	self.caster = self:GetCaster()
	self.mp_regen_level = self.value[self:GetStackCount()]
end

function modifier_talent_mp_regen_level:OnRefresh( kv )
	self.mp_regen_level = self.value[self:GetStackCount()]	
end

function modifier_talent_mp_regen_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_talent_mp_regen_level:GetModifierConstantManaRegen()
	return self.mp_regen_level
end