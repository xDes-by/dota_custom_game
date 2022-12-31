modifier_chc_mastery_initiative = class({})

function modifier_chc_mastery_initiative:IsHidden() return true end
function modifier_chc_mastery_initiative:IsDebuff() return false end
function modifier_chc_mastery_initiative:IsPurgable() return false end
function modifier_chc_mastery_initiative:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_initiative:GetTexture() return "masteries/initiative" end

function modifier_chc_mastery_initiative:OnRoundStart(keys)
	local parent = self:GetParent()
	local buff = parent:AddNewModifier(parent, nil, "modifier_chc_mastery_initiative_buff", {duration = self.duration})
	
	if buff then
		buff:SetStackCount(self.bonus_ms)
	end
end

function modifier_chc_mastery_initiative:OnPvpStart(keys)
	local parent = self:GetParent()
	local team = parent:GetTeam()

	if table.contains(keys.teams, team) then
		local buff = parent:AddNewModifier(parent, nil, "modifier_chc_mastery_initiative_buff", {duration = self.duration})

		if buff then
			buff:SetStackCount(self.bonus_ms)
		end
	end
end



modifier_chc_mastery_initiative_buff = class({})

function modifier_chc_mastery_initiative_buff:IsHidden() return false end
function modifier_chc_mastery_initiative_buff:IsDebuff() return false end
function modifier_chc_mastery_initiative_buff:IsPurgable() return false end

function modifier_chc_mastery_initiative_buff:GetTexture() return "masteries/initiative" end

function modifier_chc_mastery_initiative_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_chc_mastery_initiative_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_chc_mastery_initiative_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_chc_mastery_initiative_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end



modifier_chc_mastery_initiative_1 = class(modifier_chc_mastery_initiative)
modifier_chc_mastery_initiative_2 = class(modifier_chc_mastery_initiative)
modifier_chc_mastery_initiative_3 = class(modifier_chc_mastery_initiative)

function modifier_chc_mastery_initiative_1:OnCreated(keys)
	self.bonus_ms = 75
	self.duration = 8.0
end

function modifier_chc_mastery_initiative_2:OnCreated(keys)
	self.bonus_ms = 150
	self.duration = 8.0
end

function modifier_chc_mastery_initiative_3:OnCreated(keys)
	self.bonus_ms = 300
	self.duration = 8.0
end

function modifier_chc_mastery_initiative_3:CheckState()
	return { [MODIFIER_STATE_NO_UNIT_COLLISION] = true }
end
