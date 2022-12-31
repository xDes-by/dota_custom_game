LinkLuaModifier("modifier_creature_ritual_caster", "creatures/abilities/regular/creature_ritual_caster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_ritual_caster_buff", "creatures/abilities/regular/creature_ritual_caster", LUA_MODIFIER_MOTION_NONE)

creature_ritual_caster = class({})

function creature_ritual_caster:GetIntrinsicModifierName()
	return "modifier_creature_ritual_caster"
end



modifier_creature_ritual_caster = class({})

function modifier_creature_ritual_caster:IsHidden() return true end
function modifier_creature_ritual_caster:IsDebuff() return false end
function modifier_creature_ritual_caster:IsPurgable() return false end
function modifier_creature_ritual_caster:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_ritual_caster:GetEffectName()
	return "particles/creature/ritual_caster.vpcf"
end

function modifier_creature_ritual_caster:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_ritual_caster:IsAura() return true end
function modifier_creature_ritual_caster:GetAuraRadius() return 1200 end
function modifier_creature_ritual_caster:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_ritual_caster:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_ritual_caster:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_ritual_caster:GetModifierAura() return "modifier_creature_ritual_caster_buff" end
function modifier_creature_ritual_caster:GetAuraEntityReject(unit)
	if IsServer() then
		if unit:HasModifier("modifier_creature_ritual_caster") then
			return true
		else
			return false
		end
	end
end



modifier_creature_ritual_caster_buff = class({})

function modifier_creature_ritual_caster_buff:IsHidden() return true end
function modifier_creature_ritual_caster_buff:IsDebuff() return false end
function modifier_creature_ritual_caster_buff:IsPurgable() return false end
function modifier_creature_ritual_caster_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creature_ritual_caster_buff:GetEffectName()
	return "particles/creature/ritual_caster_buff.vpcf"
end

function modifier_creature_ritual_caster_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_creature_ritual_caster_buff:ShouldUseOverheadOffset()
	return true
end

function modifier_creature_ritual_caster_buff:OnCreated(keys)
	if IsServer() then
		self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	end
end

function modifier_creature_ritual_caster_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_creature_ritual_caster_buff:GetModifierSpellAmplify_Percentage()
	if IsServer() then
		return self.spell_amp
	else
		return 0
	end
end
