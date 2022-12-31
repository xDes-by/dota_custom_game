modifier_channel_listener = class({
	IsPurgable    = function() return false end,
	IsHidden      = function() return true end,
	RemoveOnDeath = function() return false end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end,
})

function modifier_channel_listener:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
	}
end

if not IsServer() then return end

function modifier_channel_listener:OnAbilityEndChannel(keys)
	local parent = self:GetParent()
	if keys.unit ~= parent then return end
	local endChannelListeners = parent.EndChannelListeners
	if not endChannelListeners then return end
	for _, v in ipairs(endChannelListeners) do
		v(keys.fail_type < 0)
	end
	parent.EndChannelListeners = {}
end