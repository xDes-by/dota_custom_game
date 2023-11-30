dazzle_custom_badjuju = class({})

function dazzle_custom_badjuju:GetIntrinsicModifierName()
    return "modifier_dazzle_custom_badjuju"
end

LinkLuaModifier("modifier_dazzle_custom_badjuju", "heroes/hero_dazzle/dazzle_juju/dazzle_juju", LUA_MODIFIER_MOTION_NONE)

modifier_dazzle_custom_badjuju = class({})

function modifier_dazzle_custom_badjuju:IsHidden()
    return true
end

function modifier_dazzle_custom_badjuju:IsPurgable()
	return false
end

function modifier_dazzle_custom_badjuju:RemoveOnDeath()
	return false
end

function modifier_dazzle_custom_badjuju:OnCreated()
	self.bonus = 0
end

function modifier_dazzle_custom_badjuju:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
end

function modifier_dazzle_custom_badjuju:GetModifierPercentageCooldown()
    if IsValidEntity(self:GetAbility()) then
		return self:GetAbility():GetSpecialValueFor("cooldown_reduc")
	else
		self:Destroy()
	end
end

function modifier_dazzle_custom_badjuju:GetModifierSpellAmplify_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_int_last") ~= nil then
		return self:GetAbility():GetSpecialValueFor("spell_amplify") * 20
	else
        return self:GetAbility():GetSpecialValueFor("spell_amplify")
	end
end

function modifier_dazzle_custom_badjuju:GetModifierAttackSpeedBonus_Constant()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_agi8")
		if abil ~= nil	then 
	return self:GetCaster():GetLevel() * 5
	end
	return 0
end

function modifier_dazzle_custom_badjuju:GetModifierBaseAttack_BonusDamage()
	return self.bonus
end

function modifier_dazzle_custom_badjuju:OnDeath(data)
	if data.attacker ~= self:GetParent() then
		return
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dazzle_agi50") then
		self.bonus = self.bonus + 10
	end
end