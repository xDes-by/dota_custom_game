LinkLuaModifier("modifier_totem_guardian_shell", "creatures/abilities/totem/totem_guardian_shell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_guardian_shell_buff", "creatures/abilities/totem/totem_guardian_shell", LUA_MODIFIER_MOTION_NONE)

totem_guardian_shell = class({})

function totem_guardian_shell:GetIntrinsicModifierName()
	return "modifier_totem_guardian_shell"
end



modifier_totem_guardian_shell = class({})

function modifier_totem_guardian_shell:IsHidden() return true end
function modifier_totem_guardian_shell:IsDebuff() return false end
function modifier_totem_guardian_shell:IsPurgable() return false end
function modifier_totem_guardian_shell:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_guardian_shell:OnCreated(keys)
	if not IsServer() then return end

	self.elapsed_think_time = 0
	self:StartIntervalThink(0.03)
end

function modifier_totem_guardian_shell:OnIntervalThink()
	if not IsServer() then return end

	self.elapsed_think_time = self.elapsed_think_time + 0.03

	local caster = self:GetParent()
	local angles = caster:GetAngles()
	caster:SetAngles(angles.x, angles.y + 2, angles.z)

	if self.elapsed_think_time >= 0.4 then

		self.elapsed_think_time = 0
		local caster_loc = caster:GetAbsOrigin()

		local allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			if not ally:HasModifier("modifier_totem_guardian_shell_buff") then

				ally:AddNewModifier(caster, self:GetAbility(), "modifier_totem_guardian_shell_buff", {})

				ally:EmitSound("Totem.Beam")

				local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_brown.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(beam_pfx, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(beam_pfx)

				local hit_pfx = ParticleManager:CreateParticle("particles/totem/totem_hit_brown.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
				ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				return
			end
		end
	end
end

function modifier_totem_guardian_shell:GetEffectName()
	return "particles/totem/guardian_shell.vpcf"
end

function modifier_totem_guardian_shell:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_guardian_shell:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true
	}
	return state
end





modifier_totem_guardian_shell_buff = class({})

function modifier_totem_guardian_shell_buff:IsHidden() return false end
function modifier_totem_guardian_shell_buff:IsDebuff() return false end
function modifier_totem_guardian_shell_buff:IsPurgable() return false end

function modifier_totem_guardian_shell_buff:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then self.magic_resist = 0 return end

	self.magic_resist = ability:GetSpecialValueFor("magic_resist")
end

function modifier_totem_guardian_shell_buff:CheckState()
	local state = {
		[MODIFIER_STATE_UNSLOWABLE] = true
	}
	return state
end

function modifier_totem_guardian_shell_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_totem_guardian_shell_buff:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end
