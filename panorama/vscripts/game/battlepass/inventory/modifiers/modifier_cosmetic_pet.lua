modifier_cosmetic_pet = class( {} )

function modifier_cosmetic_pet:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	}
end

if IsClient() then return end

DISTANCE_FOR_TELEPORT = 1200

function modifier_cosmetic_pet:OnCreated(data)
	self:StartIntervalThink(0.1)
end

function modifier_cosmetic_pet:OnIntervalThink()
	local parent = self:GetParent()
	local owner = parent:GetOwner()

	if not owner then return end

	if parent:GetRangeToUnit(owner) >= DISTANCE_FOR_TELEPORT then
		local new_pos = owner:GetAbsOrigin() 
		local offset = RotatePosition(Vector(0,0,0), QAngle(0, -30, 0), owner:GetForwardVector() * 128)
		new_pos = new_pos + offset

		parent:SetAbsOrigin(new_pos)
	end
	
	if parent:IsMoving() then
		parent:StartGesture(ACT_DOTA_RUN)
		parent:RemoveGesture(ACT_DOTA_IDLE)	
	else
		parent:StartGesture(ACT_DOTA_IDLE)
		parent:RemoveGesture(ACT_DOTA_RUN)
	end
end
