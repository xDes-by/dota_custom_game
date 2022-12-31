modifier_out_from_vision = class({})
--------------------------------------------------------------------------------
function modifier_out_from_vision:OnCreated()
	if not IsServer() then return end
	self:ApplyVerticalMotionController()
	local parent = self:GetParent()
	
	self.newPoint = parent:GetAbsOrigin()+Vector(0,0,-5000)
	self.model = "models/development/invisiblebox.vmdl"
	parent:SetModel(self.model)
	parent:SetOriginalModel(self.model)
end
--------------------------------------------------------------------------------
function modifier_out_from_vision:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_STUNNED] 			= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
	}
end
--------------------------------------------------------------------------------
function modifier_out_from_vision:DeclareFunctions()
	return {
		[MODIFIER_PROPERTY_MODEL_CHANGE] 	= true,
		[MODIFIER_EVENT_ON_MODEL_CHANGED] 	= true,
	}
end
--------------------------------------------------------------------------------
function modifier_out_from_vision:UpdateVerticalMotion(me, dt)
	if not IsServer() then return end
	me:SetAbsOrigin(self.newPoint)
end

--------------------------------------------------------------------------------
function modifier_out_from_vision:OnDestroy()
	if not IsServer() then return end
	self:GetParent():InterruptMotionControllers(true)
	self:GetParent():ForceKill(false)
end
--------------------------------------------------------------------------------
function modifier_out_from_vision:GetModifierModelChange()
	return self.model
end
--------------------------------------------------------------------------------
function modifier_out_from_vision:OnModelChanged()
	local parent = self:GetParent()
	parent:SetModel(self.model)
	parent:SetOriginalModel(self.model)
end
--------------------------------------------------------------------------------
