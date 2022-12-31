LinkLuaModifier("modifier_creature_manalink", "creatures/abilities/regular/creature_manalink", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_manalink_buff", "creatures/abilities/regular/creature_manalink", LUA_MODIFIER_MOTION_NONE)

creature_manalink = class({})

function creature_manalink:GetIntrinsicModifierName()
	return "modifier_creature_manalink"
end



modifier_creature_manalink = class({})

function modifier_creature_manalink:IsHidden() return true end
function modifier_creature_manalink:IsDebuff() return false end
function modifier_creature_manalink:IsPurgable() return false end
function modifier_creature_manalink:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_manalink:GetEffectName()
	return "particles/creature/mana_aura.vpcf"
end

function modifier_creature_manalink:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_manalink:IsAura() return true end
function modifier_creature_manalink:GetAuraRadius() return 1200 end
function modifier_creature_manalink:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_manalink:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_manalink:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_manalink:GetModifierAura() return "modifier_creature_manalink_buff" end



modifier_creature_manalink_buff = class({})

function modifier_creature_manalink_buff:IsHidden() return true end
function modifier_creature_manalink_buff:IsDebuff() return false end
function modifier_creature_manalink_buff:IsPurgable() return false end
function modifier_creature_manalink_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creature_manalink_buff:GetEffectName()
	return "particles/creature/mana_aura_buff.vpcf"
end

function modifier_creature_manalink_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_manalink_buff:OnCreated(keys)
	if IsServer() then
		self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	end
end

function modifier_creature_manalink_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_creature_manalink_buff:GetModifierConstantManaRegen()
	if IsServer() then
		return self.mana_regen
	else
		return 0
	end
end
