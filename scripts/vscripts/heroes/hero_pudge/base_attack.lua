npc_dota_hero_pudge_agi11 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_pudge_agi11", "heroes/hero_pudge/base_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_pudge_agi11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_pudge_agi11"
end

-------------------------------------------
-------------------------------------------

modifier_npc_dota_hero_pudge_agi11 = class({})

function modifier_npc_dota_hero_pudge_agi11:IsHidden()
	return true
end

function modifier_npc_dota_hero_pudge_agi11:IsPurgable()
	return false
end

function modifier_npc_dota_hero_pudge_agi11:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_pudge_agi11:OnCreated( kv )
	self.caster = self:GetCaster()
	self.base_time = self.caster:GetBaseAttackTime() - 0.1
end

function modifier_npc_dota_hero_pudge_agi11:OnRefresh( kv )
end

function modifier_npc_dota_hero_pudge_agi11:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_npc_dota_hero_pudge_agi11:GetModifierBaseAttackTimeConstant()
	return self.base_time
end