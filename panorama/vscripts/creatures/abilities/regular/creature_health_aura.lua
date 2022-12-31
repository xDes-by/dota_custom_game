LinkLuaModifier("modifier_creature_health_aura", "creatures/abilities/regular/creature_health_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_health_aura_buff", "creatures/abilities/regular/creature_health_aura", LUA_MODIFIER_MOTION_NONE)

creature_health_aura = class({})

function creature_health_aura:GetIntrinsicModifierName()
	return "modifier_creature_health_aura"
end



modifier_creature_health_aura = class({})

function modifier_creature_health_aura:IsHidden() return true end
function modifier_creature_health_aura:IsDebuff() return false end
function modifier_creature_health_aura:IsPurgable() return false end
function modifier_creature_health_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_health_aura:IsAura() return true end
function modifier_creature_health_aura:GetAuraRadius() return 1200 end
function modifier_creature_health_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_health_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_health_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_health_aura:GetModifierAura() return "modifier_creature_health_aura_buff" end

function modifier_creature_health_aura:GetAuraEntityReject(unit)
	return unit == self:GetParent()
end

function modifier_creature_health_aura:GetEffectName()
	return "particles/creature/health_aura.vpcf"
end

function modifier_creature_health_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_health_aura_buff = class({})

function modifier_creature_health_aura_buff:IsHidden() return false end
function modifier_creature_health_aura_buff:IsDebuff() return false end
function modifier_creature_health_aura_buff:IsPurgable() return false end

function modifier_creature_health_aura_buff:OnCreated()
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
end

function modifier_creature_health_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_creature_health_aura_buff:GetModifierHealthRegenPercentage()
	return self.health_regen
end
