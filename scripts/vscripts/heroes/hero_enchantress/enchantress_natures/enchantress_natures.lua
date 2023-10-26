LinkLuaModifier("modifier_enchantress_natures", "heroes/hero_enchantress/enchantress_natures/enchantress_natures", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff", "heroes/hero_enchantress/enchantress_natures/enchantress_natures", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchantress_natures_talant", "heroes/hero_enchantress/enchantress_natures/enchantress_natures", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchantress_natures_talant_aura", "heroes/hero_enchantress/enchantress_natures/enchantress_natures", LUA_MODIFIER_MOTION_NONE)
enchantress_natures = class({}) 

function enchantress_natures:GetIntrinsicModifierName()
    return "modifier_enchantress_natures"
end

modifier_enchantress_natures = class({}) 

function modifier_enchantress_natures:IsHidden()      return true end
function modifier_enchantress_natures:IsPurgable()    return false end

function modifier_enchantress_natures:OnCreated( kv )
	self.mana_cost= self:GetAbility():GetSpecialValueFor( "mana_cost" )
	self.move_speed= self:GetAbility():GetSpecialValueFor( "move_speed" )
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str_last") ~= nil then
		self:GetAbility():GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_enchantress_natures_talant",nil)
	end
end

function modifier_enchantress_natures:OnRefresh( kv )
	self.mana_cost= self:GetAbility():GetSpecialValueFor( "mana_cost" )
	self.move_speed= self:GetAbility():GetSpecialValueFor( "move_speed" )
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str_last") ~= nil then
		self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_enchantress_natures_talant",nil)
	end
end

function modifier_enchantress_natures:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		
    }
end

function modifier_enchantress_natures:GetModifierPercentageManacost( keys )
 return self.mana_cost 
end

function modifier_enchantress_natures:GetModifierMoveSpeedBonus_Percentage( keys )
 return self.move_speed 
end

function modifier_enchantress_natures:GetModifierMagicalResistanceBonus( keys )
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str10")             
	if abil ~= nil then 
 return self.mana_cost 
 end
 return 0
end


function modifier_enchantress_natures:GetModifierAttackSpeedBonus_Constant()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_agi10")
		if abil ~= nil	then 
	return self:GetCaster():GetLevel() * 5
	end
	return 0
end



function modifier_enchantress_natures:OnAttack( params )
	if IsServer() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		if pass then
		
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_agi9")             
			if abil ~= nil then 
				
					local caster = params.attacker
					local target = params.target
					local ability = self
					local attack_range = caster:Script_GetAttackRange() + 100
					local arrow_count = 1
					
					if ability ~= nil then 

					local units = FindUnitsInRadius(caster:GetTeamNumber(), 
													caster:GetAbsOrigin(),
													nil,
													attack_range,
													DOTA_UNIT_TARGET_TEAM_ENEMY,
													DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
													DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
													FIND_CLOSEST, 
													false) 
					
					if ability.split == nil then
						ability.split = true
					elseif ability.split == false then
						return
					end
					
					ability.split = false 
					if arrow_count > #units-1  then 
						arrow_count = #units-1
					end

					local index = 1
					local arrow_deal = 0
					
					while arrow_deal < arrow_count   do
						if units[index] == target then
						else
							caster:PerformAttack(units[ index ], false, true, true, false, true, false, false)
							arrow_deal = arrow_deal + 1
						end	
						index = index + 1
					end
					
					ability.split = true	
				end
			end
		end
	end
end

function modifier_enchantress_natures:GetModifierProcAttack_Feedback( params )
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int11")             
	if abil ~= nil then 
	if IsServer() then
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_debuff",
				{ duration = 2 }
			)
	end
	end
end

---------------------------------------------------------------------------------------------------------------------------	
---------------------------------------------------------------------------------------------------------------------------

modifier_debuff = class({})

function modifier_debuff:IsHidden()
	return false
end

function modifier_debuff:IsDebuff()
	return true
end

function modifier_debuff:IsStunDebuff()
	return false
end

function modifier_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_debuff:GetModifierMagicalResistanceBonus()
	return -15
end
------
--талант ауры
------
modifier_enchantress_natures_talant = {}

function modifier_enchantress_natures_talant:IsHidden()
	return true
end

function modifier_enchantress_natures_talant:IsDebuff()
	return true
end

function modifier_enchantress_natures_talant:IsPurgable()
	return false
end

function modifier_enchantress_natures_talant:GetAuraRadius()
	if self:GetAbility() then
		return 1200
	end
end

function modifier_enchantress_natures_talant:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_enchantress_natures_talant:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_enchantress_natures_talant:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_enchantress_natures_talant:GetModifierAura()
	return "modifier_enchantress_natures_talant_aura"
end

function modifier_enchantress_natures_talant:IsAura()
	return true
end

modifier_enchantress_natures_talant_aura = {}

function modifier_enchantress_natures_talant_aura:IsHidden() return false end
function modifier_enchantress_natures_talant_aura:IsPurgable() return false end
function modifier_enchantress_natures_talant_aura:RemoveOnDeath() return false end
function modifier_enchantress_natures_talant_aura:IsAuraActiveOnDeath() return false end

function modifier_enchantress_natures_talant_aura:OnCreated()
	self.mana_cost = self:GetAbility():GetSpecialValueFor( "mana_cost" )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_enchantress_str50") then
		self.mana_cost = self.mana_cost * 2
		self.move_speed = self.move_speed * 2
	end
end

function modifier_enchantress_natures_talant_aura:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_enchantress_natures_talant_aura:GetModifierPercentageManacost( keys )
 return self.mana_cost 
end

function modifier_enchantress_natures_talant_aura:GetModifierMoveSpeedBonus_Percentage( keys )
 return self.move_speed 
end