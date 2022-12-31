-- Drow Ranger's precision aura

LinkLuaModifier("modifier_trueshot_chc_aura", "heroes/hero_drow_ranger/drow_ranger_trueshot_chc", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_trueshot_chc_aura_effect", "heroes/hero_drow_ranger/drow_ranger_trueshot_chc", LUA_MODIFIER_MOTION_NONE )



drow_ranger_trueshot_chc = class({})

function drow_ranger_trueshot_chc:GetIntrinsicModifierName()
	return "modifier_trueshot_chc_aura"
end



modifier_trueshot_chc_aura = class({})

function modifier_trueshot_chc_aura:IsDebuff() return false end
function modifier_trueshot_chc_aura:IsHidden() return true end
function modifier_trueshot_chc_aura:IsPurgable() return false end
function modifier_trueshot_chc_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_trueshot_chc_aura:IsAura() return true end

function modifier_trueshot_chc_aura:GetAuraRadius() return 1200 end
function modifier_trueshot_chc_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_trueshot_chc_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_trueshot_chc_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_trueshot_chc_aura:GetModifierAura() return "modifier_trueshot_chc_aura_effect" end



modifier_trueshot_chc_aura_effect = class({})

function modifier_trueshot_chc_aura_effect:IsDebuff() return false end
function modifier_trueshot_chc_aura_effect:IsHidden() return false end
function modifier_trueshot_chc_aura_effect:IsPurgable() return false end
function modifier_trueshot_chc_aura_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_trueshot_chc_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_trueshot_chc_aura_effect:GetModifierPreAttack_BonusDamage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if caster and ability and caster.GetAgility then
		return caster:GetAgility() * ability:GetSpecialValueFor("agi_to_damage") * 0.01
	end
end
