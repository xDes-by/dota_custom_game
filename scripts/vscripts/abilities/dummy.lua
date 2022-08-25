LinkLuaModifier("modifier_dummy_ability", "abilities/dummy", LUA_MODIFIER_MOTION_NONE)

dummy_ability = class({})

function dummy_ability:GetIntrinsicModifierName()
    return "modifier_dummy_ability"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_dummy_ability = class({
    IsHidden                 = function(self) return false end,
    IsPurgable                 = function(self) return false end,
    IsDebuff                 = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath             = function(self) return true end,
    GetAttributes             = function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
})

function modifier_dummy_ability:OnCreated()
end

function modifier_dummy_ability:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	return state
end