windrunner_windrun_lua = class({})
LinkLuaModifier( "modifier_windrunner_windrun_lua", "heroes/hero_windranger/windrunner_windrun/windrunner_windrun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_windrun_lua_effect", "heroes/hero_windranger/windrunner_windrun/windrunner_windrun", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function windrunner_windrun_lua:GetIntrinsicModifierName()
	return "modifier_windrunner_windrun_lua"
end

modifier_windrunner_windrun_lua = class({})

--------------------------------------------------------------------------------
function modifier_windrunner_windrun_lua:IsHidden()
	return true
end

function modifier_windrunner_windrun_lua:IsPurgable()
	return false
end

function modifier_windrunner_windrun_lua:OnCreated( kv )
end

function modifier_windrunner_windrun_lua:OnRefresh( kv )
end

--------------------------------------------------------------------------------
function modifier_windrunner_windrun_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED,
	}
	return funcs
end

function modifier_windrunner_windrun_lua:OnUnitMoved(keys)
	if keys.unit == self:GetCaster() then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_windrunner_windrun_lua_effect",{ duration = 0.2 })
		 	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_str9")	
			if abil ~= nil then 
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_magic_immune",{ duration = 0.2 })
			end
	end
end

----------------------------------------------------------------------------
modifier_windrunner_windrun_lua_effect = class({})

--------------------------------------------------------------------------------
function modifier_windrunner_windrun_lua_effect:IsHidden()
	return true
end

function modifier_windrunner_windrun_lua_effect:IsPurgable()
	return false
end

function modifier_windrunner_windrun_lua_effect:OnCreated( )
end

function modifier_windrunner_windrun_lua_effect:OnRefresh( kv )
end

--------------------------------------------------------------------------------
function modifier_windrunner_windrun_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

function modifier_windrunner_windrun_lua_effect:GetModifierMoveSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor( "speed" )
	end
end

function modifier_windrunner_windrun_lua_effect:GetModifierEvasion_Constant()
	if not self:GetParent():PassivesDisabled() then
		if self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_windrunner_str50") then
			return 100
		else
			return self:GetAbility():GetSpecialValueFor( "eva" )
		end
	end
end

function modifier_windrunner_windrun_lua_effect:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_windrunner_windrun_lua_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end