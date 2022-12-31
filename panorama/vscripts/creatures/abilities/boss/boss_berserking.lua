LinkLuaModifier("modifier_boss_berserking", "creatures/abilities/boss/boss_berserking", LUA_MODIFIER_MOTION_NONE)

boss_berserking = class({})

function boss_berserking:GetIntrinsicModifierName()
	return "modifier_boss_berserking"
end



modifier_boss_berserking = class({})

function modifier_boss_berserking:IsHidden() return false end
function modifier_boss_berserking:IsDebuff() return false end
function modifier_boss_berserking:IsPurgable() return false end
function modifier_boss_berserking:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_boss_berserking:GetEffectName()
	return "particles/creature/rampage.vpcf"
end

function modifier_boss_berserking:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_berserking:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	Timers:CreateTimer(0.1, function()
		if not self.parent or self.parent:IsNull() then return end
		self.current_pos = self.parent:GetAbsOrigin()
		self.current_distance = 0
		self:StartIntervalThink(0.5)
	end)
end

function modifier_boss_berserking:OnIntervalThink()
	if not IsServer() then return end

	local distance_treshold = self.ability:GetSpecialValueFor("movement_per_stack")
	local new_pos = self.parent:GetAbsOrigin()
	local distance_change = (new_pos - self.current_pos):Length2D()

	self.current_pos = new_pos
	self.current_distance = self.current_distance + distance_change

	local difference_multiplier = math.floor(self.current_distance / distance_treshold)
	self.current_distance = self.current_distance - self.current_distance * difference_multiplier
	self:SetStackCount(self:GetStackCount() + difference_multiplier)
end

function modifier_boss_berserking:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_boss_berserking:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_boss_berserking:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("stack_ms") * self:GetStackCount()
end

function modifier_boss_berserking:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("stack_as") * self:GetStackCount()
end
