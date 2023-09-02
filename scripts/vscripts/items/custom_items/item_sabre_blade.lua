item_sabre_blade = class({})

item_sabre_blade1 = item_sabre_blade
item_sabre_blade2 = item_sabre_blade
item_sabre_blade3 = item_sabre_blade
item_sabre_blade4 = item_sabre_blade
item_sabre_blade5 = item_sabre_blade
item_sabre_blade6 = item_sabre_blade
item_sabre_blade7 = item_sabre_blade
item_sabre_blade8 = item_sabre_blade

item_sabre_blade1_gem1 = item_sabre_blade
item_sabre_blade2_gem1 = item_sabre_blade
item_sabre_blade3_gem1 = item_sabre_blade
item_sabre_blade4_gem1 = item_sabre_blade
item_sabre_blade5_gem1 = item_sabre_blade
item_sabre_blade6_gem1 = item_sabre_blade
item_sabre_blade7_gem1 = item_sabre_blade
item_sabre_blade8_gem1 = item_sabre_blade

item_sabre_blade1_gem2 = item_sabre_blade
item_sabre_blade2_gem2 = item_sabre_blade
item_sabre_blade3_gem2 = item_sabre_blade
item_sabre_blade4_gem2 = item_sabre_blade
item_sabre_blade5_gem2 = item_sabre_blade
item_sabre_blade6_gem2 = item_sabre_blade
item_sabre_blade7_gem2 = item_sabre_blade
item_sabre_blade8_gem2 = item_sabre_blade

item_sabre_blade1_gem3 = item_sabre_blade
item_sabre_blade2_gem3 = item_sabre_blade
item_sabre_blade3_gem3 = item_sabre_blade
item_sabre_blade4_gem3 = item_sabre_blade
item_sabre_blade5_gem3 = item_sabre_blade
item_sabre_blade6_gem3 = item_sabre_blade
item_sabre_blade7_gem3 = item_sabre_blade
item_sabre_blade8_gem3 = item_sabre_blade

item_sabre_blade1_gem4 = item_sabre_blade
item_sabre_blade2_gem4 = item_sabre_blade
item_sabre_blade3_gem4 = item_sabre_blade
item_sabre_blade4_gem4 = item_sabre_blade
item_sabre_blade5_gem4 = item_sabre_blade
item_sabre_blade6_gem4 = item_sabre_blade
item_sabre_blade7_gem4 = item_sabre_blade
item_sabre_blade8_gem4 = item_sabre_blade

item_sabre_blade1_gem5 = item_sabre_blade
item_sabre_blade2_gem5 = item_sabre_blade
item_sabre_blade3_gem5 = item_sabre_blade
item_sabre_blade4_gem5 = item_sabre_blade
item_sabre_blade5_gem5 = item_sabre_blade
item_sabre_blade6_gem5 = item_sabre_blade
item_sabre_blade7_gem5 = item_sabre_blade
item_sabre_blade8_gem5 = item_sabre_blade

LinkLuaModifier("modifier_sabre_blade", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sabre_blade_doubleattack", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sabre_blade_doubleattack_debuff", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sabre_blade_illusion_modifier", "items/custom_items/item_sabre_blade.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_movement_speed_uba", "modifiers/modifier_movement_speed_uba.lua", LUA_MODIFIER_MOTION_NONE)

function item_sabre_blade:GetIntrinsicModifierName()
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
    self.cooldown = 6
    self.slow = self:GetAbility():GetSpecialValueFor("slow_duration")
    self.hits = 0
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value})
	end
end

function modifier_sabre_blade:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value * -1})
	end
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
    if not IsServer() then return end
    local attacker = event.attacker
    local victim = event.target
    
    if self:GetCaster() ~= attacker then return end
    if event.inflictor ~= nil then return end

    local ability = self:GetAbility()

    if attacker:IsRealHero() then
        -- if self.hits >= 3 then
        --     attacker:RemoveModifierByName("modifier_sabre_blade_doubleattack")
        --     self.hits = 0
        -- else
        --     self.hits = self.hits + 1
        -- end

        if not ability:IsFullyCastable() then return end
        attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_sabre_blade_doubleattack", {
            enemyEntIndex = victim:GetEntityIndex(),
            duration = 0.5,
        })
        victim:AddNewModifier(victim, self:GetAbility(), "modifier_sabre_blade_doubleattack_debuff", { duration = self.slow })

        ability:UseResources(false, false, false, true)

        Timers:CreateTimer(ability:GetCooldownTimeRemaining(), function()
            attacker:RemoveModifierByName("modifier_sabre_blade_doubleattack")
            self.hits = 0
        end)
    end
end

function modifier_sabre_blade:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_sabre_blade:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_sabre_blade:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_sabre_blade:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_sabre_blade:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
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
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end


function modifier_sabre_blade_doubleattack:OnAttack(keys)
	if not IsServer() then return end
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

function modifier_sabre_blade_doubleattack:GetModifierAttackSpeed_Limit()
    return 1
end

function modifier_sabre_blade_doubleattack:GetModifierAttackSpeedBonus_Constant()
    return 1450
end
------------

modifier_sabre_blade_doubleattack_debuff = class({})

function modifier_sabre_blade_doubleattack_debuff:IsHidden()
	return true
end

function modifier_sabre_blade_doubleattack_debuff:IsPurgable()
	return false
end

function modifier_sabre_blade_doubleattack_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_sabre_blade_doubleattack_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -100
end