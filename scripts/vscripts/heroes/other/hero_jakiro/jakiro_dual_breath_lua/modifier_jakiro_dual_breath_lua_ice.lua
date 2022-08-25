modifier_jakiro_dual_breath_lua_ice = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jakiro_dual_breath_lua_ice:IsHidden()
	return false
end

function modifier_jakiro_dual_breath_lua_ice:IsDebuff()
	return true
end

function modifier_jakiro_dual_breath_lua_ice:IsStunDebuff()
	return false
end

function modifier_jakiro_dual_breath_lua_ice:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jakiro_dual_breath_lua_ice:OnCreated( kv )
if IsServer() then
	 self.caster = self:GetCaster()
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed_pct" )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
	
		local abil = self.caster:FindAbilityByName("special_bonus_unique_jakiro_custom3")
		if abil ~= nil and abil:IsTrained()	then 
		self.as_slow = self.as_slow + (-10)
		self.ms_slow = self.ms_slow + (-10)
		end
		
	end
end

function modifier_jakiro_dual_breath_lua_ice:OnRefresh( kv )
if IsServer() then
	 self.caster = self:GetCaster()
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed_pct" )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
	
		local abil = self.caster:FindAbilityByName("special_bonus_unique_jakiro_custom3")
		if abil ~= nil and abil:IsTrained()	then 
		self.as_slow = self.as_slow + (-10)
		self.ms_slow = self.ms_slow + (-10)
		end
		
	end
end

function modifier_jakiro_dual_breath_lua_ice:OnRemoved()
end

function modifier_jakiro_dual_breath_lua_ice:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jakiro_dual_breath_lua_ice:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_jakiro_dual_breath_lua_ice:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_jakiro_dual_breath_lua_ice:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_jakiro_dual_breath_lua_ice:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_jakiro_dual_breath_lua_ice:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end