modifier_regen = class({})

function modifier_regen:IsHidden()
	return true
end

function modifier_regen:IsDebuff()
	return false
end

function modifier_regen:IsPurgable()
	return false
end

function modifier_regen:OnCreated( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.regen = 5 * level
end

function modifier_regen:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.regen = 5 * level
end

function modifier_regen:OnIntervalThink()
self:OnRefresh()
end


function modifier_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_regen:GetModifierConstantHealthRegen()
	return self.regen
end