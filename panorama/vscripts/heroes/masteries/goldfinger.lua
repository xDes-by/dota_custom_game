modifier_chc_mastery_goldfinger = class({})

function modifier_chc_mastery_goldfinger:IsHidden() return true end
function modifier_chc_mastery_goldfinger:IsDebuff() return false end
function modifier_chc_mastery_goldfinger:IsPurgable() return false end
function modifier_chc_mastery_goldfinger:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_goldfinger:GetTexture() return "masteries/goldfinger" end

function modifier_chc_mastery_goldfinger:GetModifierCreepGoldAmplification()
	return self.bonus_gold or 0
end

function modifier_chc_mastery_goldfinger:GetModifierBetGoldAmplification()
	return self.bonus_gold or 0
end

function modifier_chc_mastery_goldfinger:GetModifierDuelGoldAmplification()
	return self.bonus_gold or 0
end



modifier_chc_mastery_goldfinger_1 = class(modifier_chc_mastery_goldfinger)
modifier_chc_mastery_goldfinger_2 = class(modifier_chc_mastery_goldfinger)
modifier_chc_mastery_goldfinger_3 = class(modifier_chc_mastery_goldfinger)

function modifier_chc_mastery_goldfinger_1:OnCreated(keys)
	self.bonus_gold = 7
end

function modifier_chc_mastery_goldfinger_2:OnCreated(keys)
	self.bonus_gold = 14
end

function modifier_chc_mastery_goldfinger_3:OnCreated(keys)
	self.bonus_gold = 28
end
