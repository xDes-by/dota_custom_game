lion_mana_aura = class({})
LinkLuaModifier( "modifier_lion_mana_aura", "heroes/hero_lion/lion_mana_aura/lion_mana_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aura_slow", "heroes/hero_lion/lion_mana_aura/lion_mana_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aura_slow_effect", "heroes/hero_lion/lion_mana_aura/lion_mana_aura", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function lion_mana_aura:GetIntrinsicModifierName()
	return "modifier_lion_mana_aura"
end

modifier_lion_mana_aura = class({})

--------------------------------------------------------------------------------
function modifier_lion_mana_aura:IsHidden()
	return true
end

function modifier_lion_mana_aura:IsPurgable()
	return false
end

function modifier_lion_mana_aura:OnCreated( kv )
	self.caster = self:GetCaster()
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.mana_loss = self:GetAbility():GetSpecialValueFor( "mana_loss" )
	self.aura_mana_loss_interval = self:GetAbility():GetSpecialValueFor( "aura_mana_loss_interval" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	if not self:GetCaster():HasModifier("modifier_aura_slow") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_aura_slow", {})
	end
	self:StartIntervalThink(self.aura_mana_loss_interval)
end

function modifier_lion_mana_aura:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	self.mana_loss = self:GetAbility():GetSpecialValueFor( "mana_loss" )
	self.aura_mana_loss_interval = self:GetAbility():GetSpecialValueFor( "aura_mana_loss_interval" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_int7")	
		if abil ~= nil then
		self.mana_loss = self.mana_loss * 2
		end
end

function modifier_lion_mana_aura:OnIntervalThink()
if IsServer() then 
self:OnRefresh()
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.aura_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
    if #enemies > 0 then
		for _,unit in pairs(enemies) do
			if unit:GetMana() >= self.mana_loss then
			unit:Script_ReduceMana(self.mana_loss/10, nil)--ReduceMana(self.mana_loss/10)			
			if self.caster:GetMana() < self.caster:GetMaxMana() then
			self.caster:SetMana(self.caster:GetMana() + (self.mana_loss/10)*#enemies)	
			end
			end
		end
	end
	end
end


function modifier_lion_mana_aura:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_lion_mana_aura:GetModifierIncomingDamage_Percentage()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_str7")	
		if abil ~= nil then
	return -15
	end
	return 0
end

function modifier_lion_mana_aura:GetModifierAttackSpeedBonus_Constant()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_agi11")	
		if abil ~= nil then
	return self:GetCaster():GetLevel() * 5
	end
	return 0
end

function modifier_lion_mana_aura:OnAttackLanded(params)
	if params.attacker:FindAbilityByName("lion_earth_spike_lua") ~= nil and RandomInt(1,100) <= 5 and self:GetCaster():FindAbilityByName("npc_dota_hero_lion_agi_last") ~= nil then
		if params.attacker:FindAbilityByName("lion_earth_spike_lua"):IsTrained() then
			_G.spiketarget = params.target
			params.attacker:FindAbilityByName("lion_earth_spike_lua"):OnSpellStart()
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_aura_slow = class({})

function modifier_aura_slow:IsDebuff() return false end
function modifier_aura_slow:AllowIllusionDuplicate() return true end
function modifier_aura_slow:IsHidden() return true end
function modifier_aura_slow:IsPurgable() return false end

function modifier_aura_slow:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_aura_slow:GetAuraEntityReject(target)
	return false
end

function modifier_aura_slow:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_aura_slow:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_aura_slow:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_aura_slow:GetModifierAura()
	return "modifier_aura_slow_effect"
end

function modifier_aura_slow:IsAura()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
modifier_aura_slow_effect = class({})

function modifier_aura_slow_effect:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
end

function modifier_aura_slow_effect:IsHidden() return false end
function modifier_aura_slow_effect:IsPurgable() return false end
function modifier_aura_slow_effect:IsDebuff() return true end

function modifier_aura_slow_effect:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS 
	}
end

function modifier_aura_slow_effect:GetModifierMoveSpeedBonus_Constant()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_int7")	
		if abil ~= nil then
	return self:GetAbility():GetSpecialValueFor("slow") *(-1) *2
	end
	return self:GetAbility():GetSpecialValueFor("slow") *(-1)
end

function modifier_aura_slow_effect:GetModifierMagicalResistanceBonus()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_int11")	
		if abil ~= nil then
	return -20
	end
	return 0
end

function modifier_aura_slow_effect:GetModifierPhysicalArmorBonus()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_agi7")	
		if abil ~= nil then
	return self:GetAbility():GetSpecialValueFor( "mana_loss" ) * (-1)
	end
	return 0
end