item_hurricane_pike = class({})

item_hurricane_pike1 = item_hurricane_pike
item_hurricane_pike2 = item_hurricane_pike
item_hurricane_pike3 = item_hurricane_pike
item_hurricane_pike4 = item_hurricane_pike
item_hurricane_pike5 = item_hurricane_pike
item_hurricane_pike6 = item_hurricane_pike
item_hurricane_pike7 = item_hurricane_pike
item_hurricane_pike8 = item_hurricane_pike

item_hurricane_pike1_gem1 = item_hurricane_pike
item_hurricane_pike2_gem1 = item_hurricane_pike
item_hurricane_pike3_gem1 = item_hurricane_pike
item_hurricane_pike4_gem1 = item_hurricane_pike
item_hurricane_pike5_gem1 = item_hurricane_pike
item_hurricane_pike6_gem1 = item_hurricane_pike
item_hurricane_pike7_gem1 = item_hurricane_pike
item_hurricane_pike8_gem1 = item_hurricane_pike

item_hurricane_pike1_gem2 = item_hurricane_pike
item_hurricane_pike2_gem2 = item_hurricane_pike
item_hurricane_pike3_gem2 = item_hurricane_pike
item_hurricane_pike4_gem2 = item_hurricane_pike
item_hurricane_pike5_gem2 = item_hurricane_pike
item_hurricane_pike6_gem2 = item_hurricane_pike
item_hurricane_pike7_gem2 = item_hurricane_pike
item_hurricane_pike8_gem2 = item_hurricane_pike

item_hurricane_pike1_gem3 = item_hurricane_pike
item_hurricane_pike2_gem3 = item_hurricane_pike
item_hurricane_pike3_gem3 = item_hurricane_pike
item_hurricane_pike4_gem3 = item_hurricane_pike
item_hurricane_pike5_gem3 = item_hurricane_pike
item_hurricane_pike6_gem3 = item_hurricane_pike
item_hurricane_pike7_gem3 = item_hurricane_pike
item_hurricane_pike8_gem3 = item_hurricane_pike

item_hurricane_pike1_gem4 = item_hurricane_pike
item_hurricane_pike2_gem4 = item_hurricane_pike
item_hurricane_pike3_gem4 = item_hurricane_pike
item_hurricane_pike4_gem4 = item_hurricane_pike
item_hurricane_pike5_gem4 = item_hurricane_pike
item_hurricane_pike6_gem4 = item_hurricane_pike
item_hurricane_pike7_gem4 = item_hurricane_pike
item_hurricane_pike8_gem4 = item_hurricane_pike

item_hurricane_pike1_gem5 = item_hurricane_pike
item_hurricane_pike2_gem5 = item_hurricane_pike
item_hurricane_pike3_gem5 = item_hurricane_pike
item_hurricane_pike4_gem5 = item_hurricane_pike
item_hurricane_pike5_gem5 = item_hurricane_pike
item_hurricane_pike6_gem5 = item_hurricane_pike
item_hurricane_pike7_gem5 = item_hurricane_pike
item_hurricane_pike8_gem5 = item_hurricane_pike

LinkLuaModifier("modifier_hurricane_multishot", "items/custom_items/item_hurricane_pike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_dragon_lance3_reduced_damage","items/custom_items/item_hurricane_pike", LUA_MODIFIER_MOTION_NONE)

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
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_hurricane_multishot:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
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