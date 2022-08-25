LinkLuaModifier("modifier_treant_skill_3", "heroes/hero_treant/treant_skill_3/treant_skill_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_skill_3_debuff", "heroes/hero_treant/treant_skill_3/treant_skill_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_skill_3_cd", "heroes/hero_treant/treant_skill_3/treant_skill_3", LUA_MODIFIER_MOTION_NONE)

treant_skill_3 = class({})

function treant_skill_3:GetIntrinsicModifierName()
	return "modifier_treant_skill_3"
end

----------------------------------------

modifier_treant_skill_3 = class({})

function modifier_treant_skill_3:IsHidden()
	return true
end

function modifier_treant_skill_3:IsPurgable()
	return false
end

function modifier_treant_skill_3:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_treant_skill_3:OnAttackLanded(event)
    if event.attacker ~= self:GetParent() then return end
    if event.inflictor ~= nil then
        if event.inflictor == self:GetAbility() then return end
    end
	
    if not event.target:HasModifier("modifier_treant_skill_3_debuff") and not event.target:HasModifier("modifier_treant_skill_3_cd") then
        event.target:AddNewModifier(event.attacker, self:GetAbility(), "modifier_treant_skill_3_debuff", { duration = self:GetAbility():GetSpecialValueFor("duration") })
		event.target:AddNewModifier(event.attacker, self:GetAbility(), "modifier_treant_skill_3_cd", { duration = self:GetAbility():GetSpecialValueFor("duration") })
    -- else
        -- event.target:FindModifierByNameAndCaster("modifier_treant_skill_3_debuff", event.attacker):ForceRefresh()
    end
end

----------------------------------------------

modifier_treant_skill_3_debuff = class({})

function modifier_treant_skill_3_debuff:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval"))
end

function modifier_treant_skill_3_debuff:OnIntervalThink()
    if not self:GetCaster():IsAlive() then self:StartIntervalThink(-1) end
		local chance = self:GetAbility():GetSpecialValueFor("spread_chance") 
	
		local dmg = self:GetAbility():GetSpecialValueFor("tick_interval") * self:GetAbility():GetSpecialValueFor("damage")
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_agi9")	
		if abil ~= nil then 
			dmg = self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("tick_interval")
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str10")	
		if abil ~= nil then 
			dmg = self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("tick_interval")
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int8")	
		if abil ~= nil then 
			chance = self:GetAbility():GetSpecialValueFor("spread_chance")  + 20
		end
		
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = dmg,
			damage_type = DAMAGE_TYPE_MAGICAL,
			-- damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self:GetAbility(),
		})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), dmg, nil)

		local victims = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("spread_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,victim in ipairs(victims) do
			if RandomInt(1,100) <= chance then
			if victim:IsAlive() and victim ~= self:GetParent() and not victim:IsMagicImmune() and not victim:HasModifier("modifier_treant_skill_3_debuff") and not victim:HasModifier("modifier_treant_skill_3_cd") then
				victim:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_treant_skill_3_debuff", { duration = self:GetAbility():GetSpecialValueFor("spread_duration")})
				victim:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_treant_skill_3_cd", { duration = self:GetAbility():GetSpecialValueFor("duration")})
			end
		end
	end
end

function modifier_treant_skill_3_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end


function modifier_treant_skill_3_debuff:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str7")	
	if abil ~= nil then 
		return (-1) * self:GetParent():GetPhysicalArmorBaseValue() * 0.10
	end
	return 0
end


---------------------------------------------------------

modifier_treant_skill_3_cd = class({})

function modifier_treant_skill_3_cd:IsHidden()
	return true
end

function modifier_treant_skill_3_cd:IsPurgable()
	return false
end
