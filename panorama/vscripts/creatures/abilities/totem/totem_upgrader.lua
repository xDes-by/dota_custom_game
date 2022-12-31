LinkLuaModifier("modifier_totem_upgrader", "creatures/abilities/totem/totem_upgrader", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_upgrader_buff", "creatures/abilities/totem/totem_upgrader", LUA_MODIFIER_MOTION_NONE)

totem_upgrader = class({})

function totem_upgrader:GetIntrinsicModifierName()
	return "modifier_totem_upgrader"
end



modifier_totem_upgrader = class({})

function modifier_totem_upgrader:IsHidden() return true end
function modifier_totem_upgrader:IsDebuff() return false end
function modifier_totem_upgrader:IsPurgable() return false end
function modifier_totem_upgrader:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_upgrader:OnCreated(keys)
	if not IsServer() then return end

	self:StartIntervalThink(0.4)
end

function modifier_totem_upgrader:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()

	local allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		if not ally:HasModifier("modifier_totem_upgrader_buff") then

			ally:AddNewModifier(caster, self:GetAbility(), "modifier_totem_upgrader_buff", {})

			ally:EmitSound("Totem.Beam")

			local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(beam_pfx, 0, ally, PATTACH_POINT_FOLLOW, "attach_hitloc", ally:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(beam_pfx)

			local hit_pfx = ParticleManager:CreateParticle("particles/totem/totem_hit_blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			return
		end
	end
end

function modifier_totem_upgrader:GetEffectName()
	return "particles/totem/upgrader.vpcf"
end

function modifier_totem_upgrader:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_upgrader:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_upgrader:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_upgrader:GetOverrideAnimationRate()
	return 1.5
end





modifier_totem_upgrader_buff = class({})

function modifier_totem_upgrader_buff:IsHidden() return false end
function modifier_totem_upgrader_buff:IsDebuff() return false end
function modifier_totem_upgrader_buff:IsPurgable() return false end

function modifier_totem_upgrader_buff:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		local max_health = parent:GetMaxHealth()

		parent:SetBaseMaxHealth(max_health * 1.15)
		parent:SetMaxHealth(max_health * 1.15)
		
		if parent:IsAlive() then
			parent:SetHealth( math.max(1, parent:GetHealth() * 1.15) )
		end
	end

	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.hp_bonus = ability:GetSpecialValueFor("hp_bonus")
	self.status_resist_bonus = ability:GetSpecialValueFor("status_resist_bonus")
end

function modifier_totem_upgrader_buff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local max_health = parent:GetMaxHealth()

		if parent:IsAlive() then
			parent:SetHealth( math.max(1, parent:GetHealth() / 1.15) )
		end

		parent:SetBaseMaxHealth(max_health / 1.15)
		parent:SetMaxHealth(max_health / 1.15)
	end
end

function modifier_totem_upgrader_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_totem_upgrader_buff:OnTooltip()
	return self.hp_bonus
end

function modifier_totem_upgrader_buff:GetModifierStatusResistanceStacking()
	return self.status_resist_bonus
end
