LinkLuaModifier("modifier_creature_dark_energy", "creatures/abilities/regular/creature_dark_energy", LUA_MODIFIER_MOTION_NONE)

creature_dark_energy = class({})

function creature_dark_energy:GetIntrinsicModifierName()
	return "modifier_creature_dark_energy"
end



modifier_creature_dark_energy = class({})

function modifier_creature_dark_energy:OnCreated()
	if IsClient() then return end

	local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
end

function modifier_creature_dark_energy:IsHidden() return true end
function modifier_creature_dark_energy:IsDebuff() return false end
function modifier_creature_dark_energy:IsPurgable() return false end
function modifier_creature_dark_energy:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_dark_energy:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
		return funcs
	end

	function modifier_creature_dark_energy:GetModifierProcAttack_Feedback(keys)
		if keys.target:IsMagicImmune() then return end
		local bonus_damage = 0.01 * self.bonus_damage * 0.5 * (keys.attacker:GetBaseDamageMax() + keys.attacker:GetBaseDamageMin())
		local actual_damage = ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = bonus_damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, actual_damage, nil)
	end
end
