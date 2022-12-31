LinkLuaModifier("modifier_totem_knight_vow", "creatures/abilities/totem/totem_knight_vow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_knight_vow_buff", "creatures/abilities/totem/totem_knight_vow", LUA_MODIFIER_MOTION_NONE)

totem_knight_vow = class({})

function totem_knight_vow:GetIntrinsicModifierName()
	return "modifier_totem_knight_vow"
end



modifier_totem_knight_vow = class({})

function modifier_totem_knight_vow:IsHidden() return true end
function modifier_totem_knight_vow:IsDebuff() return false end
function modifier_totem_knight_vow:IsPurgable() return false end
function modifier_totem_knight_vow:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_knight_vow:OnCreated(keys)
	if not IsServer() then return end

	self:StartIntervalThink(0.4)
end

function modifier_totem_knight_vow:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()

	local allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		if not ally:HasModifier("modifier_totem_knight_vow_buff") then

			ally:AddNewModifier(caster, self:GetAbility(), "modifier_totem_knight_vow_buff", {})

			ally:EmitSound("Totem.Beam")

			local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_knight_vow.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(beam_pfx, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(beam_pfx)

			local hit_pfx = ParticleManager:CreateParticle("particles/totem/knight_vow_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			return
		end
	end
end

function modifier_totem_knight_vow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_knight_vow:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_knight_vow:GetOverrideAnimationRate()
	return 1
end





modifier_totem_knight_vow_buff = class({})

function modifier_totem_knight_vow_buff:IsHidden() return false end
function modifier_totem_knight_vow_buff:IsDebuff() return false end
function modifier_totem_knight_vow_buff:IsPurgable() return false end

function modifier_totem_knight_vow_buff:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	self.armor = ability:GetSpecialValueFor("armor")
end

function modifier_totem_knight_vow_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_totem_knight_vow_buff:GetModifierPhysicalArmorBonus()
	return self.armor
end
