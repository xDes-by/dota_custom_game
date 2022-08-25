npc_dota_hero_slark_agi11 = class({})
LinkLuaModifier( "modifier_slark_base", "heroes/hero_slark/base_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_slark_agi11:GetIntrinsicModifierName()
	return "modifier_slark_base"
end

-------------------------------------------
-------------------------------------------

modifier_slark_base = class({})

function modifier_slark_base:IsHidden()
	return true
end

function modifier_slark_base:IsPurgable()
	return false
end

function modifier_slark_base:RemoveOnDeath()
	return false
end

function modifier_slark_base:OnCreated( kv )
	self.caster = self:GetCaster()
	self.base_time = self.caster:GetBaseAttackTime() - 0.1
end

function modifier_slark_base:OnRefresh( kv )
end

function modifier_slark_base:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_slark_base:GetModifierBaseAttackTimeConstant()
	return self.base_time
end