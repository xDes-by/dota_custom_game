LinkLuaModifier("modifier_hurricane_multishot", "items/custom_items/item_hurricane_pike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_custom_dragon_lance3_reduced_damage","items/custom_items/item_hurricane_pike", LUA_MODIFIER_MOTION_NONE)
item_hurricane_pike1 = item_hurricane_pike1 or class({})
item_hurricane_pike2 = item_hurricane_pike1 or class({})
item_hurricane_pike3 = item_hurricane_pike1 or class({})
item_hurricane_pike4 = item_hurricane_pike1 or class({})
item_hurricane_pike5 = item_hurricane_pike1 or class({})
item_hurricane_pike6 = item_hurricane_pike1 or class({})
item_hurricane_pike7 = item_hurricane_pike1 or class({})
item_hurricane_pike8 = item_hurricane_pike1 or class({})

function item_hurricane_pike1:GetIntrinsicModifierName()
    return "modifier_hurricane_multishot"
end

------------

modifier_hurricane_multishot = class({})

function modifier_hurricane_multishot:IsHidden()
	return true
end

function modifier_hurricane_multishot:IsPurgable()
	return false
end

function modifier_hurricane_multishot:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,

        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end

function modifier_hurricane_multishot:OnCreated()
    if not IsServer() then return end
    self.cooldown = 6
    self.slow = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.hits = 0
end

function modifier_hurricane_multishot:OnAttack(keys)
    if not IsServer() then return end
    if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and self:GetAbility():IsFullyCastable() then	
		
        if not self:GetParent():HasFlyMovementCapability() then
            local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("multishot_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)		
            local nTargetNumber = 0		
            for _, hEnemy in pairs(enemies) do
                if hEnemy ~= keys.target then

                    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_custom_dragon_lance3_reduced_damage", {})				
                    self:GetParent():PerformAttack(hEnemy, false, false, true, true, true, false, false)		
                    self:GetParent():RemoveModifierByName("modifier_item_custom_dragon_lance3_reduced_damage")
                    
                    nTargetNumber = nTargetNumber + 1
                    
                    if nTargetNumber >= self:GetAbility():GetSpecialValueFor("multishot_targets") then
                        break
                    end
                end
            end
            self:GetAbility():UseResources(false, false, false, true)
        end
    end
    
end

function modifier_hurricane_multishot:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_hurricane_multishot:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_hurricane_multishot:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_hurricane_multishot:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_hurricane_multishot:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_hurricane_multishot:GetModifierAttackRangeBonusUnique()
    return self:GetAbility():GetSpecialValueFor("attack_range")
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