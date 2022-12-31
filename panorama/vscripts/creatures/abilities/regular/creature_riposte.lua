LinkLuaModifier("modifier_creature_riposte", "creatures/abilities/regular/creature_riposte", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_riposte_animation", "creatures/abilities/regular/creature_riposte", LUA_MODIFIER_MOTION_NONE)

creature_riposte = class({})

function creature_riposte:GetIntrinsicModifierName()
	return "modifier_creature_riposte"
end



modifier_creature_riposte = class({})

function modifier_creature_riposte:IsHidden() return true end
function modifier_creature_riposte:IsDebuff() return false end
function modifier_creature_riposte:IsPurgable() return false end
function modifier_creature_riposte:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_riposte:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_EVASION_CONSTANT 
	}
	return funcs
end

function modifier_creature_riposte:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("evasion")
end

function modifier_creature_riposte:OnAttackFail(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			local damage = 0.5 * (keys.target:GetBaseDamageMin() + keys.target:GetBaseDamageMax())

			keys.target:AddNewModifier(keys.target, self:GetAbility(), "modifier_creature_riposte_animation", {duration = 0.9})

			keys.attacker:EmitSound("Riposte.Slash")
			keys.target:EmitSound("Riposte.Counter")

			local riposte_pfx = ParticleManager:CreateParticle("particles/creature/riposte_animation.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			ParticleManager:SetParticleControl(riposte_pfx, 0, keys.target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(riposte_pfx)

			local slash_pfx = ParticleManager:CreateParticle("particles/creature/riposte.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(slash_pfx, 3, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(slash_pfx)

			ApplyDamage({victim = keys.attacker, attacker = keys.target, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end



modifier_creature_riposte_animation = class({})

function modifier_creature_riposte_animation:IsHidden() return true end
function modifier_creature_riposte_animation:IsDebuff() return false end
function modifier_creature_riposte_animation:IsPurgable() return false end

function modifier_creature_riposte_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE 
	}
	return funcs
end

function modifier_creature_riposte_animation:GetOverrideAnimation()
	return ACT_DOTA_ATTACK
end

function modifier_creature_riposte_animation:GetOverrideAnimationRate()
	return 4.0
end
