item_sabre_blade = class({})

LinkLuaModifier("modifier_sabre_blade", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sabre_blade_doubleattack", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sabre_blade_doubleattack_debuff", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sabre_blade_illusion_modifier", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_movement_speed_uba", "modifiers/modifier_movement_speed_uba.lua", LUA_MODIFIER_MOTION_NONE)

function item_sabre_blade:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/sabre_blade" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/sabre_blade" .. level .. "_gem" .. self:GetSecondaryCharges()
    end
end

function item_sabre_blade:GetIntrinsicModifierName()
    if (self:GetItemSlot() > 5 or self:GetItemSlot() == -1) then
		return
	end
    return "modifier_sabre_blade"
end

modifier_sabre_blade = class({})

function modifier_sabre_blade:IsHidden()
	return true
end

function modifier_sabre_blade:IsPurgable()
	return false
end

function modifier_sabre_blade:RemoveOnDeath()
	return false
end

function modifier_sabre_blade:OnCreated()
    self.parent = self:GetParent()
    self.slow = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_sabre_blade:OnRefresh()
    self.parent = self:GetParent()
    self.slow = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_sabre_blade:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_sabre_blade:OnAttack(event)
    if self:GetCaster() ~= event.attacker then 
        return 
    end
    if event.attacker:IsRealHero() then
        if not self:GetAbility():IsFullyCastable() then return end
        event.attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_sabre_blade_doubleattack", {enemyEntIndex = event.target:GetEntityIndex(), duration = 0.5,})
        event.target:AddNewModifier(victim, self:GetAbility(), "modifier_sabre_blade_doubleattack_debuff", { duration = self.slow })
        self:GetAbility():UseResources(false, false, false, true)
    end
end

function modifier_sabre_blade:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sabre_blade:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sabre_blade:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sabre_blade:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_sabre_blade:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

-----------------------------------

modifier_sabre_blade_doubleattack = class({})

function modifier_sabre_blade_doubleattack:IsHidden()
	return true
end

function modifier_sabre_blade_doubleattack:IsPurgable()
	return false
end

function modifier_sabre_blade_doubleattack:OnCreated()
end

function modifier_sabre_blade_doubleattack:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_sabre_blade_doubleattack:OnAttack(keys)
	if keys.attacker ~= self:GetParent() then return end
	local damage = keys.attacker:GetAverageTrueAttackDamage(nil)
	
	local multi = self:GetAbility():GetSpecialValueFor("mult")
    local attack = damage * (multi/100)
	
	ApplyDamage({
		victim = keys.target,
		attacker = keys.attacker,
		damage = attack,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	})
end

function modifier_sabre_blade_doubleattack:GetModifierAttackSpeedBonus_Constant()
    return 1450
end

modifier_sabre_blade_doubleattack_debuff = class({})

function modifier_sabre_blade_doubleattack_debuff:IsHidden()
	return true
end

function modifier_sabre_blade_doubleattack_debuff:IsPurgable()
	return false
end

function modifier_sabre_blade_doubleattack_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_sabre_blade_doubleattack_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -100
end