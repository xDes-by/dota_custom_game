local MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9 = 10001

modifier_terrorblade_reflection_lua_illusion = class({})

function modifier_terrorblade_reflection_lua_illusion:IsHidden()
	return true
end

function modifier_terrorblade_reflection_lua_illusion:IsDebuff()
	return false
end

function modifier_terrorblade_reflection_lua_illusion:IsPurgable()
	return false
end

function modifier_terrorblade_reflection_lua_illusion:OnCreated( kv )
	if not IsServer() then return end
end

function modifier_terrorblade_reflection_lua_illusion:OnRefresh( kv )
	
end

function modifier_terrorblade_reflection_lua_illusion:OnRemoved()
end

function modifier_terrorblade_reflection_lua_illusion:OnDestroy()
end

function modifier_terrorblade_reflection_lua_illusion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function modifier_terrorblade_reflection_lua_illusion:GetModifierMoveSpeed_Absolute()
	return 550
end

function modifier_terrorblade_reflection_lua_illusion:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	return state
end

function modifier_terrorblade_reflection_lua_illusion:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_terrorblade_reflection_lua_illusion:StatusEffectPriority()
	return MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9
end