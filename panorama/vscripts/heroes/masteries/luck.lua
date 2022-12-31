modifier_chc_mastery_luck = class({})

function modifier_chc_mastery_luck:IsHidden() return true end
function modifier_chc_mastery_luck:IsDebuff() return false end
function modifier_chc_mastery_luck:IsPurgable() return false end
function modifier_chc_mastery_luck:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_luck:GetTexture() return "masteries/luck" end



modifier_chc_mastery_luck_1 = class(modifier_chc_mastery_luck)
modifier_chc_mastery_luck_2 = class(modifier_chc_mastery_luck)
modifier_chc_mastery_luck_3 = class(modifier_chc_mastery_luck)

function modifier_chc_mastery_luck_1:OnCreated(keys)
	self.crit_chance = 20
	self.crit_damage = 1.2
end

function modifier_chc_mastery_luck_2:OnCreated(keys)
	self.crit_chance = 20
	self.crit_damage = 1.4
end

function modifier_chc_mastery_luck_3:OnCreated(keys)
	self.crit_chance = 20
	self.crit_damage = 1.8
end
