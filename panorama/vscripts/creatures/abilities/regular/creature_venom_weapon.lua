LinkLuaModifier("modifier_creature_venom_weapon", "creatures/abilities/regular/creature_venom_weapon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_venom_weapon_debuff", "creatures/abilities/regular/creature_venom_weapon", LUA_MODIFIER_MOTION_NONE)

creature_venom_weapon = class({})

function creature_venom_weapon:GetIntrinsicModifierName()
	return "modifier_creature_venom_weapon"
end



modifier_creature_venom_weapon = class({})

function modifier_creature_venom_weapon:IsHidden() return true end
function modifier_creature_venom_weapon:IsDebuff() return false end
function modifier_creature_venom_weapon:IsPurgable() return false end
function modifier_creature_venom_weapon:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_venom_weapon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_creature_venom_weapon:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end

	if (not keys.target:IsMagicImmune()) then
		local ability = self:GetAbility()
		keys.target:RemoveModifierByName("modifier_creature_venom_weapon_debuff")
		keys.target:AddNewModifier(keys.attacker, ability, "modifier_creature_venom_weapon_debuff", {duration = ability:GetSpecialValueFor("duration"), dps = ability:GetSpecialValueFor("dps")})
  end
end



modifier_creature_venom_weapon_debuff = class({})

function modifier_creature_venom_weapon_debuff:IsHidden() return false end
function modifier_creature_venom_weapon_debuff:IsDebuff() return true end
function modifier_creature_venom_weapon_debuff:IsPurgable() return true end

function modifier_creature_venom_weapon_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.dps = keys.dps
	self.regen_reduction = ability:GetSpecialValueFor("regen_reduction")

	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_creature_venom_weapon_debuff:GetEffectName()
	return "particles/creature/venom_weapon.vpcf"
end

function modifier_creature_venom_weapon_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_venom_weapon_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_creature_venom_weapon_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.regen_reduction
end

function modifier_creature_venom_weapon_debuff:OnTooltip()
	return self.dps
end

function modifier_creature_venom_weapon_debuff:OnIntervalThink()
	if not IsServer() then return end
	
	local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), actual_damage, nil)
end
