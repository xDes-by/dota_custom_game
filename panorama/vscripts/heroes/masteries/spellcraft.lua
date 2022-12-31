modifier_chc_mastery_spellcraft = class({})

function modifier_chc_mastery_spellcraft:IsHidden() return true end
function modifier_chc_mastery_spellcraft:IsDebuff() return false end
function modifier_chc_mastery_spellcraft:IsPurgable() return false end
function modifier_chc_mastery_spellcraft:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_spellcraft:GetTexture() return "masteries/spellcraft" end

function modifier_chc_mastery_spellcraft:OnDestroy()
	if IsClient() then return end

	self:GetParent().spellcraft_multiplier = nil
end



modifier_chc_mastery_spellcraft_1 = class(modifier_chc_mastery_spellcraft)
modifier_chc_mastery_spellcraft_2 = class(modifier_chc_mastery_spellcraft)
modifier_chc_mastery_spellcraft_3 = class(modifier_chc_mastery_spellcraft)

function modifier_chc_mastery_spellcraft_1:OnCreated(keys)
	if IsClient() then return end

	self:GetParent().spellcraft_multiplier = 1.075
end

function modifier_chc_mastery_spellcraft_2:OnCreated(keys)
	if IsClient() then return end

	self:GetParent().spellcraft_multiplier = 1.15
end

function modifier_chc_mastery_spellcraft_3:OnCreated(keys)
	if IsClient() then return end

	self:GetParent().spellcraft_multiplier = 1.3
end
