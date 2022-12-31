modifier_monkey_king_wukongs_command_hidden_lua = class({})

function modifier_monkey_king_wukongs_command_hidden_lua:OnCreated()
	if not IsServer() then return end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	parent:AddNoDraw()
end


function modifier_monkey_king_wukongs_command_hidden_lua:OnDestroy()
	if not IsServer() then return end
	local ability = self:GetAbility()
	local parent = self:GetParent()

	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	local position = parent:GetAbsOrigin()
	ability:MoveClone(parent, position, position)
	parent:RemoveNoDraw()
end


function modifier_monkey_king_wukongs_command_hidden_lua:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end
