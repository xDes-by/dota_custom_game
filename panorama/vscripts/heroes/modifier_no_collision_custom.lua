modifier_no_collision_custom = class({
	CheckState = function(self)
		return {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		}
	end,
	IsHidden 	= function(self) return true end,
	IsDebuff 	= function(self) return false end,
	IsBuff 		= function(self) return true end,
	IsPurgable  = function(self) return false end,
})	