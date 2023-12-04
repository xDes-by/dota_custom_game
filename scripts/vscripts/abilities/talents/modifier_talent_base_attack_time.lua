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

function modifier_talent_base_attack_time:OnCreated()
	self.value = {0.075, 0.1, 0.125, 0.15, 0.175, 0.2}
	self.parent = self:GetParent()
	if not IsServer() then
		return
	end
	self.base_attack_time = self.parent:GetBaseAttackTime()
	self:SetStackCount(1)
end

function modifier_talent_base_attack_time:OnRefresh()
	if not IsServer() then
		return
	end
	self.parent:SetBaseAttackTime(self.base_attack_time - self.value[self:GetStackCount()])
end

function modifier_talent_base_attack_time:OnStackCountChanged()
	self:OnRefresh()
end