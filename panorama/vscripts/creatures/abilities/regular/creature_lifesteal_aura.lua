LinkLuaModifier("modifier_creature_lifesteal_aura", "creatures/abilities/regular/creature_lifesteal_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_lifesteal_aura_buff", "creatures/abilities/regular/creature_lifesteal_aura", LUA_MODIFIER_MOTION_NONE)

creature_lifesteal_aura = class({})

function creature_lifesteal_aura:GetIntrinsicModifierName()
	return "modifier_creature_lifesteal_aura"
end



modifier_creature_lifesteal_aura = class({})

function modifier_creature_lifesteal_aura:IsHidden() return true end
function modifier_creature_lifesteal_aura:IsDebuff() return false end
function modifier_creature_lifesteal_aura:IsPurgable() return false end
function modifier_creature_lifesteal_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_lifesteal_aura:IsAura() return true end
function modifier_creature_lifesteal_aura:GetAuraRadius() return 1200 end
function modifier_creature_lifesteal_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_lifesteal_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creature_lifesteal_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_lifesteal_aura:GetModifierAura() return "modifier_creature_lifesteal_aura_buff" end

function modifier_creature_lifesteal_aura:GetEffectName()
	return "particles/creature/lifesteal_aura.vpcf"
end

function modifier_creature_lifesteal_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_creature_lifesteal_aura_buff = class({})

function modifier_creature_lifesteal_aura_buff:IsHidden() return false end
function modifier_creature_lifesteal_aura_buff:IsDebuff() return false end
function modifier_creature_lifesteal_aura_buff:IsPurgable() return false end

function modifier_creature_lifesteal_aura_buff:OnCreated()
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")
end

function modifier_creature_lifesteal_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
	return funcs
end

function modifier_creature_lifesteal_aura_buff:GetModifierProcAttack_Feedback(keys)
	if (not IsServer()) then return end

	if keys.attacker == self:GetParent() then
		keys.attacker:Heal(keys.attacker:GetMaxHealth() * self.lifesteal * 0.01, nil)

		local lifesteal_pfx = ParticleManager:CreateParticle("particles/creature/lifesteal_aura_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end
end
