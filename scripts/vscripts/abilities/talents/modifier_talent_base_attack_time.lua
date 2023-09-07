modifier_talent_base_attack_time = class({})

function modifier_talent_base_attack_time:IsHidden()
	return true
end

function modifier_talent_base_attack_time:IsPurgable()
	return false
end

function modifier_talent_base_attack_time:RemoveOnDeath()
	return false
end
modifier_talent_base_attack_time.value = {0.075, 0.1, 0.125, 0.15, 0.175, 0.2}
function modifier_talent_base_attack_time:OnCreated( kv )
	self.caster = self:GetCaster()
	self.base_attack_time = self.caster:GetBaseAttackTime()
	self.caster:SetBaseAttackTime(self.base_attack_time - self.value[self:GetStackCount()])
end

function modifier_talent_base_attack_time:OnRefresh( kv )
	self.caster:SetBaseAttackTime(self.base_attack_time - self.value[self:GetStackCount()])
end

