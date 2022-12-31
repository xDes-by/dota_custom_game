modifier_hero_fighting_pve = class({})

function modifier_hero_fighting_pve:IsHidden() return true end
function modifier_hero_fighting_pve:IsDebuff() return false end
function modifier_hero_fighting_pve:IsPurgable() return false end
function modifier_hero_fighting_pve:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_hero_fighting_pve:GetPriority() return 9999 end

function modifier_hero_fighting_pve:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
end

function modifier_hero_fighting_pve:CheckState()
	return {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end

function modifier_hero_fighting_pve:GetModifierProvidesFOWVision()
	return 1
end

function modifier_hero_fighting_pve:GetModifierSpellAmplify_Percentage()	
	return 0.6 * (self:GetParent():GetIntellect() or 0)
end
