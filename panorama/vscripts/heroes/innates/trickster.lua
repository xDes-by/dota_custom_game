innate_trickster = class({})

LinkLuaModifier("modifier_innate_trickster", "heroes/innates/trickster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_trickster_particle", "heroes/innates/trickster", LUA_MODIFIER_MOTION_NONE)

function innate_trickster:GetIntrinsicModifierName()
	return "modifier_innate_trickster"
end





modifier_innate_trickster = class({})

function modifier_innate_trickster:IsHidden() return self:GetStackCount() == 0 end
function modifier_innate_trickster:IsDebuff() return false end
function modifier_innate_trickster:IsPurgable() return false end
function modifier_innate_trickster:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_trickster:OnCreated(keys)
	self:OnRefresh(keys)

	if IsClient() then return end

	if RoundManager:IsRoundStarted() then 
		self:OnRoundStart()
	end
end

function modifier_innate_trickster:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.stack_ms = ability:GetLevelSpecialValueFor("stack_ms", 1)
	self.stack_as = ability:GetLevelSpecialValueFor("stack_as", 1)
	self.stack_evasion = ability:GetLevelSpecialValueFor("stack_evasion", 1)
	self.stack_time = ability:GetLevelSpecialValueFor("stack_time", 1)
	self.max_stacks = ability:GetLevelSpecialValueFor("max_stacks", 1)
end

function modifier_innate_trickster:OnRoundStart(keys)
	if IsClient() then return end

	self:SetStackCount(0)
	self:OnIntervalThink()
	self:StartIntervalThink(self.stack_time)
end

function modifier_innate_trickster:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_trickster:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end

function modifier_innate_trickster:OnIntervalThink()
	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()
	end

	if self:GetStackCount() == self.max_stacks then
		self:SetStackCount(3 * self.max_stacks)
		self:StartIntervalThink(-1)

		local parent = self:GetParent()
		if (not parent) or parent:IsNull() then return end

		parent:EmitSound("Trickster.Proc")
		parent:EmitSound("Trickster.Buff")
		parent:AddNewModifier(parent, nil, "modifier_innate_trickster_particle", {})
	end
end

function modifier_innate_trickster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_innate_trickster:GetModifierMoveSpeedBonus_Constant()
	return self.stack_ms * self:GetStackCount()
end

function modifier_innate_trickster:GetModifierAttackSpeedBonus_Constant()
	return self.stack_as * self:GetStackCount()
end

function modifier_innate_trickster:GetModifierEvasion_Constant()
	return self.stack_evasion * self:GetStackCount()
end

function modifier_innate_trickster:GetModifierIgnoreMovespeedLimit()
	return 1
end



modifier_innate_trickster_particle = class({})

function modifier_innate_trickster_particle:IsHidden() return true end
function modifier_innate_trickster_particle:IsDebuff() return false end
function modifier_innate_trickster_particle:IsPurgable() return false end
function modifier_innate_trickster_particle:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_trickster_particle:GetEffectName()
	return "particles/custom/innates/trickster_buff.vpcf"
end

function modifier_innate_trickster_particle:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_innate_trickster_particle:OnCreated(keys)
	local max_effect_pfx = ParticleManager:CreateParticle("particles/custom/innates/trickster_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(max_effect_pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

	self:AddParticle(max_effect_pfx, false, false, -1, true, false)
end

function modifier_innate_trickster_particle:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_trickster_particle:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:Destroy()
end
