LinkLuaModifier("modifier_totem_flop", "creatures/abilities/totem/totem_flop", LUA_MODIFIER_MOTION_NONE)

totem_flop = class({})

function totem_flop:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
	end
	return true
end

function totem_flop:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	end
end

function totem_flop:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		
		caster:EmitSound("CreatureFlop.Cast")

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		for _, enemy in pairs(enemies) do
			if not enemy:FindAbilityByName("creature_flop") then
				enemy:AddAbility("creature_flop"):SetLevel(1)
			end
		end
	end
end

function totem_flop:GetIntrinsicModifierName()
	return "modifier_totem_flop"
end



modifier_totem_flop = class({})

function modifier_totem_flop:IsHidden() return true end
function modifier_totem_flop:IsDebuff() return false end
function modifier_totem_flop:IsPurgable() return false end
function modifier_totem_flop:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_flop:GetEffectName()
	return "particles/totem/flop.vpcf"
end

function modifier_totem_flop:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--function modifier_totem_flop:DeclareFunctions()
--	local funcs = {
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
--	}
--	return funcs
--end
--
--function modifier_totem_flop:GetOverrideAnimation()
--	return ACT_DOTA_IDLE
--end
--
--function modifier_totem_flop:GetOverrideAnimationRate()
--	return 1.0
--end
