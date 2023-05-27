LinkLuaModifier("modifier_legion_ult", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_ult_aura", "heroes/hero_legion/legion_ult/legion_ult", LUA_MODIFIER_MOTION_NONE)

legion_ult = class({})

function legion_ult:GetIntrinsicModifierName()
	return "modifier_legion_ult"
end

modifier_legion_ult = class({})

function modifier_legion_ult:IsHidden() return false end
function modifier_legion_ult:IsDebuff() return false end
function modifier_legion_ult:IsPurgable() return false end
function modifier_legion_ult:IsPermanent() return true end
function modifier_legion_ult:RemoveOnDeath() return false end
function modifier_legion_ult:GetTexture()
    return "legion_commander_duel"
end

stack = 0.01

function modifier_legion_ult:OnCreated()
	self.shag = self:GetAbility():GetSpecialValueFor( "shag" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self:StartIntervalThink(0.1)
end

function modifier_legion_ult:OnRefresh( kv )
	self.shag = self:GetAbility():GetSpecialValueFor( "shag" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end
	
function modifier_legion_ult:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetAbility():IsFullyCastable() then return end
	self:GetAbility():UseResources(true, false, false, true)
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
    return CalculateDamage(self)
end

function modifier_legion_ult:OnTooltip2()
	return CalculateHPRegen(self)
end

function modifier_legion_ult:OnDeath(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi9") then
		if IsMyKilledBadGuys(self:GetParent(), params) and RollPercentage(5) then
			self:IncrementStackCount()
		end
	end
end

function modifier_legion_ult:GetModifierPreAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") ~= nil then
		return 0
	end
    return CalculateDamage(self)
end

function modifier_legion_ult:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") == nil then 
		return 0
	end
    return CalculateDamage(self)
end

function modifier_legion_ult:GetModifierConstantHealthRegen()
	return CalculateHPRegen(self)
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
	return 700
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

function CalculateDamage( modifier )
	local dmg_per_stack = modifier:GetAbility():GetSpecialValueFor("dmg_per_stack")
	if modifier:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_agi6") then 
		dmg_per_stack = dmg_per_stack + 1
	end
	if modifier:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str_last") then
		dmg_per_stack = dmg_per_stack * 5
	end
    return modifier:GetStackCount() * dmg_per_stack
end

function CalculateHPRegen( modifier )
	local hp_regen_per_stack = modifier:GetAbility():GetSpecialValueFor("hp_regen_per_stack")
	local talent = modifier:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_str9")
	if talent ~= nil then 
		return modifier:GetStackCount() * talent:GetLevelSpecialValueFor("value", modifier:GetAbility():GetLevel())
	end
	return modifier:GetStackCount() * hp_regen_per_stack
end

modifier_legion_ult_aura = {}

function modifier_legion_ult_aura:IsDebuff() return false end
function modifier_legion_ult_aura:IsPurgable() return false end
function modifier_legion_ult_aura:IsHidden() 
	if self:GetCaster() == self:GetParent() then
		return true
	end
	return false
end
function modifier_legion_ult_aura:GetTexture()
    return "legion_commander_duel"
end

function modifier_legion_ult_aura:OnCreated( kv )
	print(self:GetCaster():HasModifier("modifier_legion_ult"))
    self.mod = self:GetCaster():FindModifierByName("modifier_legion_ult")
	print(self.mod)

end

function modifier_legion_ult_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_legion_ult_aura:GetModifierPreAttack_BonusDamage()
	if self:GetCaster() == self:GetParent() then return 0 end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") ~= nil then 
		return 0
	end
	return CalculateDamage(self.mod)
end

function modifier_legion_ult:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster() == self:GetParent() then return 0 end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") == nil then 
		return 0
	end
    return CalculateDamage(self.mod)
end

function modifier_legion_ult_aura:GetModifierConstantHealthRegen()
	if self:GetCaster() == self:GetParent() then return 0 end
	return CalculateHPRegen(self)
end