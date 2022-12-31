---@class modifier_chc_mastery_sprinter:CDOTA_Modifier_Lua
modifier_chc_mastery_sprinter = class({})

function modifier_chc_mastery_sprinter:IsHidden() return true end
function modifier_chc_mastery_sprinter:IsDebuff() return false end
function modifier_chc_mastery_sprinter:IsPurgable() return false end
function modifier_chc_mastery_sprinter:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_sprinter:GetTexture() return "masteries/sprinter" end

function modifier_chc_mastery_sprinter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_chc_mastery_sprinter:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms or 0
end

function modifier_chc_mastery_sprinter:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage_bonus or 0
end

function modifier_chc_mastery_sprinter:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_chc_mastery_sprinter:OnIntervalThink()
	self.damage_bonus =  self:GetParent():GetIdealSpeed() / self.speed_step * self.bonus_outgoing_damage
end


---@type modifier_chc_mastery_sprinter
modifier_chc_mastery_sprinter_1 = class(modifier_chc_mastery_sprinter)
modifier_chc_mastery_sprinter_2 = class(modifier_chc_mastery_sprinter)
modifier_chc_mastery_sprinter_3 = class(modifier_chc_mastery_sprinter)

function modifier_chc_mastery_sprinter_1:OnCreated(keys)
	self.bonus_ms = 75
	self.bonus_outgoing_damage = 1
	self.speed_step = 100

	self:StartIntervalThink(0.5)
end

function modifier_chc_mastery_sprinter_2:OnCreated(keys)
	self.bonus_ms = 125
	self.bonus_outgoing_damage = 2
	self.speed_step = 100

	self:StartIntervalThink(0.5)
end

function modifier_chc_mastery_sprinter_3:OnCreated(keys)
	self.bonus_ms = 200
	self.bonus_outgoing_damage = 4
	self.speed_step = 100

	self:StartIntervalThink(0.5)
end
