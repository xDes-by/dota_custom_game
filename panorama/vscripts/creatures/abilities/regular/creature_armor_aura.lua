LinkLuaModifier("modifier_creature_armor_aura", "creatures/abilities/regular/creature_armor_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_armor_aura_buff", "creatures/abilities/regular/creature_armor_aura", LUA_MODIFIER_MOTION_NONE)

creature_armor_aura = class({})

function creature_armor_aura:GetIntrinsicModifierName()
	return "modifier_creature_armor_aura"
end



modifier_creature_armor_aura = class({})

function modifier_creature_armor_aura:IsHidden() return true end
function modifier_creature_armor_aura:IsDebuff() return false end
function modifier_creature_armor_aura:IsPurgable() return false end
function modifier_creature_armor_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_armor_aura:IsAura() return true end
function modifier_creature_armor_aura:GetAuraRadius() return 1200 end
function modifier_creature_armor_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_armor_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_armor_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_armor_aura:GetModifierAura() return "modifier_creature_armor_aura_buff" end

function modifier_creature_armor_aura:GetEffectName()
	return "particles/creature/armor_aura.vpcf"
end

function modifier_creature_armor_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_armor_aura_buff = class({})

function modifier_creature_armor_aura_buff:IsHidden() return false end
function modifier_creature_armor_aura_buff:IsDebuff() return false end
function modifier_creature_armor_aura_buff:IsPurgable() return false end

function modifier_creature_armor_aura_buff:OnCreated()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_creature_armor_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_creature_armor_aura_buff:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
