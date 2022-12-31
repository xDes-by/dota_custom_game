modifier_chc_mastery_colossus = class({})

function modifier_chc_mastery_colossus:IsHidden() return true end
function modifier_chc_mastery_colossus:IsDebuff() return false end
function modifier_chc_mastery_colossus:IsPurgable() return false end
function modifier_chc_mastery_colossus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_colossus:GetTexture() return "masteries/colossus" end

function modifier_chc_mastery_colossus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}
end

function modifier_chc_mastery_colossus:GetModifierExtraHealthPercentage()
	return self.bonus_hp
end



modifier_chc_mastery_colossus_1 = class(modifier_chc_mastery_colossus)
modifier_chc_mastery_colossus_2 = class(modifier_chc_mastery_colossus)
modifier_chc_mastery_colossus_3 = class(modifier_chc_mastery_colossus)

function modifier_chc_mastery_colossus_1:OnCreated(keys)
	self.bonus_hp = 10

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_colossus_2:OnCreated(keys)
	self.bonus_hp = 20

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_colossus_3:OnCreated(keys)
	self.bonus_hp = 40

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end
