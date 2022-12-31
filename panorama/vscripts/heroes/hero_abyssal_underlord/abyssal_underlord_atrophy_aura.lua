modifier_abyssal_underlord_atrophy_aura_effect_perma = class({})

function modifier_abyssal_underlord_atrophy_aura_effect_perma:IsHidden() return false end
function modifier_abyssal_underlord_atrophy_aura_effect_perma:IsDebuff() return false end
function modifier_abyssal_underlord_atrophy_aura_effect_perma:IsPurgable() return false end
function modifier_abyssal_underlord_atrophy_aura_effect_perma:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_abyssal_underlord_atrophy_aura_effect_perma:OnCreated()
	if IsServer() then self:StartIntervalThink(0.5) end
end

function modifier_abyssal_underlord_atrophy_aura_effect_perma:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if (not caster) or (not parent) or (not ability) then
		self:Destroy()
	elseif caster:GetRangeToUnit(parent) > ability:GetSpecialValueFor("radius") then
		self:Destroy()
	end
end

function modifier_abyssal_underlord_atrophy_aura_effect_perma:DeclareFunctions()
	if IsServer() then return { MODIFIER_EVENT_ON_DEATH } end
end

function modifier_abyssal_underlord_atrophy_aura_effect_perma:OnDeath(keys)
	if keys.unit ~= self:GetParent() then return end

	local caster = self:GetCaster()
	local unit = self:GetParent()
	local ability = self:GetAbility()

	if caster and caster:IsIllusion() then
		caster = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
	end

	if caster and ability and not (caster:IsNull() or ability:IsNull()) and ability:GetLevel() > 0 then
		if caster:FindModifierByName("modifier_abyssal_underlord_atrophy_aura_hero_permanent_buff") == nil then
			caster:AddNewModifier(caster, ability, "modifier_abyssal_underlord_atrophy_aura_hero_permanent_buff", {})
		end
		local mod = caster:FindModifierByName("modifier_abyssal_underlord_atrophy_aura_hero_permanent_buff")

		if unit:IsRealHero() then
			mod:SetStackCount(mod:GetStackCount() + ability:GetSpecialValueFor("perma_damage_hero"))
		elseif unit:IsAncient() then
			mod:SetStackCount(mod:GetStackCount() + ability:GetSpecialValueFor("perma_damage_ancient"))
		else
			mod:SetStackCount(mod:GetStackCount() + ability:GetSpecialValueFor("perma_damage_creep"))
		end
	end

	self:Destroy()
end
