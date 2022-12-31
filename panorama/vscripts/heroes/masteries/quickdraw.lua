modifier_chc_mastery_quickdraw = class({})

function modifier_chc_mastery_quickdraw:IsHidden() return self:GetStackCount() <= 0 end
function modifier_chc_mastery_quickdraw:IsDebuff() return false end
function modifier_chc_mastery_quickdraw:IsPurgable() return false end
function modifier_chc_mastery_quickdraw:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_quickdraw:GetTexture() return "masteries/quickdraw" end

function modifier_chc_mastery_quickdraw:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chc_mastery_quickdraw:GetModifierTotalDamageOutgoing_Percentage(keys)
	if self:GetStackCount() <= 0 then return 0 end

	if IsClient() then
		return self.bonus_damage or 0
	else
		if keys.attacker and keys.target then
			return self.bonus_damage or 0
		end
	end

	return 0
end

function modifier_chc_mastery_quickdraw:OnTooltip()
	return self:GetStackCount()
end

function modifier_chc_mastery_quickdraw:OnRoundStart(keys)
	if IsClient() then return end
	if GameMode:IsPlayerDueling(self:GetParent():GetPlayerOwnerID()) then return end

	self:SetStackCount(6)
	self:StartIntervalThink(1.0)
end

function modifier_chc_mastery_quickdraw:OnPvpStart(keys)
	if IsClient() then return end
	if not GameMode:IsPlayerDueling(self:GetParent():GetPlayerOwnerID()) then return end

	self:SetStackCount(6)
	self:StartIntervalThink(1.0)
end

function modifier_chc_mastery_quickdraw:OnRoundEndForTeam(keys)
	if IsClient() then return end

	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end

function modifier_chc_mastery_quickdraw:OnIntervalThink()
	if IsClient() then return end

	self:DecrementStackCount()

	if self:GetStackCount() <= 0 then self:StartIntervalThink(-1) end
end



modifier_chc_mastery_quickdraw_1 = class(modifier_chc_mastery_quickdraw)
modifier_chc_mastery_quickdraw_2 = class(modifier_chc_mastery_quickdraw)
modifier_chc_mastery_quickdraw_3 = class(modifier_chc_mastery_quickdraw)

function modifier_chc_mastery_quickdraw_1:OnCreated(keys)
	self.bonus_damage = 22.5
end

function modifier_chc_mastery_quickdraw_2:OnCreated(keys)
	self.bonus_damage = 45
end

function modifier_chc_mastery_quickdraw_3:OnCreated(keys)
	self.bonus_damage = 90
end
