modifier_talent_magic_damage = class({})

function modifier_talent_magic_damage:IsHidden()
	return true
end

function modifier_talent_magic_damage:IsPurgable()
	return false
end

function modifier_talent_magic_damage:RemoveOnDeath()
	return false
end
modifier_talent_magic_damage.value = {6, 8, 10, 12, 14, 16}
function modifier_talent_magic_damage:OnCreated()
	self.caster = self:GetCaster()
	self.magic_damage_level = self.value[self:GetStackCount()]
end

function modifier_talent_magic_damage:OnRefresh()
	self.magic_damage_level = self.value[self:GetStackCount()]	
end

function modifier_talent_magic_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

function modifier_talent_magic_damage:GetModifierSpellAmplify_Percentage()
	return self.magic_damage_level
end