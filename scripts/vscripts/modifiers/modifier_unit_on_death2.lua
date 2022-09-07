if modifier_unit_on_death2 == nil then modifier_unit_on_death2 = class({}) end

function modifier_unit_on_death2:IsHidden()
	return true
end

function modifier_unit_on_death2:IsPurgable()
	return false
end

function modifier_unit_on_death2:OnCreated(kv)
	if not IsServer() then return end
end

function modifier_unit_on_death2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_unit_on_death2:OnDeath(event)
    if not IsServer() then return end
    local creep = event.unit
    if creep ~= self:GetParent() then return end
	if creep:HasModifier("modifier_health") or creep:HasModifier("modifier_skeleton_king_reincarnation_lane_creep") then return end

	Timers:CreateTimer(0.1, function()
		UTIL_Remove( creep )
	end)
end