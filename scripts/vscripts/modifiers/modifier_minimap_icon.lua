modifier_minimap_icon = class({})

function modifier_minimap_icon:IsHidden() return true end
function modifier_minimap_icon:IsPurgable() return false end
function modifier_minimap_icon:RemoveOnDeath() return false end

function modifier_minimap_icon:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = false
	}
  	return state
end