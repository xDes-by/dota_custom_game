modifier_chc_mastery_summon_power = class({})

function modifier_chc_mastery_summon_power:IsHidden() return true end
function modifier_chc_mastery_summon_power:IsDebuff() return false end
function modifier_chc_mastery_summon_power:IsPurgable() return false end
function modifier_chc_mastery_summon_power:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_summon_power:GetTexture() return "masteries/summon_power" end

function modifier_chc_mastery_summon_power:GetBonusSummonPower()
	return self.bonus_power
end

modifier_chc_mastery_summon_power_1 = class(modifier_chc_mastery_summon_power)
modifier_chc_mastery_summon_power_2 = class(modifier_chc_mastery_summon_power)
modifier_chc_mastery_summon_power_3 = class(modifier_chc_mastery_summon_power)

function modifier_chc_mastery_summon_power_1:OnCreated(keys)
	self.bonus_power = 5
end

function modifier_chc_mastery_summon_power_2:OnCreated(keys)
	self.bonus_power = 10
end

function modifier_chc_mastery_summon_power_3:OnCreated(keys)
	self.bonus_power = 20
end
