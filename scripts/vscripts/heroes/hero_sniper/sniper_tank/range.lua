npc_dota_hero_sniper_str9 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_sniper_str9", "heroes/hero_sniper/sniper_tank/range", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_sniper_str9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_sniper_str9"
end

modifier_npc_dota_hero_sniper_str9 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_sniper_str9:IsHidden()
	return true
end

function modifier_npc_dota_hero_sniper_str9:IsPurgable()
	return false
end

function modifier_npc_dota_hero_sniper_str9:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_sniper_str9:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAX_ATTACK_RANGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end


function modifier_npc_dota_hero_sniper_str9:GetModifierAttackRangeBonus()
	return -550
	end

function modifier_npc_dota_hero_sniper_str9:GetModifierMaxAttackRange()
	return 350
end

function modifier_npc_dota_hero_sniper_str9:GetModifierPreAttack_BonusDamage()
	return self:GetCaster():GetStrength()*2
end
