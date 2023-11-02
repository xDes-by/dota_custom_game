modifier_gem4 = class ({})

function modifier_gem4:GetTexture()
	return "gem_icon/damage"
end

function modifier_gem4:IsHidden()
	return true
end

function modifier_gem4:RemoveOnDeath()
	return false
end

function modifier_gem4:OnCreated(data)
	self.parent = self:GetParent()
	self.bonus = {150,300,450,600,750,900,1050,1200,1350,1500}
	if not IsServer() then
		return
	end
	self.tbl_origin = {}
	self.tbl_current = {}
	local ability = EntIndexToHScript(data.ability)
	local gem_bonus = data.gem_bonus
	self.tbl_origin[ability] = (gem_bonus or 0)
	self:SetHasCustomTransmitterData( true )
	self:StartIntervalThink(1)
end

function modifier_gem4:OnRefresh(data)
	if not IsServer() then
		return
	end
	if not data.ability then
		return
	end
	local gem_bonus = data.gem_bonus
	local ability = EntIndexToHScript(data.ability)
	if self.tbl_origin[ability] then
		self.tbl_origin[ability] = self.tbl_origin[ability] + (gem_bonus or 0)
	else
		self.tbl_origin[ability] = (gem_bonus or 0)
	end
end

function modifier_gem4:OnIntervalThink()
	self.total_bonus = 0
	self.itms_count = 0
	self.sum_ability_level = 0
	self.max_bonus = 0
	for ability,gem_bonus in pairs(self.tbl_origin) do
		if ability:IsNull() or not self.parent:FindItemInInventory(ability:GetAbilityName()) then --проверяем предмет в инвентаре
			self.tbl_current[ability] = 0 -- убираем бонус, если не нашли предмета
		else
			self.tbl_current[ability] = self.tbl_origin[ability] -- возвращаем бонус если предмет вернулся в инвентарьь
			self.sum_ability_level = self.sum_ability_level + ability:GetLevel()
			self.itms_count = self.itms_count + 1
			self.max_bonus = self.max_bonus + self.bonus[ability:GetLevel()]
		end
		self.total_bonus = self.total_bonus + self.tbl_current[ability]
	end
	if self.max_bonus ~= 0 then
		local bonus_per_stone = self.max_bonus / (self.max_bonus + self.total_bonus)
		local avg_level = self.sum_ability_level / self.itms_count
		self.value_bonus_to_return = bonus_per_stone * self.total_bonus * avg_level
	else
		self.value_bonus_to_return = 0
	end
	self:SendBuffRefreshToClients()
end

function modifier_gem4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_gem4:GetModifierBaseAttack_BonusDamage()
	return self.value_bonus_to_return
end

function modifier_gem4:AddCustomTransmitterData()
	return {
		value_bonus_to_return = self.value_bonus_to_return
	}
end

function modifier_gem4:HandleCustomTransmitterData( data )
	self.value_bonus_to_return = data.value_bonus_to_return
end

function modifier_gem4:OnTooltip()
	return self.value_bonus_to_return
end