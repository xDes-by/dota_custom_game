LinkLuaModifier( "modifier_pet_ability", "items/pets/pet_ability", LUA_MODIFIER_MOTION_NONE )

pet_ability = class({})

function pet_ability:GetIntrinsicModifierName()
	return "modifier_pet_ability"
end

modifier_pet_ability = class({})

function modifier_pet_ability:IsHidden()
    return true
end

function modifier_pet_ability:IsPurgable()
    return false
end

function modifier_pet_ability:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
	return state
end