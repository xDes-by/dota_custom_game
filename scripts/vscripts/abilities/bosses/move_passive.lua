move_passive = class({})

LinkLuaModifier( "modifier_move_passive", "abilities/bosses/move_passive", LUA_MODIFIER_MOTION_NONE )

function move_passive:GetIntrinsicModifierName()
	return "modifier_move_passive"
end

--------------------------------------------------------------------------------------

modifier_move_passive = class({})

function modifier_move_passive:IsHidden()
	return true
end

function modifier_move_passive:IsPurgable()
	return false
end

function modifier_move_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

function modifier_move_passive:GetActivityTranslationModifiers( params )
	return "run"
end
