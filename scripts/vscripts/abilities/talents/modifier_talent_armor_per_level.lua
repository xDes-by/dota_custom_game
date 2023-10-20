modifier_talent_armor_per_level = class({})

function modifier_talent_armor_per_level:IsHidden()
	return true
end

function modifier_talent_armor_per_level:IsPurgable()
	return false
end

function modifier_talent_armor_per_level:RemoveOnDeath()
	return false
end
modifier_talent_armor_per_level.value = {0.5, 0.75, 1, 1.25, 1.5, 2}
function modifier_talent_armor_per_level:OnCreated( kv )
	self.caster = self:GetCaster()
	self.armor_per_level = self.value[self:GetStackCount()]
end

function modifier_talent_armor_per_level:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.armor_per_level = self.value[self:GetStackCount()]	
end

function modifier_talent_armor_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_talent_armor_per_level:GetModifierPhysicalArmorBonus()
	return self.armor_per_level
end