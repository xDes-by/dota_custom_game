item_monkey_king_bar_lua = class({})

LinkLuaModifier("modifier_item_monkey_king_bar_passive", 'items/custom_items/item_monkey_king_bar_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_monkey_king_bar_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/mkb_" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_monkey_king_bar_lua" .. level
	end
end

function item_monkey_king_bar_lua:GetIntrinsicModifierName()
	return "modifier_item_monkey_king_bar_passive"
end

--------------------------------------------------------------------------------

modifier_item_monkey_king_bar_passive = class({})

function modifier_item_monkey_king_bar_passive:IsHidden()
	return true
end

function modifier_item_monkey_king_bar_passive:IsPurgable()
	return false
end

function modifier_item_monkey_king_bar_passive:DestroyOnExpire()
	return false
end

function modifier_item_monkey_king_bar_passive:RemoveOnDeath()	
	return false 
end

function modifier_item_monkey_king_bar_passive:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_monkey_king_bar_passive:OnCreated()
	self.parent = self:GetParent()
	self.bonus_chance = self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage = self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
end

function modifier_item_monkey_king_bar_passive:OnRefresh()
	self.bonus_chance = self:GetAbility():GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage = self:GetAbility():GetSpecialValueFor("bonus_chance_damage")
end

function modifier_item_monkey_king_bar_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_item_monkey_king_bar_passive:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_monkey_king_bar_passive:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_monkey_king_bar_passive:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not self:GetParent():IsIllusion() and not keys.target:IsBuilding() and RollPercentage(self.bonus_chance) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.bonus_chance_damage, nil)
		self:GetParent():EmitSound("DOTA_Item.MKB.proc")
		return self.bonus_chance_damage
	end
end

function modifier_item_monkey_king_bar_passive:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end