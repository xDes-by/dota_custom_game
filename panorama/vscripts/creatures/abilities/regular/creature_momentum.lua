LinkLuaModifier("modifier_creature_momentum", "creatures/abilities/regular/creature_momentum", LUA_MODIFIER_MOTION_NONE)

creature_momentum = class({})

function creature_momentum:GetIntrinsicModifierName()
	return "modifier_creature_momentum"
end

modifier_creature_momentum = class({})

function modifier_creature_momentum:OnCreated()
	local ability = self:GetAbility()

	self.attack_speed = ability:GetSpecialValueFor("attack_speed")
	self.damage = ability:GetSpecialValueFor("damage")
end

function modifier_creature_momentum:IsHidden() return false end
function modifier_creature_momentum:IsDebuff() return false end
function modifier_creature_momentum:IsPurgable() return false end
function modifier_creature_momentum:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_momentum:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

function modifier_creature_momentum:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_momentum:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

if IsServer() then
	function modifier_creature_momentum:GetModifierProcAttack_Feedback(keys)
		self:IncrementStackCount()
	end
end

function modifier_creature_momentum:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed * self:GetStackCount()
end

function modifier_creature_momentum:GetModifierDamageOutgoing_Percentage()
	return self.damage * self:GetStackCount()
end
