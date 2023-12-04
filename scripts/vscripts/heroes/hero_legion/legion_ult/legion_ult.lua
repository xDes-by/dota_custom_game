LinkLuaModifier("modifier_legion_ult", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_ult2", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_ult_aura", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)

legion_ult2 = class({})
function legion_ult2:GetTexture()
    return "legion_commander_duel"
end

function legion_ult2:GetIntrinsicModifierName()
	return "modifier_legion_ult2"
end

function legion_ult2:OnUpgrade()
	legion_ult = self:GetCaster():FindAbilityByName("legion_ult")
	level = self:GetLevel()
	if level <= 10 and level > legion_ult:GetLevel() then
		legion_ult:SetLevel(level)
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_legion_commander_str50") and self.added_stacks < 150 then
		local modifier = self:GetCaster():FindModifierByName("modifier_legion_ult")
		modifier:SetStackCount(modifier:GetStackCount() + (self:GetLevel() * 10 - self.added_stacks))
		self.added_stacks = self:GetLevel() * 10
		legion_ult.added_stacks = self.added_stacks
	end
end

function legion_ult2:GetCastRange()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int8") then 
		return 800
	end
end

legion_ult = class({})

function legion_ult:GetCastRange()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int8") then 
		return 800
	end
end

function legion_ult:GetIntrinsicModifierName()
	return "modifier_legion_ult"
end

function legion_ult:OnUpgrade()
	legion_ult2 = self:GetCaster():FindAbilityByName("legion_ult2")
	level = self:GetLevel()
	if level > legion_ult2:GetLevel() then
		legion_ult2:SetLevel(level)
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_legion_commander_str50") and self.added_stacks < 100 then
		local modifier = self:GetCaster():FindModifierByName("modifier_legion_ult")
		modifier:SetStackCount(modifier:GetStackCount() + (self:GetLevel() * 10 - self.added_stacks))
		self.added_stacks = self:GetLevel() * 10
		legion_ult2.added_stacks = self.added_stacks
	end
end

modifier_legion_ult = class({})

function modifier_legion_ult:IsHidden()
	return false
end

function modifier_legion_ult:IsPurgable()
	return false
end

function modifier_legion_ult:RemoveOnDeath()
	return false
end

function modifier_legion_ult:GetTexture()
    return "legion_commander_duel"
end

function modifier_legion_ult:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_legion_ult:OnIntervalThink()
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi9") then
		legion_ult = self:GetCaster():FindAbilityByName("legion_ult")
		if not legion_ult:IsHidden() then
			level = legion_ult:GetLevel()
			self:GetCaster():SwapAbilities("legion_ult", "legion_ult2", false, true)
			local legion_ult2 = self:GetCaster():FindAbilityByName("legion_ult2")
			-- legion_ult2:SetLevel(level)
		end
	else
		legion_ult2 = self:GetCaster():FindAbilityByName("legion_ult2")
		if not legion_ult2:IsHidden() then
			level = legion_ult2:GetLevel()
			if level > 10 then
				level = 10
			end
			self:GetCaster():SwapAbilities("legion_ult", "legion_ult2", true, false)
			local legion_ult = self:GetCaster():FindAbilityByName("legion_ult")
			-- legion_ult:SetLevel(level)
		end
	end
	if not self:GetAbility():IsFullyCastable() then return end
	self:GetAbility():UseResources(false, false, false, true)
	self:IncrementStackCount()
end

function modifier_legion_ult:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
	return funcs
end

function modifier_legion_ult:OnTooltip()
    return self:CalculateDamage()
end

function modifier_legion_ult:OnTooltip2()
	return self:CalculateHPRegen()
end

function modifier_legion_ult:OnDeath(params)
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi9") then
	-- 	if IsMyKilledBadGuys(self:GetParent(), params) and RandomInt(1,100) <= 5 then
	-- 		self:IncrementStackCount()
	-- 	end
	-- end
