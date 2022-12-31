LinkLuaModifier("modifier_creature_bubble_aura", "creatures/abilities/regular/creature_bubble_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_bubble_aura_buff", "creatures/abilities/regular/creature_bubble_aura", LUA_MODIFIER_MOTION_NONE)

creature_bubble_aura = class({})

function creature_bubble_aura:GetIntrinsicModifierName()
	return "modifier_creature_bubble_aura"
end



modifier_creature_bubble_aura = class({})

function modifier_creature_bubble_aura:IsHidden() return true end
function modifier_creature_bubble_aura:IsDebuff() return false end
function modifier_creature_bubble_aura:IsPurgable() return false end
function modifier_creature_bubble_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_bubble_aura:IsAura() return true end
function modifier_creature_bubble_aura:GetAuraRadius() return 1200 end
function modifier_creature_bubble_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_bubble_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_bubble_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_bubble_aura:GetModifierAura() return "modifier_creature_bubble_aura_buff" end

function modifier_creature_bubble_aura:GetAuraEntityReject(unit)
	return unit == self:GetParent()
end

function modifier_creature_bubble_aura:GetEffectName()
	return "particles/creature/bubble_aura.vpcf"
end

function modifier_creature_bubble_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_bubble_aura_buff = class({})

function modifier_creature_bubble_aura_buff:IsHidden() return false end
function modifier_creature_bubble_aura_buff:IsDebuff() return false end
function modifier_creature_bubble_aura_buff:IsPurgable() return false end

function modifier_creature_bubble_aura_buff:GetEffectName()
	return "particles/creature/fracture.vpcf"
end

function modifier_creature_bubble_aura_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_bubble_aura_buff:OnCreated()
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_creature_bubble_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_creature_bubble_aura_buff:GetModifierIncomingDamage_Percentage()
	return self.damage_reduction
end
