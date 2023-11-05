item_tank_cuirass = item_tank_cuirass or class({})

LinkLuaModifier("modifier_item_tank_cuirass", "items/item_tank_cuirass", LUA_MODIFIER_MOTION_NONE)

function item_tank_cuirass:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "mid_items/weapon_" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/weapon_" .. level .. "_gem" .. self:GetSecondaryCharges()
	end
end

function item_tank_cuirass:GetIntrinsicModifierName()
	return "modifier_item_tank_cuirass"
end

modifier_item_tank_cuirass = class({})

function modifier_item_tank_cuirass:IsHidden()
	return true
end

function modifier_item_tank_cuirass:IsPurgable()
	return false
end

function modifier_item_tank_cuirass:OnCreated()
	self.damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal") * 0.01
	self.bonus_primary = self:GetAbility():GetSpecialValueFor("bonus_primary") * 0.01
end

function modifier_item_tank_cuirass:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
end

function modifier_item_tank_cuirass:GetModifierBaseAttack_BonusDamage()
	return self.damage_bonus
end

function modifier_item_tank_cuirass:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_item_tank_cuirass:GetModifierProcAttack_BonusDamage_Magical(data)
	if IsClient() then
		return
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, data.attacker)
	ParticleManager:ReleaseParticleIndex(pfx)
	data.attacker:Heal(data.damage * self.lifesteal, data.attacker)
	local damage = self.bonus_primary * self:GetParent():GetBonusDamageFromPrimaryStat()
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, data.target, damage, nil)
	return damage
end
