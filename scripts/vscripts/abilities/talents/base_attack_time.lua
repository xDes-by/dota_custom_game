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
end

function modifier_base_attack_time:OnRefresh( kv )
end

function modifier_base_attack_time:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_base_attack_time:GetModifierAttackSpeedBonus_Constant()
	level = self.caster:GetLevel()
	if level % 5 == 0 then
		return level
	end
	return level - (math.fmod(level, 5))
end