modifier_enfos_high_ground = class({})

function modifier_enfos_high_ground:IsHidden() return self:GetStackCount() == 1 end
function modifier_enfos_high_ground:IsDebuff() return false end
function modifier_enfos_high_ground:IsPurgable() return false end
function modifier_enfos_high_ground:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_enfos_high_ground:GetTexture() return "windrunner_windrun" end

function modifier_enfos_high_ground:OnCreated(keys)
	if IsServer() then self:StartIntervalThink(0.25) end
end

function modifier_enfos_high_ground:OnIntervalThink()
	if (not self:GetParent():IsDueling()) and self:GetParent():GetAbsOrigin().z > 650 then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

function modifier_enfos_high_ground:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_enfos_high_ground:GetModifierMoveSpeedBonus_Constant()
	return 200 * (1 - self:GetStackCount())
end

function modifier_enfos_high_ground:GetModifierIgnoreMovespeedLimit()
	return (1 - self:GetStackCount())
end
