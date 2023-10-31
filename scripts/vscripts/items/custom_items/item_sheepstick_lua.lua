item_sheepstick_lua = class({})

LinkLuaModifier( "modifier_sheepstick_lua", "items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheepstick_lua_ignore", "items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_sheepstick_lua_flame","items/custom_items/item_sheepstick_lua", LUA_MODIFIER_MOTION_NONE)

function item_sheepstick_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/hex_" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_sheepstick_lua" .. level
	end
end

function item_sheepstick_lua:GetIntrinsicModifierName()
	return "modifier_sheepstick_lua"
end

function item_sheepstick_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	sheep_duration = self:GetSpecialValueFor("sheep_duration")
	if not target:FindModifierByName("modifier_sheepstick_lua_ignore") then
		target:AddNewModifier(caster, self, "modifier_sheepstick_lua_ignore", { duration = 10 })
		target:AddNewModifier(caster, self, "modifier_hexxed", { duration = sheep_duration })
		EmitSoundOn( "Hero_Lion.Voodoo", caster )
	end
end

modifier_sheepstick_lua_ignore = class ({})

function modifier_sheepstick_lua_ignore:IsHidden()
	return false
end

function modifier_sheepstick_lua_ignore:IsDebuff()
	return true
end

function modifier_sheepstick_lua_ignore:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------
--Stats

modifier_sheepstick_lua = class({})


function modifier_sheepstick_lua:IsHidden()
    return true
end

function modifier_sheepstick_lua:IsPurgable()
    return false
end

function modifier_sheepstick_lua:RemoveOnDeath()
    return false 
end

function modifier_sheepstick_lua:OnCreated()
	self.parent = self:GetParent()
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")
end

function modifier_sheepstick_lua:OnRefresh()
	self.parent = self:GetParent()
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.projectile_speed = self:GetAbility():GetSpecialValueFor("projectile_speed")
end

function modifier_sheepstick_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    }
end

function modifier_sheepstick_lua:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_sheepstick_lua:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_sheepstick_lua:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_sheepstick_lua:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_sheepstick_lua:GetModifierProjectileSpeedBonus()
    return self.projectile_speed
end

function modifier_sheepstick_lua:GetModifierProcAttack_Feedback(data)
	if data.target:FindModifierByName("modifier_sheepstick_lua_flame") ==  nil then
		if not self:GetParent():PassivesDisabled() then
			data.target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_sheepstick_lua_flame", { duration = 3.1 })
		end
	end
end

modifier_sheepstick_lua_flame = class({})

function modifier_sheepstick_lua_flame:IsHidden()
	return false
end

function modifier_sheepstick_lua_flame:IsDebuff()
	return true
end

function modifier_sheepstick_lua_flame:IsPurgable()
	return true
end

function modifier_sheepstick_lua_flame:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1)
end

function modifier_sheepstick_lua_flame:OnIntervalThink()
	self.intellect_dmg = self:GetAbility():GetSpecialValueFor("intellect_dmg")
	local damage = (self.intellect_dmg * self:GetCaster():GetIntellect())
	ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage = damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
end