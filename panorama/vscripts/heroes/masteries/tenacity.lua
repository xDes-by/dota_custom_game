---@class modifier_chc_mastery_tenacity:CDOTA_Modifier_Lua
modifier_chc_mastery_tenacity = class({})

function modifier_chc_mastery_tenacity:IsHidden() return self:GetStackCount() <= 0 end
function modifier_chc_mastery_tenacity:IsDebuff() return false end
function modifier_chc_mastery_tenacity:IsPurgable() return false end
function modifier_chc_mastery_tenacity:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chc_mastery_tenacity:DestroyOnExpire() return false end

function modifier_chc_mastery_tenacity:GetTexture() return "masteries/tenacity" end

function modifier_chc_mastery_tenacity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_chc_mastery_tenacity:GetModifierStatusResistanceStacking(event)
	if self:GetStackCount() > 0 then 
		return self.tenacity_resist
	end

	local parent = self:GetParent()

	if IsServer() and not parent:HasModifier("modifier_chc_mastery_tenacity_cooldown") then
		parent:AddNewModifier(parent, nil, "modifier_chc_mastery_tenacity_cooldown", {duration = self.tenacity_cooldown})
		
		self:SetStackCount(1)
		self:SetDuration(self.tenacity_duration, true)
		self:StartIntervalThink(self.tenacity_duration)

		return self.tenacity_resist
	end
end

function modifier_chc_mastery_tenacity:OnIntervalThink()
	if IsClient() then return end

	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end

modifier_chc_mastery_tenacity_cooldown = class({})

function modifier_chc_mastery_tenacity_cooldown:IsHidden()
	if IsClient() then
		return self:GetParent():GetPlayerOwnerID() ~= GetLocalPlayerID()
	else
		return false
	end
end

function modifier_chc_mastery_tenacity_cooldown:IsDebuff() return true end
function modifier_chc_mastery_tenacity_cooldown:IsPurgable() return false end
function modifier_chc_mastery_tenacity_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_tenacity_cooldown:GetTexture() return "masteries/tenacity" end

modifier_chc_mastery_tenacity_1 = class(modifier_chc_mastery_tenacity)
modifier_chc_mastery_tenacity_2 = class(modifier_chc_mastery_tenacity)
modifier_chc_mastery_tenacity_3 = class(modifier_chc_mastery_tenacity)

function modifier_chc_mastery_tenacity_1:OnCreated(keys)
	self.tenacity_resist = 45
	self.tenacity_cooldown = 5
	self.tenacity_duration = 2.5
end

function modifier_chc_mastery_tenacity_2:OnCreated(keys)
	self.tenacity_resist = 60
	self.tenacity_cooldown = 5
	self.tenacity_duration = 2.5
end

function modifier_chc_mastery_tenacity_3:OnCreated(keys)
	self.tenacity_resist = 75
	self.tenacity_cooldown = 5
	self.tenacity_duration = 2.5
end
