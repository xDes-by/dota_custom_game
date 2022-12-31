innate_late_bloomer = class({})

LinkLuaModifier("modifier_innate_late_bloomer", "heroes/innates/late_bloomer", LUA_MODIFIER_MOTION_NONE)

function innate_late_bloomer:GetIntrinsicModifierName()
	return "modifier_innate_late_bloomer"
end

modifier_innate_late_bloomer = class({})

function modifier_innate_late_bloomer:IsHidden() return false end
function modifier_innate_late_bloomer:IsDebuff() return false end
function modifier_innate_late_bloomer:IsPurgable() return false end
function modifier_innate_late_bloomer:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_late_bloomer:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_late_bloomer:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.growth_base = ability:GetSpecialValueFor("growth_base")
	self.growth_ramp = ability:GetSpecialValueFor("growth_ramp")

	if IsServer() then 
		local parent = self:GetParent()
		if not parent then return end

		local hero = PlayerResource:GetSelectedHeroEntity(parent:GetPlayerOwnerID())
		if not hero then return end

		if parent:IsTempestDouble() or parent:IsIllusion() then
			local hero_stacks = hero:GetModifierStackCount("modifier_innate_late_bloomer", hero)
			self:SetStackCount(hero_stacks)
			self.growth_bonus = self:CalculateGrowthBonus()
		end
	end
end

function modifier_innate_late_bloomer:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_innate_late_bloomer:OnRoundEndForTeam(keys)
	if (not keys.round) then return end

	local stack = math.floor(keys.round / 10)
	self:SetStackCount(stack)
	self.growth_bonus = self:CalculateGrowthBonus()
end

function modifier_innate_late_bloomer:CalculateGrowthBonus()
	local bonus_growth = self.growth_base + self.growth_ramp * self:GetStackCount()
	return bonus_growth * (self:GetParent():GetLevel() - 1)
end

function modifier_innate_late_bloomer:GetModifierBonusStats_Strength()
	return self.growth_bonus or 0
end

function modifier_innate_late_bloomer:GetModifierBonusStats_Agility()
	return self.growth_bonus or 0
end

function modifier_innate_late_bloomer:GetModifierBonusStats_Intellect()
	return self.growth_bonus or 0
end

function modifier_innate_late_bloomer:OnTooltip()
	return self.growth_base + self.growth_ramp * self:GetStackCount()
end
