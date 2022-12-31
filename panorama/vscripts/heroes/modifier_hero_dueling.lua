modifier_hero_dueling = class({})

function modifier_hero_dueling:IsHidden() return true end
function modifier_hero_dueling:IsDebuff() return false end
function modifier_hero_dueling:IsPurgable() return false end
function modifier_hero_dueling:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_hero_dueling:OnCreated()
	if IsClient() then return end

	self.parent = self:GetParent()

	if (not self.parent) or self.parent:IsNull() then return end

	if Enfos:IsEnfosMode() then
		self.parent:AddNewModifier(self.parent, nil, "modifier_hero_pre_duel_frozen", {duration = 3})
	else
		self.parent:AddNewModifier(self.parent, nil, "modifier_hero_pre_duel_frozen", {})
	end
end

function modifier_hero_dueling:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_hero_dueling:GetModifierSpellAmplify_Percentage()
	if self.parent and (not self.parent:IsNull()) and self.parent.GetIntellect then
		return self.parent:GetIntellect() * 0.3
	end
end
