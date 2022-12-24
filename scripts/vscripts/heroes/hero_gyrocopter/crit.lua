npc_dota_hero_gyrocopter_agi8 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_gyrocopter_agi8", "heroes/hero_gyrocopter/crit", LUA_MODIFIER_MOTION_NONE )

function npc_dota_hero_gyrocopter_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_gyrocopter_agi8"
end

--------------------------------------

modifier_npc_dota_hero_gyrocopter_agi8 = class({})

function modifier_npc_dota_hero_gyrocopter_agi8:IsHidden()
	return true
end

function modifier_npc_dota_hero_gyrocopter_agi8:IsPurgable()
	return false
end

function modifier_npc_dota_hero_gyrocopter_agi8:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

function modifier_npc_dota_hero_gyrocopter_agi8:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(1, 100)< 15 then
			return 200 + self:GetParent():GetLevel()
		end
	end
end
