stоneman = class({})
LinkLuaModifier( "modifier_stоneman", "abilities/stоneman", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function stоneman:GetIntrinsicModifierName()
	return "modifier_stоneman"
end

-------------------------------------------------------------------------------

modifier_stоneman = class({})

--------------------------------------------------------------------------------

function modifier_stоneman:IsHidden()
	return false
end


function modifier_stоneman:IsPurgable()
    return false
end


function modifier_stоneman:CheckState()
	local state = {

		[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

