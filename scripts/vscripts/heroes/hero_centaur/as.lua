npc_dota_hero_centaur_agi8 = class({})

function npc_dota_hero_centaur_agi8:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_centaur_agi8"
end

LinkLuaModifier("modifier_npc_dota_hero_centaur_agi8", "heroes/hero_centaur/as", LUA_MODIFIER_MOTION_NONE)

modifier_npc_dota_hero_centaur_agi8 = class({})

function modifier_npc_dota_hero_centaur_agi8:IsHidden()
    return true
end

function modifier_npc_dota_hero_centaur_agi8:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_npc_dota_hero_centaur_agi8:IsPurgable()
	return false
end

function modifier_npc_dota_hero_centaur_agi8:RemoveOnDeath()
	return false
end

function modifier_npc_dota_hero_centaur_agi8:GetModifierAttackSpeedBonus_Constant()
	local abil = self:GetCaster():FindAbilityByName("borrowed_time_datadriven")
	if abil ~= nil and abil:GetLevel() > 0 then 
		return self:GetCaster():GetLevel() * 5
	end
	return 0
end