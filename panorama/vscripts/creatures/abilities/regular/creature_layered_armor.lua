LinkLuaModifier("modifier_creature_layered_armor", "creatures/abilities/regular/creature_layered_armor", LUA_MODIFIER_MOTION_NONE)

creature_layered_armor = class({})

function creature_layered_armor:GetIntrinsicModifierName()
	return "modifier_creature_layered_armor"
end



modifier_creature_layered_armor = class({})

function modifier_creature_layered_armor:IsHidden() return true end
function modifier_creature_layered_armor:IsDebuff() return false end
function modifier_creature_layered_armor:IsPurgable() return false end
function modifier_creature_layered_armor:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_layered_armor:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ATTACK_LANDED
		}
		return funcs
	end

	function modifier_creature_layered_armor:OnAttackLanded(keys)
		if keys.target == self:GetParent() then
			local return_pfx = ParticleManager:CreateParticle("particles/creature/layered_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			ParticleManager:SetParticleControlEnt(return_pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetOrigin(), true)
			ParticleManager:SetParticleControlEnt(return_pfx, 1, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetOrigin(), true)
			ParticleManager:ReleaseParticleIndex(return_pfx)

			ApplyDamage({victim = keys.attacker, attacker = keys.target, damage = self:GetAbility():GetSpecialValueFor("return_damage"), damage_type = DAMAGE_TYPE_PHYSICAL, DAMAGE_FLAGS = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
		end
	end
end