end

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then return false end
    if hero == params.attacker then
        return true
    else
        if hero == params.attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end

function modifier_legion_ult:GetModifierPreAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") ~= nil then
		return 0
	end
    return self:CalculateDamage()
end

function modifier_legion_ult:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") == nil then 
		return 0
	end
    return self:CalculateDamage()
end

function modifier_legion_ult:GetModifierConstantHealthRegen()
	return self:CalculateHPRegen()
end

function modifier_legion_ult:CalculateDamage()
	self.dmg_per_stack = self:GetAbility():GetSpecialValueFor("dmg_per_stack")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi9") then
		legion_ult2 = self:GetCaster():FindAbilityByName("legion_ult2")
		self.dmg_per_stack = legion_ult2:GetSpecialValueFor("dmg_per_stack")
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi6") then 
		self.dmg_per_stack = self.dmg_per_stack + 2
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str_last") then
		self.dmg_per_stack = self.dmg_per_stack * 4
	end
    return self:GetStackCount() * self.dmg_per_stack
end

function modifier_legion_ult:CalculateHPRegen()
	self.hp_regen_per_stack = self:GetAbility():GetSpecialValueFor("hp_regen_per_stack")
	local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str9")
	if talent ~= nil then 
		return self:GetStackCount() * talent:GetLevelSpecialValueFor("value", self:GetAbility():GetLevel())
	end
	return self:GetStackCount() * self.hp_regen_per_stack
end

function modifier_legion_ult:IsAura() 
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int8") then
		return true 
	end
	return false 
end

function modifier_legion_ult:GetModifierAura() 
	return "modifier_legion_ult_aura" 
end

function modifier_legion_ult:GetAuraRadius()
	return 800
end

function modifier_legion_ult:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_legion_ult:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_legion_ult:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_HERO
end

function modifier_legion_ult:GetAuraDuration()
	return 0.1
end

function modifier_legion_ult:GetAuraEntityReject(target)
	if target == self:GetCaster() then
		return true
	end
end

--------------------------------------------------------------------------------------------

modifier_legion_ult_aura = {}

function modifier_legion_ult_aura:IsDebuff() return false end
function modifier_legion_ult_aura:IsPurgable() return false end
function modifier_legion_ult_aura:IsHidden() return false end

function modifier_legion_ult_aura:GetTexture()
    return "legion_commander_duel"
end

function modifier_legion_ult_aura:OnCreated( kv )
	if IsServer() then 
		self.damage = self:GetCaster():FindModifierByName("modifier_legion_ult"):CalculateDamage()
		self.hp = self:GetCaster():FindModifierByName("modifier_legion_ult"):CalculateHPRegen()
		self:SetHasCustomTransmitterData(true)
	end
end

function modifier_legion_ult_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_legion_ult_aura:AddCustomTransmitterData()
    return
    {
        damage = self.damage,
        hp = self.hp
    }
end

function modifier_legion_ult_aura:HandleCustomTransmitterData(data)
    if data.damage ~= nil then
       self.damage = tonumber(data.damage)
    end
	if data.hp ~= nil then
        self.hp = tonumber(data.hp)
    end
end

function modifier_legion_ult_aura:GetModifierPreAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") ~= nil then
		return 0
	end
	return self.damage
end

function modifier_legion_ult_aura:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") == nil then 
		return 0
	end
	return self.damage
end

function modifier_legion_ult_aura:GetModifierConstantHealthRegen()
	return self.hp
end

modifier_legion_ult2 = class({})

function modifier_legion_ult2:IsHidden()
	return true
end

function modifier_legion_ult2:IsPurgable()
	return false
end

function modifier_legion_ult2:RemoveOnDeath()
	return false
end

function modifier_legion_ult2:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_legion_ult2:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetAbility():IsFullyCastable() then return end
	self:GetAbility():UseResources(false, false, false, true)
end