modifier_chc_mastery_impatience = class({})

function modifier_chc_mastery_impatience:IsHidden() return true end
function modifier_chc_mastery_impatience:IsDebuff() return false end
function modifier_chc_mastery_impatience:IsPurgable() return false end
function modifier_chc_mastery_impatience:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_impatience:GetTexture() return "masteries/impatience" end

function modifier_chc_mastery_impatience:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end

function modifier_chc_mastery_impatience:GetModifierPercentageCooldown()
	return self.base_cooldown or 0
end



modifier_chc_mastery_impatience_1 = class(modifier_chc_mastery_impatience)
modifier_chc_mastery_impatience_2 = class(modifier_chc_mastery_impatience)
modifier_chc_mastery_impatience_3 = class(modifier_chc_mastery_impatience)

function modifier_chc_mastery_impatience_1:OnCreated(keys)
	self.base_cooldown = 5
end

function modifier_chc_mastery_impatience_2:OnCreated(keys)
	self.base_cooldown = 10
end

function modifier_chc_mastery_impatience_3:OnCreated(keys)
	self.base_cooldown = 18
end
