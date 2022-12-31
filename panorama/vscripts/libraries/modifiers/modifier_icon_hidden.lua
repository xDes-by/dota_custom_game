modifier_icon_hidden = class({})

function modifier_icon_hidden:IsHidden() 
	return true
end

function modifier_icon_hidden:IsPurgable() 
	return false 
end

function modifier_icon_hidden:IsPermanent( ... )
	return true
end

function modifier_icon_hidden:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
end
