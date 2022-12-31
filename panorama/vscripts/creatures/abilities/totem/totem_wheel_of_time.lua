LinkLuaModifier("modifier_totem_wheel_of_time", "creatures/abilities/totem/totem_wheel_of_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_wheel_of_time_buff", "creatures/abilities/totem/totem_wheel_of_time", LUA_MODIFIER_MOTION_NONE)

totem_wheel_of_time = class({})

function totem_wheel_of_time:GetIntrinsicModifierName()
	return "modifier_totem_wheel_of_time"
end

function totem_wheel_of_time:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	self.current_stacks = 1 + (self.current_stacks or 0)

	-- Speed up model animation
	caster:FindModifierByName("modifier_totem_wheel_of_time"):IncrementStackCount()

	-- Pulse effect
	caster:EmitSound("TotemWheelOfTime.Pulse")

	local pulse_pfx = ParticleManager:CreateParticle("particles/totem/wheel_of_time_pulse.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pulse_pfx, 0, caster_loc + Vector(0, 0, 300))
	ParticleManager:ReleaseParticleIndex(pulse_pfx)

	local allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		local hit_pfx = ParticleManager:CreateParticle("particles/totem/wheel_of_time_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(hit_pfx)

		ally:AddNewModifier(caster, self, "modifier_totem_wheel_of_time_buff", {}):SetStackCount(self.current_stacks)
	end
end





modifier_totem_wheel_of_time = class({})

function modifier_totem_wheel_of_time:IsHidden() return true end
function modifier_totem_wheel_of_time:IsDebuff() return false end
function modifier_totem_wheel_of_time:IsPurgable() return false end
function modifier_totem_wheel_of_time:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_wheel_of_time:GetEffectName()
	return "particles/totem/wheel_of_time.vpcf"
end

function modifier_totem_wheel_of_time:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_wheel_of_time:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_wheel_of_time:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_wheel_of_time:GetOverrideAnimationRate()
	return 0.2 + math.floor(self:GetStackCount())
end





modifier_totem_wheel_of_time_buff = class({})

function modifier_totem_wheel_of_time_buff:IsHidden() return false end
function modifier_totem_wheel_of_time_buff:IsDebuff() return false end
function modifier_totem_wheel_of_time_buff:IsPurgable() return false end

function modifier_totem_wheel_of_time_buff:OnCreated(keys)
	self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")
end

function modifier_totem_wheel_of_time_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_totem_wheel_of_time_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * (self.as_bonus or 0)
end
