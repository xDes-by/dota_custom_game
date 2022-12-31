modifier_enfos_creep_run = class({})

function modifier_enfos_creep_run:IsHidden() return true end
function modifier_enfos_creep_run:IsDebuff() return false end
function modifier_enfos_creep_run:IsPurgable() return false end
function modifier_enfos_creep_run:DestroyOnExpire() return false end

if IsClient() then return end

function modifier_enfos_creep_run:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_enfos_creep_run:OnIntervalThink()
	local parent = self:GetParent()

	if self:GetStackCount() < self:GetDuration() then
		if not parent:HasModifier("modifier_enfos_duel_creep_freeze") then
			self:IncrementStackCount()
		end
	else
		parent:MoveToPosition(parent.objective)
	end
end
