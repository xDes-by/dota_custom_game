modifier_talent_hp_regen_level = class({})

function modifier_talent_hp_regen_level:IsHidden()
	return true
end

function modifier_talent_hp_regen_level:IsPurgable()
	return false
end

function modifier_talent_hp_regen_level:RemoveOnDeath()
	return false
end
modifier_talent_hp_regen_level.value = {1, 2, 3, 4, 5, 6}
function modifier_talent_hp_regen_level:OnCreated( kv )
	self.caster = self:GetCaster()
	self.hp_regen_level = self.value[self:GetStackCount()]
end

function modifier_talent_hp_regen_level:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.hp_regen_level = self.value[self:GetStackCount()]	
end

function modifier_talent_hp_regen_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_talent_hp_regen_level:GetModifierConstantHealthRegen()
	return self.hp_regen_level
end