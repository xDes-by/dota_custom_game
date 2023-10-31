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
	if not IsServer() then
		return
	end
	self.tbl_origin = {}
	self.tbl_current = {}
	local ability = EntIndexToHScript(data.ability)
	local gem_bonus = data.gem_bonus
	self.tbl_origin[ability] = (gem_bonus or 0)
	self:StartIntervalThink(1)
end

function modifier_gem1:OnRefresh(data)
	if not IsServer() then
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
	local total_bonus = 0
	for ability,gem_bonus in pairs(self.tbl_origin) do
		if not ability:IsNull() then
			if not self.parent:FindItemInInventory(ability:GetAbilityName()) then --проверяем предмет в инвентаре
				self.tbl_current[ability] = 0 -- убираем бонус, если не нашли предмета
			else
				self.tbl_current[ability] = self.tbl_origin[ability] -- возвращаем бонус если предмет вернулся в инвентарьь
			end
		end
		total_bonus = total_bonus + self.tbl_current[ability]
	end
	self:SetStackCount(total_bonus)
end

function modifier_gem1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_gem1:OnTakeDamage( keys )
	if self:GetCaster():HasModifier("modifier_gem1") and keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		-- Spell lifesteal handler
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then			
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)

			keys.attacker:HealWithParams(keys.damage * self:GetStackCount() * 0.01, self:GetAbility(), true, true, keys.attacker, true)
		-- Attack lifesteal handler
		else 
			if keys.damage_category == 1 then
			-- Heal and fire the particle			
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			keys.attacker:HealWithParams(keys.damage * self:GetStackCount() * 0.01, self:GetAbility(), true, true, keys.attacker, false)
		end
	end
end
end