item_ballista_lua = class({})

LinkLuaModifier("modifier_ballista_lua", "items/ballista", LUA_MODIFIER_MOTION_NONE)


function item_ballista_lua:GetIntrinsicModifierName()
	return "modifier_ballista_lua"
end

modifier_ballista_lua = class({})
function modifier_ballista_lua:IsHidden() return true end
function modifier_ballista_lua:IsDebuff() return false end
function modifier_ballista_lua:IsPurgable() return false end
function modifier_ballista_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_ballista_lua:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_ballista_lua:OnCreated(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.attack_range_bonus = ability:GetSpecialValueFor("attack_range_bonus")
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")

end

function modifier_ballista_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}
end

function modifier_ballista_lua:GetModifierAttackRangeBonus()
	local parent = self:GetParent()
	if parent:IsRangedAttacker() then
		return self.attack_range_bonus
	end
	return 0
end

function modifier_ballista_lua:GetModifierProcAttack_BonusDamage_Pure(keys)
	if (not keys.target) or (not keys.attacker) or (keys.target:IsNull() or keys.attacker:IsNull()) then return end

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_damage, nil)

	return self.bonus_damage
end
