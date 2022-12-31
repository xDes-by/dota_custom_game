LinkLuaModifier("modifier_creature_flock_together", "creatures/abilities/regular/creature_flock_together", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_flock_together_buff", "creatures/abilities/regular/creature_flock_together", LUA_MODIFIER_MOTION_NONE)

creature_flock_together = class({})

function creature_flock_together:GetIntrinsicModifierName()
	return "modifier_creature_flock_together"
end



modifier_creature_flock_together = class({})

function modifier_creature_flock_together:IsHidden() return true end
function modifier_creature_flock_together:IsDebuff() return false end
function modifier_creature_flock_together:IsPurgable() return false end
function modifier_creature_flock_together:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_flock_together:IsAura() return true end
function modifier_creature_flock_together:GetAuraRadius() return 600 end
function modifier_creature_flock_together:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_flock_together:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_flock_together:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_flock_together:GetModifierAura() return "modifier_creature_flock_together_buff" end



modifier_creature_flock_together_buff = class({})

function modifier_creature_flock_together_buff:OnCreated()
	local ability = self:GetAbility()
	if not ability then return end

	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
end

function modifier_creature_flock_together_buff:IsHidden() return false end
function modifier_creature_flock_together_buff:IsDebuff() return false end
function modifier_creature_flock_together_buff:IsPurgable() return false end

function modifier_creature_flock_together_buff:GetEffectName()
	return "particles/creature/boss_shield_wall_buff.vpcf"
end

function modifier_creature_flock_together_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_flock_together_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_creature_flock_together_buff:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
