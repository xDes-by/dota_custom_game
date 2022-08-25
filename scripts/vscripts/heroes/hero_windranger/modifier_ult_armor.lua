modifier_ult_armor = class({})

function modifier_ult_armor:IsHidden()
	return true
end

function modifier_ult_armor:IsDebuff()
	return false
end

function modifier_ult_armor:IsPurgable()
	return false
end

function modifier_ult_armor:OnCreated( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = 5 * level
end

function modifier_ult_armor:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = 5 * level
end

function modifier_ult_armor:OnIntervalThink()
self:OnRefresh()
end

function modifier_ult_armor:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_ult_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_ult_armor:GetModifierPhysicalArmorBonus()
	return self.armor
end