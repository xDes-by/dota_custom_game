LinkLuaModifier("modifier_creature_solidity_aura", "creatures/abilities/regular/creature_solidity_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_solidity_aura_buff", "creatures/abilities/regular/creature_solidity_aura", LUA_MODIFIER_MOTION_NONE)

creature_solidity_aura = class({})

function creature_solidity_aura:GetIntrinsicModifierName()
	return "modifier_creature_solidity_aura"
end



modifier_creature_solidity_aura = class({})

function modifier_creature_solidity_aura:IsHidden() return true end
function modifier_creature_solidity_aura:IsDebuff() return false end
function modifier_creature_solidity_aura:IsPurgable() return false end
function modifier_creature_solidity_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_solidity_aura:IsAura() return true end
function modifier_creature_solidity_aura:GetAuraRadius() return 1200 end
function modifier_creature_solidity_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_solidity_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_solidity_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_solidity_aura:GetModifierAura() return "modifier_creature_solidity_aura_buff" end

function modifier_creature_solidity_aura:GetEffectName()
	return "particles/creature/solidity_aura.vpcf"
end

function modifier_creature_solidity_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_solidity_aura_buff = class({})

function modifier_creature_solidity_aura_buff:IsHidden() return false end
function modifier_creature_solidity_aura_buff:IsDebuff() return false end
function modifier_creature_solidity_aura_buff:IsPurgable() return false end

function modifier_creature_solidity_aura_buff:OnCreated()
	self.status_resist = self:GetAbility():GetSpecialValueFor("status_resist")
end

function modifier_creature_solidity_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_creature_solidity_aura_buff:GetModifierStatusResistanceStacking()
	return self.status_resist
end
