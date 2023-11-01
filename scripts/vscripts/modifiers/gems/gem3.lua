modifier_gem3 = class ({})

function modifier_gem3:GetTexture()
	return "gem_icon/stats"
end

function modifier_gem3:IsHidden()
	return true
end

function modifier_gem3:RemoveOnDeath()
	return false
end

function modifier_gem3:OnCreated(data)
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

function modifier_gem3:OnRefresh(data)
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
		self.tbl_current[ability] = 0
	else
		self.tbl_origin[ability] = (gem_bonus or 0)
		self.tbl_current[ability] = 0
	end
end

function modifier_gem3:OnIntervalThink()
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
		if avg_level == 10 then
			self.value_bonus_to_return = (bonus_per_stone * self.total_bonus * avg_level) / 1.5 * 2
		else
			self.value_bonus_to_return = (bonus_per_stone * self.total_bonus * avg_level) / 1.5 * tonumber("1." .. avg_level)
		end
	else
		self.value_bonus_to_return = 0
	end
	self:SendBuffRefreshToClients()
end

function modifier_gem3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_gem3:GetModifierBonusStats_Agility()
	return self.value_bonus_to_return
end

function modifier_gem3:GetModifierBonusStats_Strength()
	return self.value_bonus_to_return
end

function modifier_gem3:GetModifierBonusStats_Intellect()
	return self.value_bonus_to_return
end

function modifier_gem3:AddCustomTransmitterData()
	return {
		value_bonus_to_return = self.value_bonus_to_return
	}
end

function modifier_gem3:HandleCustomTransmitterData( data )
	self.value_bonus_to_return = data.value_bonus_to_return
end

function modifier_gem3:OnTooltip()
	return self.value_bonus_to_return
end