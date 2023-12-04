LinkLuaModifier("modifier_lion_soul_collector", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_unique_npc_dota_hero_lion_agi50", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE)

lion_soul_collector = class({})

function lion_soul_collector:GetIntrinsicModifierName()
	return "modifier_lion_soul_collector"
end

if modifier_lion_soul_collector == nil then 
    modifier_lion_soul_collector = class({})
end

function modifier_lion_soul_collector:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_lion_soul_collector:IsPurgable()
    return false
end
 
function modifier_lion_soul_collector:RemoveOnDeath()
    return false
end

function modifier_lion_soul_collector:OnCreated(kv)
	if not IsServer() then
		return
	end
	self.special_bonus_unique_npc_dota_hero_lion_agi50 = self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_lion_agi50")
end

function modifier_lion_soul_collector:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }
end

function modifier_lion_soul_collector:OnDeath(params)
	count = 1
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_lion_int10")	
	if abil ~= nil then 
	count = 2
	end
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_lion_int_last")	
	if abil ~= nil then 
		count = count + 2
	end
	for i = 1, count do					
		local parent = self:GetParent()
		if IsMyKilledBadGuys(parent, params) then
			self:IncrementStackCount()
			parent:CalculateStatBonus(true)
		end
	end
end

function modifier_lion_soul_collector:GetModifierPhysicalArmorBonus(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_str11")	
	if abil ~= nil then 
    return math.floor(self:GetStackCount()/15)
	end
	return 0
end

function modifier_lion_soul_collector:GetModifierHealthBonus(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_str10")	
	if abil ~= nil then 
    return self:GetStackCount()*10
	end
	return 0
end

function modifier_lion_soul_collector:GetModifierBaseAttack_BonusDamage(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_agi10")	
	if abil ~= nil then 
    return self:GetStackCount()
	end
	return 0
end

function modifier_lion_soul_collector:GetModifierConstantHealthRegen(params)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_str9")	
	if abil ~= nil then 
    return self:GetStackCount()/2
	end
	return 0
end

function modifier_lion_soul_collector:GetModifierPercentageCooldown(params)
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lion_str50")	
	if abil ~= nil then 
		return 50
	end
	return 0
end

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end

function modifier_lion_soul_collector:OnAttackLanded(data)
	if self:GetParent() ~= data.attacker then
		return
	end
	if self.special_bonus_unique_npc_dota_hero_lion_agi50 then
		data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_special_bonus_unique_npc_dota_hero_lion_agi50", {duration = 3})
	end
end

modifier_special_bonus_unique_npc_dota_hero_lion_agi50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:IsDebuff()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:IsPurgable()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:RemoveOnDeath()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:DestroyOnExpire()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_special_bonus_unique_npc_dota_hero_lion_agi50:GetModifierPhysicalArmorBonus()
	return -200
end