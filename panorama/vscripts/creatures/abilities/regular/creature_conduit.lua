LinkLuaModifier("modifier_creature_conduit", "creatures/abilities/regular/creature_conduit", LUA_MODIFIER_MOTION_NONE)

creature_conduit = class({})

function creature_conduit:GetIntrinsicModifierName()
	return "modifier_creature_conduit"
end



modifier_creature_conduit = class({})

function modifier_creature_conduit:IsHidden() return true end
function modifier_creature_conduit:IsDebuff() return false end
function modifier_creature_conduit:IsPurgable() return false end
function modifier_creature_conduit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_conduit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE  
	}
	return funcs
end

function modifier_creature_conduit:GetAbsoluteNoDamageMagical()
	return 1
end
if IsServer() then
	function modifier_creature_conduit:GetModifierIncomingDamage_Percentage(keys)
		if keys.damage_type == DAMAGE_TYPE_MAGICAL and self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(false, false, true)

			keys.target:EmitSound("CreatureConduit.Proc")

			local zap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(zap_pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			ParticleManager:SetParticleControl(zap_pfx, 1, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(zap_pfx)

			local return_damage = math.min(keys.original_damage, self:GetAbility():GetSpecialValueFor("max_damage"))

			if not keys.attacker:IsMagicImmune() then
				local actual_damage = ApplyDamage({
					victim = keys.attacker, 
					attacker = keys.target, 
					damage = return_damage, 
					damage_type = DAMAGE_TYPE_MAGICAL, 
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION
				})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.attacker, actual_damage, nil)
			end
		end
	end
end
