innate_one_man_army = class({})

LinkLuaModifier("modifier_innate_one_man_army", "heroes/innates/one_man_army", LUA_MODIFIER_MOTION_NONE)

function innate_one_man_army:GetIntrinsicModifierName()
	return "modifier_innate_one_man_army"
end



modifier_innate_one_man_army = class({})

function modifier_innate_one_man_army:IsHidden() return true end
function modifier_innate_one_man_army:IsDebuff() return false end
function modifier_innate_one_man_army:IsPurgable() return false end
function modifier_innate_one_man_army:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_one_man_army:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_one_man_army:OnRefresh(keys)
	if IsClient() then return end

	self.damage_out = self:GetAbility():GetSpecialValueFor("damage_out")
	self.damage_in = self:GetAbility():GetSpecialValueFor("damage_in")
end

function modifier_innate_one_man_army:DeclareFunctions()
	if IsServer() and self:GetParent():IsIllusion() then
		return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
		}
	end
end

function modifier_innate_one_man_army:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage_out
end

function modifier_innate_one_man_army:GetModifierIncomingDamage_Percentage()
	return self.damage_in
end
