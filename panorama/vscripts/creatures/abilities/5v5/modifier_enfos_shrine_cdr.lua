modifier_enfos_shrine_cdr = class({})

function modifier_enfos_shrine_cdr:IsHidden() return true end
function modifier_enfos_shrine_cdr:IsDebuff() return false end
function modifier_enfos_shrine_cdr:IsPurgable() return false end

function modifier_enfos_shrine_cdr:GetEffectName()
	return "particles/5v5/custom/fountain_mana_regen.vpcf"
end

function modifier_enfos_shrine_cdr:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_enfos_shrine_cdr:OnCreated(keys)
	self.cooldown_reduction = 0.3 -- reduce cooldowns by this value
	self.cdr_delay = 0.1 -- with this delay
	
	if IsServer() then
		local parent = self:GetParent()

		self:StartIntervalThink(self.cdr_delay)
	end
end

function modifier_enfos_shrine_cdr:OnIntervalThink()
	local parent = self:GetParent()
	
	for i = 0, (DOTA_MAX_ABILITIES - 1) do --27 for 12 non-doubled skills (like, attribute shift)
		local ability = parent:GetAbilityByIndex(i)
		if ability and ability.GetCooldownTimeRemaining and ability:IsActivated() then
			ability:ReduceCooldown(self.cooldown_reduction)
		end
	end

	for i = 0, 16 do -- 0-8 inventory, 9-14 stash, 15 - tp scroll, 16 - neutral slot
		local item = parent:GetItemInSlot(i)
		if item and item.GetCooldownTimeRemaining then
			item:ReduceCooldown(self.cooldown_reduction)
		end
	end
end
