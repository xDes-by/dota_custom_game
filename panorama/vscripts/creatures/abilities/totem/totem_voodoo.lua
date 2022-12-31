LinkLuaModifier("modifier_totem_voodoo", "creatures/abilities/totem/totem_voodoo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_voodoo_buff", "creatures/abilities/totem/totem_voodoo", LUA_MODIFIER_MOTION_NONE)

totem_voodoo = class({})

function totem_voodoo:GetIntrinsicModifierName()
	return "modifier_totem_voodoo"
end



modifier_totem_voodoo = class({})

function modifier_totem_voodoo:IsHidden() return true end
function modifier_totem_voodoo:IsDebuff() return false end
function modifier_totem_voodoo:IsPurgable() return false end
function modifier_totem_voodoo:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_voodoo:OnCreated(keys)
	if not IsServer() then return end

	self:StartIntervalThink(0.7)
end

function modifier_totem_voodoo:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()

	local enemies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_totem_voodoo_buff") then

			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_totem_voodoo_buff", {})

			enemy:EmitSound("Totem.Beam")

			local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_purple.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(beam_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(beam_pfx)

			local hit_pfx = ParticleManager:CreateParticle("particles/totem/totem_hit_purple.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			return
		end
	end
end

function modifier_totem_voodoo:GetEffectName()
	return "particles/totem/voodoo.vpcf"
end

function modifier_totem_voodoo:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_voodoo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_voodoo:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_voodoo:GetOverrideAnimationRate()
	return 1
end





modifier_totem_voodoo_buff = class({})

function modifier_totem_voodoo_buff:IsHidden() return false end
function modifier_totem_voodoo_buff:IsDebuff() return true end
function modifier_totem_voodoo_buff:IsPurgable() return false end

function modifier_totem_voodoo_buff:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.armor_reduction = ability:GetSpecialValueFor("armor_reduction")

	if IsClient() then return end

	EventDriver:Listen("Spawner:all_creeps_killed", modifier_totem_voodoo_buff.OnAllCreepsKilled, self)
end

function modifier_totem_voodoo_buff:OnAllCreepsKilled(event)
	if event.team == self:GetParent():GetTeam() then
		self:Destroy()
	end
end

function modifier_totem_voodoo_buff:GetEffectName()
	return "particles/totem/voodoo_debuff.vpcf"
end

function modifier_totem_voodoo_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_voodoo_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE
	}
	return funcs
end

function modifier_totem_voodoo_buff:GetModifierPhysicalArmorBase_Percentage()
	return self.armor_reduction
end
