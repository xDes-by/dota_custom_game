LinkLuaModifier("modifier_totem_nether", "creatures/abilities/totem/totem_nether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_nether_buff", "creatures/abilities/totem/totem_nether", LUA_MODIFIER_MOTION_NONE)

totem_nether = class({})

function totem_nether:GetIntrinsicModifierName()
	return "modifier_totem_nether"
end



modifier_totem_nether = class({})

function modifier_totem_nether:IsHidden() return true end
function modifier_totem_nether:IsDebuff() return false end
function modifier_totem_nether:IsPurgable() return false end
function modifier_totem_nether:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_nether:OnCreated(keys)
	if not IsServer() then return end

	self.elapsed_think_time = 0
	self:StartIntervalThink(0.03)
end

function modifier_totem_nether:OnIntervalThink()
	if not IsServer() then return end

	self.elapsed_think_time = self.elapsed_think_time + 0.03

	local caster = self:GetParent()
	local angles = caster:GetAngles()
	caster:SetAngles(angles.x, angles.y - 1, angles.z)

	if self.elapsed_think_time >= 0.4 then

		self.elapsed_think_time = 0
		local caster_loc = caster:GetAbsOrigin()

		local allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			if not ally:HasModifier("modifier_totem_nether_buff") then

				ally:AddNewModifier(caster, self:GetAbility(), "modifier_totem_nether_buff", {})

				ally:EmitSound("Totem.Beam")

				local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_nether.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(beam_pfx, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(beam_pfx)

				local hit_pfx = ParticleManager:CreateParticle("particles/totem/totem_hit_nether.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
				ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				return
			end
		end
	end
end

function modifier_totem_nether:GetEffectName()
	return "particles/totem/nether.vpcf"
end

function modifier_totem_nether:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_nether:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_nether:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_nether:GetOverrideAnimationRate()
	return 1.0
end

function modifier_totem_nether:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true
	}
	return state
end





modifier_totem_nether_buff = class({})

function modifier_totem_nether_buff:IsHidden() return false end
function modifier_totem_nether_buff:IsDebuff() return false end
function modifier_totem_nether_buff:IsPurgable() return false end

function modifier_totem_nether_buff:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor")
	self.magic_amp = ability:GetSpecialValueFor("magic_amp")
end

function modifier_totem_nether_buff:GetEffectName()
	return "particles/totem/nether_buff.vpcf"
end

function modifier_totem_nether_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_nether_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE
	}
	return funcs
end

function modifier_totem_nether_buff:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_totem_nether_buff:GetModifierMagicalResistanceDecrepifyUnique()
	return self.magic_amp
end
