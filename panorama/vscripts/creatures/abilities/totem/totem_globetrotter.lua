LinkLuaModifier("modifier_totem_globetrotter", "creatures/abilities/totem/totem_globetrotter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_globetrotter_buff", "creatures/abilities/totem/totem_globetrotter", LUA_MODIFIER_MOTION_NONE)

totem_globetrotter = class({})

function totem_globetrotter:GetIntrinsicModifierName()
	return "modifier_totem_globetrotter"
end



modifier_totem_globetrotter = class({})

function modifier_totem_globetrotter:IsHidden() return true end
function modifier_totem_globetrotter:IsDebuff() return false end
function modifier_totem_globetrotter:IsPurgable() return false end
function modifier_totem_globetrotter:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_globetrotter:OnCreated(keys)
	if not IsServer() then return end

	self:StartIntervalThink(0.2)
end

function modifier_totem_globetrotter:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()

	local allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		if not ally:HasModifier("modifier_totem_globetrotter_buff") then

			ally:AddNewModifier(caster, self:GetAbility(), "modifier_totem_globetrotter_buff", {})

			ally:EmitSound("Totem.Beam")

			local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_green.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(beam_pfx, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(beam_pfx)

			local hit_pfx = ParticleManager:CreateParticle("particles/totem/wheel_of_time_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			return
		end
	end
end

function modifier_totem_globetrotter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_globetrotter:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_globetrotter:GetOverrideAnimationRate()
	return 2
end





modifier_totem_globetrotter_buff = class({})

function modifier_totem_globetrotter_buff:IsHidden() return false end
function modifier_totem_globetrotter_buff:IsDebuff() return false end
function modifier_totem_globetrotter_buff:IsPurgable() return false end

function modifier_totem_globetrotter_buff:GetEffectName()
	return "particles/totem/gogok_of_swiftness_buff.vpcf"
end

function modifier_totem_globetrotter_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_totem_globetrotter_buff:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	self.ms_bonus = ability:GetSpecialValueFor("ms_bonus")
	self.as_bonus = ability:GetSpecialValueFor("as_bonus")

end

function modifier_totem_globetrotter_buff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_totem_globetrotter_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_totem_globetrotter_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_totem_globetrotter_buff:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus
end
