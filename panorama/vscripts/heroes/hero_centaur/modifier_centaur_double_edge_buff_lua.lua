modifier_centaur_double_edge_buff_lua = class({})

function modifier_centaur_double_edge_buff_lua:IsHidden() return false end
function modifier_centaur_double_edge_buff_lua:IsDebuff() return false end
function modifier_centaur_double_edge_buff_lua:IsPurgable() return true end

function modifier_centaur_double_edge_buff_lua:OnCreated()
	if not self:GetAbility() then return end
	
	self.shard_str_pct = 0.01 * (self:GetAbility():GetSpecialValueFor("shard_str_pct") or 0)
end

function modifier_centaur_double_edge_buff_lua:OnStackCountChanged(previous_stacks)
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	local caster = self:GetCaster()
	local current_stacks = self:GetStackCount()

	if current_stacks <= 0 then return end

	caster:CalculateStatBonus(false)

	local tens = math.floor(current_stacks / 10)
	local ones = current_stacks % 10

	self.pfx = ParticleManager:CreateParticle("particles/player_heroes/centaur_shard_buff_strength_custom.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(tens, ones, 0))
	ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_OVERHEAD_FOLLOW, nil, caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.pfx, 3, caster, PATTACH_OVERHEAD_FOLLOW, nil, caster:GetAbsOrigin(), true)
end

function modifier_centaur_double_edge_buff_lua:OnDestroy()
	if not IsServer() then return end
	self:SetStackCount(0)

	-- Destroy particles
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function modifier_centaur_double_edge_buff_lua:OnTooltip()
	return 100 * self.shard_str_pct * self:GetStackCount()
end

function modifier_centaur_double_edge_buff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_centaur_double_edge_buff_lua:GetModifierBonusStats_Strength()
	if self.lock then return 0 end

	self.lock = true
	local strength = self:GetParent():GetStrength()
	self.lock = false

	return self:GetStackCount() * strength * self.shard_str_pct
end
