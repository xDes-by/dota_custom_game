base_attack_time = class({})
LinkLuaModifier( "modifier_base_attack_time", "abilities/talents/base_attack_time", LUA_MODIFIER_MOTION_NONE )

function base_attack_time:GetIntrinsicModifierName()
	return "modifier_base_attack_time"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_base_attack_time = class({})

function modifier_base_attack_time:IsHidden()
	return true
end

function modifier_base_attack_time:IsPurgable()
	return false
end

function modifier_base_attack_time:RemoveOnDeath()
	return false
end

function modifier_base_attack_time:OnCreated( kv )
	self.caster = self:GetCaster()
	self.base_time = self.caster:GetBaseAttackTime() - 0.1
end

function modifier_base_attack_time:OnRefresh( kv )
end

function modifier_base_attack_time:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_base_attack_time:GetModifierBaseAttackTimeConstant()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_agi11")
	if abil ~= nil then 
	return self.base_time - 0.1
	end
	return self.base_time
end