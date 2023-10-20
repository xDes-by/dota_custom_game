item_hurricane_pike = class({})

LinkLuaModifier("modifier_hurricane_multishot", "items/custom_items/item_hurricane_pike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_dragon_lance3_reduced_damage","items/custom_items/item_hurricane_pike", LUA_MODIFIER_MOTION_NONE)

function item_hurricane_pike:GetAbilityTextureName()
	local level = self:GetLevel()
	if not self.GemType then
		return "all/hurricane_pike_" .. level
	else
		return "gem" .. self.GemType .. "/hurricane_pike_" .. level .. "_gem" .. self.GemType
	end
end

function item_hurricane_pike:GetIntrinsicModifierName()
    return "modifier_hurricane_multishot"
end

modifier_hurricane_multishot = class({})

function modifier_hurricane_multishot:IsHidden()
	return true
end

function modifier_hurricane_multishot:IsPurgable()
	return false
end

function modifier_hurricane_multishot:OnCreated()
    self.parent = self:GetParent()
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.base_attack_range = self:GetAbility():GetSpecialValueFor("base_attack_range")
end

function modifier_hurricane_multishot:OnRefresh()
    self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
    self.bonus_intellect = self:GetAbility():GetSpecialValueFor("bonus_intellect")
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
    self.base_attack_range = self:GetAbility():GetSpecialValueFor("base_attack_range")
end

function modifier_hurricane_multishot:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK
    }
end

function modifier_hurricane_multishot:OnAttack(keys)
    if not IsServer() then 
        return 
    end
    if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and self:GetAbility():IsFullyCastable() and RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("multishot_chance"), self:GetCaster():entindex(), self:GetCaster()) then	
	
        local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("multishot_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)		
        local nTargetNumber = 0		
        for _, hEnemy in pairs(enemies) do
            if hEnemy ~= keys.target then

                local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_custom_dragon_lance3_reduced_damage", {})
                self:GetParent():PerformAttack(hEnemy, true, true, true, true, true, false, false)		
                mod:Destroy()
                
                nTargetNumber = nTargetNumber + 1
                
                if nTargetNumber >= self:GetAbility():GetSpecialValueFor("multishot_targets") then
                    break
                end
            end
        end
        self:GetAbility():UseResources(false, false, false, true)
    end 
end

function modifier_hurricane_multishot:GetModifierBonusStats_Strength()
    return self.bonus_strength
end

function modifier_hurricane_multishot:GetModifierBonusStats_Intellect()
    return self.bonus_intellect
end

function modifier_hurricane_multishot:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_hurricane_multishot:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_hurricane_multishot:GetModifierBonusStats_Agility()
    return self.bonus_agility
end

function modifier_hurricane_multishot:GetModifierAttackRangeBonus()
    return self.base_attack_range
end


-----------------------------------
modifier_item_custom_dragon_lance3_reduced_damage = class({})

function modifier_item_custom_dragon_lance3_reduced_damage:IsDebuff() return false end
function modifier_item_custom_dragon_lance3_reduced_damage:IsHidden() return true end
function modifier_item_custom_dragon_lance3_reduced_damage:IsPurgable() return false end
function modifier_item_custom_dragon_lance3_reduced_damage:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_item_custom_dragon_lance3_reduced_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_item_custom_dragon_lance3_reduced_damage:GetModifierDamageOutgoing_Percentage()
	return -1*(100-self:GetAbility():GetSpecialValueFor("multishot_damage"))
end