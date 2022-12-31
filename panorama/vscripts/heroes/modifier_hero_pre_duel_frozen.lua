modifier_hero_pre_duel_frozen = class({})

function modifier_hero_pre_duel_frozen:IsHidden() return true end
function modifier_hero_pre_duel_frozen:IsDebuff() return true end
function modifier_hero_pre_duel_frozen:IsPurgable() return false end
function modifier_hero_pre_duel_frozen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_hero_pre_duel_frozen:OnCreated(keys)
	if IsClient() then return end

	-- Duel entrance effect
	Timers:CreateTimer(0.1, function()
		if not self or self:IsNull() then return end
		if not self:GetParent() or self:GetParent():IsNull() then return end
		
		local parent_loc = self:GetParent():GetAbsOrigin()

		self.duel_ring_pfx = ParticleManager:CreateParticle("particles/custom/duel_start_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.duel_ring_pfx, 0, GetGroundPosition(parent_loc, nil))
		ParticleManager:SetParticleControl(self.duel_ring_pfx, 7, GetGroundPosition(parent_loc, nil))
	end)
end

function modifier_hero_pre_duel_frozen:OnDestroy()
	if IsClient() then return end

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_hero_pre_duel_mini_safety", {duration = 0.03})

	if self.duel_ring_pfx then
		ParticleManager:DestroyParticle(self.duel_ring_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.duel_ring_pfx)
	end
end

function modifier_hero_pre_duel_frozen:OnPvpStart(keys)
	self:Destroy()
end

function modifier_hero_pre_duel_frozen:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true
		}
		return state
	end
end
