npc_dota_hero_wisp_agi7 = class({})

function npc_dota_hero_wisp_agi7:GetIntrinsicModifierName()
	return "modifier_as_speed"
end

LinkLuaModifier( "modifier_as_speed", "heroes/hero_wisp/as_speed", LUA_MODIFIER_MOTION_NONE )

modifier_as_speed = class({})

function modifier_as_speed:IsHidden()
    return true
end

function modifier_as_speed:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_as_speed:IsPurgable()
	return false
end

function modifier_as_speed:RemoveOnDeath()
	return false
end

function modifier_as_speed:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():GetLevel() * 5
end
