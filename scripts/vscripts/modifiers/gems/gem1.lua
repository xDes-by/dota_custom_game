modifier_gem1 = class ({})

function modifier_gem1:GetTexture()
	return "gem_icon/lifesteal"
end

function modifier_gem1:IsHidden()
	return true
end

function modifier_gem1:RemoveOnDeath()
	return false
end

function modifier_gem1:OnCreated(data)
	self.parent = self:GetParent()
	self.bonus = {150,300,450,600,750,900,1050,1200,1350,1500,100000}
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

function modifier_gem1:OnRefresh(data)
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

function modifier_gem1:OnIntervalThink()
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
		self.value_bonus_to_return = (bonus_per_stone * self.total_bonus * avg_level) / 5 * 0.01
	else
		self.value_bonus_to_return = 0
	end
	self:SendBuffRefreshToClients()
end

function modifier_gem1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_gem1:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then			
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			keys.attacker:HealWithParams(keys.damage * self:OnTooltip() * 0.01, self:GetAbility(), true, true, keys.attacker, true)
		-- Attack lifesteal handler
		else 
			if keys.damage_category == 1 then
				-- Heal and fire the particle			
				self.lifesteal_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
				ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
				
				keys.attacker:HealWithParams(keys.damage * self:OnTooltip() * 0.01, self:GetAbility(), true, true, keys.attacker, false)
			end
		end
	end
end

function modifier_gem1:AddCustomTransmitterData()
	return {
		value_bonus_to_return = self.value_bonus_to_return
	}
end

function modifier_gem1:HandleCustomTransmitterData( data )
	self.value_bonus_to_return = data.value_bonus_to_return
end

function modifier_gem1:OnTooltip()
	return self.value_bonus_to_return
end