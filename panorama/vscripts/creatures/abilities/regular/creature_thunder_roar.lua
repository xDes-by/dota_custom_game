LinkLuaModifier("modifier_creature_thunder_roar", "creatures/abilities/regular/creature_thunder_roar", LUA_MODIFIER_MOTION_NONE)

creature_thunder_roar = class({})

function creature_thunder_roar:GetIntrinsicModifierName()
	return "modifier_creature_thunder_roar"
end



modifier_creature_thunder_roar = class({})

function modifier_creature_thunder_roar:IsHidden() return true end
function modifier_creature_thunder_roar:IsDebuff() return false end
function modifier_creature_thunder_roar:IsPurgable() return false end
function modifier_creature_thunder_roar:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_thunder_roar:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
		}
		return funcs
	end

	function modifier_creature_thunder_roar:GetModifierIncomingDamage_Percentage(keys)
		local ability = self:GetAbility()
		if not ability or not ability:IsCooldownReady() then return end

		ability:UseResources(false, false, true)

		local target_loc = keys.attacker:GetAbsOrigin()
		keys.target:EmitSound("CreatureThunderRoar.Proc")

		local zap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(zap_pfx, 0, target_loc + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(zap_pfx, 1, target_loc)
		ParticleManager:ReleaseParticleIndex(zap_pfx)

		if (not keys.attacker:IsMagicImmune()) then
			local actual_damage = ApplyDamage({
				victim = keys.attacker, 
				attacker = keys.target, 
				damage = ability:GetSpecialValueFor("damage"), 
				damage_type = DAMAGE_TYPE_MAGICAL
			})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.attacker, actual_damage, nil)
		end
	end
end
