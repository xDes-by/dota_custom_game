modifier_dragon_form_lua_frost = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dragon_form_lua_frost:IsHidden()
	return false
end

function modifier_dragon_form_lua_frost:IsDebuff()
	return true
end

function modifier_dragon_form_lua_frost:IsStunDebuff()
	return false
end

function modifier_dragon_form_lua_frost:IsPurgable()
	return false
end

function modifier_dragon_form_lua_frost:OnCreated( kv )
	self.frost_as = self:GetAbility():GetSpecialValueFor( "frost_bonus_attack_speed" )
	self.frost_ms = self:GetAbility():GetSpecialValueFor( "frost_bonus_movement_speed" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi9") 
	if abil ~= nil then
	self.frost_as = self.frost_as * 2
	self.frost_ms = self.frost_ms * 2
	end
end

function modifier_dragon_form_lua_frost:OnRefresh( kv )
	self.frost_as = self:GetAbility():GetSpecialValueFor( "frost_bonus_attack_speed" )
	self.frost_ms = self:GetAbility():GetSpecialValueFor( "frost_bonus_movement_speed" )	
		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi9") 
	if abil ~= nil then
	self.frost_as = self.frost_as * 2
	self.frost_ms = self.frost_ms * 2
	end
end

function modifier_dragon_form_lua_frost:OnRemoved()
end

function modifier_dragon_form_lua_frost:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dragon_form_lua_frost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_dragon_form_lua_frost:GetModifierMoveSpeedBonus_Percentage()
	return self.frost_ms
end
function modifier_dragon_form_lua_frost:GetModifierAttackSpeedBonus_Constant()
	return self.frost_as
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dragon_form_lua_frost:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end