modifier_blink_strike_lua_cmd = modifier_blink_strike_lua_cmd or class({})
function modifier_blink_strike_lua_cmd:IsPurgable() return false end
function modifier_blink_strike_lua_cmd:IsHidden() return true end
function modifier_blink_strike_lua_cmd:IsDebuff() return false end

function modifier_blink_strike_lua_cmd:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_blink_strike_lua_cmd:OnCreated()
	if IsServer() then
		local hCaster = self:GetCaster()

	end
end

function modifier_blink_strike_lua_cmd:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_DISARMED ] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR ] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		return state
	end
end

function modifier_blink_strike_lua_cmd:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
			MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
			MODIFIER_PROPERTY_DISABLE_TURNING
		}
	return decFuns
end

function modifier_blink_strike_lua_cmd:GetActivityTranslationModifiers()
	if self:GetParent():GetName() == "npc_dota_hero_riki" then
		return "backstab"
	end
	return 0
end

function modifier_blink_strike_lua_cmd:GetModifierDisableTurning()
	return 1
end