crystal_maiden_mana_aura_lua = class({})
LinkLuaModifier( "modifier_crystal_maiden_mana_aura_lua", "heroes/hero_crystal/crystal_maiden_mana_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_mana_aura_lua_effect", "heroes/hero_crystal/crystal_maiden_mana_aura_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function crystal_maiden_mana_aura_lua:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_mana_aura_lua"
end
modifier_crystal_maiden_mana_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_crystal_maiden_mana_aura_lua:IsHidden()
	return true
end

function modifier_crystal_maiden_mana_aura_lua:IsDebuff()
	return false
end

function modifier_crystal_maiden_mana_aura_lua:IsPurgable()
	return false
end

function modifier_crystal_maiden_mana_aura_lua:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_crystal_maiden_mana_aura_lua:GetModifierAura()
	return "modifier_crystal_maiden_mana_aura_lua_effect"
end

function modifier_crystal_maiden_mana_aura_lua:GetAuraRadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_str9")
	if abil ~= nil then 
	return FIND_UNITS_EVERYWHERE
	end
	return 800
end

function modifier_crystal_maiden_mana_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_crystal_maiden_mana_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

modifier_crystal_maiden_mana_aura_lua_effect = class({})

function modifier_crystal_maiden_mana_aura_lua_effect:IsHidden()
	return false
end

function modifier_crystal_maiden_mana_aura_lua_effect:IsDebuff()
	return false
end

function modifier_crystal_maiden_mana_aura_lua_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_mana_aura_lua_effect:OnCreated( kv )
	-- references
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.regen_self = self:GetAbility():GetSpecialValueFor( "mana_regen_self" )
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_str6")
		if abil ~= nil then 
		self.regen_ally = self.regen_ally*1.5
		self.regen_self = self.regen_self*1.5
		end
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_str_last")
		if abil ~= nil then
			self.regen_ally = self.regen_ally * 2
		self.regen_self = self.regen_self * 2
		end	
end

function modifier_crystal_maiden_mana_aura_lua_effect:OnRefresh( kv )
	-- references
	self.regen_self = self:GetAbility():GetSpecialValueFor( "mana_regen_self" ) -- special value
	self.regen_ally = self:GetAbility():GetSpecialValueFor( "mana_regen" ) -- special value
end




function modifier_crystal_maiden_mana_aura_lua_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_crystal_maiden_mana_aura_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end
function modifier_crystal_maiden_mana_aura_lua_effect:OnAttackLanded(params)
	if params.attacker:FindAbilityByName("special_bonus_unique_npc_dota_hero_crystal_maiden_agi50") then
		rand = 25
	else
		rand = 15
	end 
	if  params.attacker:FindAbilityByName("crystal_nova_lua") ~= nil and self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_agi_last") ~= nil and RollPercentage(rand) then
		if params.attacker:FindAbilityByName("crystal_nova_lua"):IsTrained() then
			_G.novatarget = params.target
			params.attacker:FindAbilityByName("crystal_nova_lua"):OnSpellStart()
		end
	end
end

function modifier_crystal_maiden_mana_aura_lua_effect:GetModifierConstantManaRegen()
	if self:GetParent()==self:GetCaster() then return self.regen_self end
	return self.regen_ally
end

function modifier_crystal_maiden_mana_aura_lua_effect:GetModifierSpellAmplify_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_str_last") ~= nil then
		if self:GetParent()==self:GetCaster() then 
			return self:GetAbility():GetSpecialValueFor("spell_amplify") * 2
		end
			return self:GetAbility():GetSpecialValueFor("spell_amplify")
	else
	if self:GetParent()==self:GetCaster() then 
		return self:GetAbility():GetSpecialValueFor("spell_amplify")
	end
		return self:GetAbility():GetSpecialValueFor("spell_amplify") / 2
	end
end

