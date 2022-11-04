LinkLuaModifier("modifier_npc_dota_hero_bloodseeker_str7", "heroes/hero_bloodseeker/hp_regen_death", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_bloodseeker_str7 = class({})

function npc_dota_hero_bloodseeker_str7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_bloodseeker_str7"
end

if modifier_npc_dota_hero_bloodseeker_str7 == nil then 
    modifier_npc_dota_hero_bloodseeker_str7 = class({})
end

function modifier_npc_dota_hero_bloodseeker_str7:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_npc_dota_hero_bloodseeker_str7:OnDeath( params )
	if IsServer() then
		if params.attacker~=self:GetParent() and params.unit~=self:GetParent() then return end
		if params.attacker==self:GetCaster() and params.unit~=self:GetCaster() then
			local heal = self:GetCaster():GetMaxHealth()*0.02
			self:GetCaster():Heal( heal, self:GetAbility() )
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), heal, nil)
		end
	end
end