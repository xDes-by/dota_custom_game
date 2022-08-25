crystal_slow_aura_lua = class({})
LinkLuaModifier( "modifier_crystal_slow_aura", "heroes/hero_crystal/crystal_slow_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_slow_aura_effect", "heroes/hero_crystal/crystal_slow_aura_lua", LUA_MODIFIER_MOTION_NONE )

 
--------------------------------------------------------------------------------
function crystal_slow_aura_lua:GetIntrinsicModifierName()
	return "modifier_crystal_slow_aura"
end

modifier_crystal_slow_aura = class({})

--------------------------------------------------------------------------------
function modifier_crystal_slow_aura:IsHidden()
	return true
end

function modifier_crystal_slow_aura:IsPurgable()
	return false
end

function modifier_crystal_slow_aura:IsDebuff()
	return true
end

function modifier_crystal_slow_aura:IsAura()
	return true
end
function modifier_crystal_slow_aura:GetModifierAura()
	return "modifier_crystal_slow_aura_effect"
end

function modifier_crystal_slow_aura:GetAuraRadius()
	return 800
end

function modifier_crystal_slow_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_crystal_slow_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

modifier_crystal_slow_aura_effect = class({})

function modifier_crystal_slow_aura_effect:IsHidden()
	return true
end

function modifier_crystal_slow_aura_effect:IsDebuff()
	return true
end

function modifier_crystal_slow_aura_effect:IsPurgable()
	return false
end

function modifier_crystal_slow_aura_effect:OnCreated()
	-- references
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_agi10")
	if abil ~= nil then 
		self.slow = self.slow*2
		self.as_slow = self.as_slow*2
	end	
end

function modifier_crystal_slow_aura_effect:OnRefresh()
	-- references
	self.as_slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" )-- special value
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" ) -- special value
end

function modifier_crystal_slow_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_crystal_slow_aura_effect:GetModifierBaseDamageOutgoing_Percentage(  )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_agi6")
		if abil ~= nil then 
		return -20
	end
end

function modifier_crystal_slow_aura_effect:GetModifierPhysicalArmorBonus( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_agi7")
		if abil ~= nil then 
		return -10
	end
end

function modifier_crystal_slow_aura_effect:GetModifierMagicalResistanceBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_str8")	
			if abil ~= nil then
		return -20
	end
end


function modifier_crystal_slow_aura_effect:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent()==self:GetCaster() then return self.as_slow end
	return -self.as_slow

end

function modifier_crystal_slow_aura_effect:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent()==self:GetCaster() then return self.slow end
		return -self.slow	
end