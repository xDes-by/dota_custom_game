LinkLuaModifier("modifier_totem_degenerator", "creatures/abilities/totem/totem_degenerator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_totem_degenerator_buff", "creatures/abilities/totem/totem_degenerator", LUA_MODIFIER_MOTION_NONE)

totem_degenerator = class({})

function totem_degenerator:GetIntrinsicModifierName()
	return "modifier_totem_degenerator"
end



modifier_totem_degenerator = class({})

function modifier_totem_degenerator:IsHidden() return true end
function modifier_totem_degenerator:IsDebuff() return false end
function modifier_totem_degenerator:IsPurgable() return false end
function modifier_totem_degenerator:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_degenerator:OnCreated(keys)
	if not IsServer() then return end

	self:StartIntervalThink(0.7)
end

function modifier_totem_degenerator:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()

	local enemies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_totem_degenerator_buff") then

			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_totem_degenerator_buff", {})

			enemy:EmitSound("Totem.Beam")

			local beam_pfx = ParticleManager:CreateParticle("particles/totem/totem_cast_beam_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(beam_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(beam_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(beam_pfx)

			local hit_pfx = ParticleManager:CreateParticle("particles/totem/totem_hit_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			return
		end
	end
end

function modifier_totem_degenerator:GetEffectName()
	return "particles/totem/degenerator.vpcf"
end

function modifier_totem_degenerator:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_degenerator:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true
	}
	return state
end

function modifier_totem_degenerator:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_totem_degenerator:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_totem_degenerator:GetOverrideAnimationRate()
	return 1.5
end





modifier_totem_degenerator_buff = class({})

function modifier_totem_degenerator_buff:IsHidden() return false end
function modifier_totem_degenerator_buff:IsDebuff() return true end
function modifier_totem_degenerator_buff:IsPurgable() return false end

function modifier_totem_degenerator_buff:GetEffectName()
	return "particles/totem/degenerator_debuff.vpcf"
end

function modifier_totem_degenerator_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_totem_degenerator_buff:OnCreated(keys)
	if IsClient() then return end
	
	self:SetStackCount(math.floor(self:GetAbility():GetSpecialValueFor("stats_per_round") * RoundManager:GetCurrentRoundNumber()))

	EventDriver:Listen("Spawner:all_creeps_killed", modifier_totem_degenerator_buff.OnAllCreepsKilled, self)
end

function modifier_totem_degenerator_buff:OnAllCreepsKilled(event)
	if event.team == self:GetParent():GetTeam() then
		self:Destroy()
	end
end

function modifier_totem_degenerator_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_totem_degenerator_buff:GetModifierBonusStats_Strength()
	return (-1) * self:GetStackCount()
end

function modifier_totem_degenerator_buff:GetModifierBonusStats_Agility()
	return (-1) * self:GetStackCount()
end

function modifier_totem_degenerator_buff:GetModifierBonusStats_Intellect()
	return (-1) * self:GetStackCount()
end
