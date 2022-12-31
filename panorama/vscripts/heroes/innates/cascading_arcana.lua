innate_cascading_arcana = class({})

LinkLuaModifier("modifier_innate_cascading_arcana", "heroes/innates/cascading_arcana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_cascading_arcana_aura", "heroes/innates/cascading_arcana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_cascading_arcana_debuff", "heroes/innates/cascading_arcana", LUA_MODIFIER_MOTION_NONE)

function innate_cascading_arcana:GetIntrinsicModifierName()
	return "modifier_innate_cascading_arcana"
end



modifier_innate_cascading_arcana = class({})

function modifier_innate_cascading_arcana:IsHidden() return true end
function modifier_innate_cascading_arcana:IsDebuff() return false end
function modifier_innate_cascading_arcana:IsPurgable() return false end
function modifier_innate_cascading_arcana:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_cascading_arcana:IsAura() return true end
function modifier_innate_cascading_arcana:GetAuraRadius() return 1200 end
function modifier_innate_cascading_arcana:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_innate_cascading_arcana:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO  end
function modifier_innate_cascading_arcana:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_innate_cascading_arcana:GetModifierAura() return "modifier_innate_cascading_arcana_aura" end



modifier_innate_cascading_arcana_aura = class({})

function modifier_innate_cascading_arcana_aura:DeclareFunctions()
	if IsServer() then return { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE } end
end

function modifier_innate_cascading_arcana_aura:IsHidden() return true end
function modifier_innate_cascading_arcana_aura:IsDebuff() return true end
function modifier_innate_cascading_arcana_aura:IsPurgable() return false end
function modifier_innate_cascading_arcana_aura:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_innate_cascading_arcana_aura:GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then return end

	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if (not caster) or (not ability) or caster:IsNull() or ability:IsNull() or caster ~= keys.attacker then return end

	if keys.damage_category and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		local debuff_modifier = self:GetParent():AddNewModifier(caster, ability, "modifier_innate_cascading_arcana_debuff", {})
		if debuff_modifier then debuff_modifier:IncrementStackCount() end
	end
end



modifier_innate_cascading_arcana_debuff = class({})

function modifier_innate_cascading_arcana_debuff:IsHidden() return false end
function modifier_innate_cascading_arcana_debuff:IsDebuff() return true end
function modifier_innate_cascading_arcana_debuff:IsPurgable() return false end
function modifier_innate_cascading_arcana_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_cascading_arcana_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.reduction_stack = ability:GetSpecialValueFor("reduction_stack")
	self.reduction_max = ability:GetSpecialValueFor("reduction_max")

	if IsClient() then return end

	self.debuff_pfx = ParticleManager:CreateParticle("particles/custom/innates/cascading_arcana_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.debuff_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(self.debuff_pfx, 2, Vector(1,0,0))
end

function modifier_innate_cascading_arcana_debuff:OnStackCountChanged()
	if self.debuff_pfx then
		ParticleManager:SetParticleControl(self.debuff_pfx, 2, Vector(self:GetStackCount(),0,0))
	end
end

function modifier_innate_cascading_arcana_debuff:OnDestroy()
	if IsClient() then return end

	if self.debuff_pfx then
		ParticleManager:DestroyParticle(self.debuff_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.debuff_pfx)
	end
end

function modifier_innate_cascading_arcana_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_innate_cascading_arcana_debuff:GetModifierMagicalResistanceBonus()
	return -math.min(self:GetStackCount() * self.reduction_stack, self.reduction_max)
end

function modifier_innate_cascading_arcana_debuff:OnTooltip()
	return math.min(self:GetStackCount() * self.reduction_stack, self.reduction_max)
end

function modifier_innate_cascading_arcana_debuff:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_cascading_arcana_debuff:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:Destroy()
end
