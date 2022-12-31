modifier_tracker_dummy = class({})

function modifier_tracker_dummy:IsPurgable() return false end
function modifier_tracker_dummy:RemoveOnDeath() return false end

if not IsServer() then return end

function modifier_tracker_dummy:OnCreated()
	self.events = {}

	for event_name, value in pairs(ProgressTracker.dummy_events_names) do
		table.insert(self.events, value[1])

		self[value[2]] = function(self, params)
			ProgressTracker:EventTriggered(event_name, params)
		end
	end
end

function modifier_tracker_dummy:DeclareFunctions()
	if not self.events or #self.events == 0 then self:OnCreated() end
	return self.events
end


function modifier_tracker_dummy:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}
end
