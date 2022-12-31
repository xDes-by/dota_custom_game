LinkLuaModifier("modifier_creature_necro_archer", "creatures/abilities/regular/creature_necro_archer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_necro_archer_buff", "creatures/abilities/regular/creature_necro_archer", LUA_MODIFIER_MOTION_NONE)

creature_necro_archer = class({})

function creature_necro_archer:GetIntrinsicModifierName()
	return "modifier_creature_necro_archer"
end



modifier_creature_necro_archer = class({})

function modifier_creature_necro_archer:IsHidden() return true end
function modifier_creature_necro_archer:IsDebuff() return false end
function modifier_creature_necro_archer:IsPurgable() return false end
function modifier_creature_necro_archer:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_necro_archer:IsAura() return true end
function modifier_creature_necro_archer:GetAuraRadius() return 1500 end
function modifier_creature_necro_archer:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_necro_archer:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_necro_archer:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_necro_archer:GetModifierAura() return "modifier_creature_necro_archer_buff" end

function modifier_creature_necro_archer:GetAuraEntityReject(unit)
	return (unit and unit == self:GetParent())
end

function modifier_creature_necro_archer:GetEffectName()
	return "particles/creature/necro_archer_aura.vpcf"
end

function modifier_creature_necro_archer:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_necro_archer_buff = class({})

function modifier_creature_necro_archer_buff:IsHidden() return false end
function modifier_creature_necro_archer_buff:IsDebuff() return false end
function modifier_creature_necro_archer_buff:IsPurgable() return false end

function modifier_creature_necro_archer_buff:OnCreated()
	self.bonus_as = 0.01 * self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_creature_necro_archer_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_creature_necro_archer_buff:GetModifierAttackSpeedPercentage()
	return self.bonus_as
end

function modifier_creature_necro_archer_buff:OnTooltip()
	return 100 * self.bonus_as
end
