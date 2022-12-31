LinkLuaModifier("modifier_creature_desecrate_aura", "creatures/abilities/regular/creature_desecrate_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_desecrate_aura_debuff", "creatures/abilities/regular/creature_desecrate_aura", LUA_MODIFIER_MOTION_NONE)

creature_desecrate_aura = class({})

function creature_desecrate_aura:GetIntrinsicModifierName()
	return "modifier_creature_desecrate_aura"
end



modifier_creature_desecrate_aura = class({})

function modifier_creature_desecrate_aura:IsHidden() return true end
function modifier_creature_desecrate_aura:IsDebuff() return false end
function modifier_creature_desecrate_aura:IsPurgable() return false end
function modifier_creature_desecrate_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_desecrate_aura:IsAura() return true end
function modifier_creature_desecrate_aura:GetAuraRadius() return 1200 end
function modifier_creature_desecrate_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_desecrate_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_desecrate_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_desecrate_aura:GetModifierAura() return "modifier_creature_desecrate_aura_debuff" end

function modifier_creature_desecrate_aura:GetEffectName()
	return "particles/creature/desecrate_aura.vpcf"
end

function modifier_creature_desecrate_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_desecrate_aura_debuff = class({})

function modifier_creature_desecrate_aura_debuff:IsHidden() return false end
function modifier_creature_desecrate_aura_debuff:IsDebuff() return true end
function modifier_creature_desecrate_aura_debuff:IsPurgable() return false end

function modifier_creature_desecrate_aura_debuff:OnCreated()
	self.armor = 100 + self:GetAbility():GetSpecialValueFor("armor")
end

function modifier_creature_desecrate_aura_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE
	}
end

function modifier_creature_desecrate_aura_debuff:GetModifierPhysicalArmorBase_Percentage()
	return self.armor
end
