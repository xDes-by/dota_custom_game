LinkLuaModifier("modifier_creature_poison_sting", "creatures/abilities/regular/creature_poison_sting", LUA_MODIFIER_MOTION_NONE)

creature_poison_sting = class({})

function creature_poison_sting:GetIntrinsicModifierName()
	return "modifier_creature_poison_sting"
end



modifier_creature_poison_sting = class({})

function modifier_creature_poison_sting:OnCreated()
	if IsClient() then return end

	self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_creature_poison_sting:IsHidden() return true end
function modifier_creature_poison_sting:IsDebuff() return false end
function modifier_creature_poison_sting:IsPurgable() return false end
function modifier_creature_poison_sting:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_poison_sting:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
		return funcs
	end

	function modifier_creature_poison_sting:GetModifierProcAttack_Feedback(keys)
		if keys.target:IsMagicImmune() then return end

		local actual_damage = ApplyDamage({
			victim = keys.target, 
			attacker = keys.attacker, 
			damage = self.damage, 
			damage_type = DAMAGE_TYPE_MAGICAL
		})
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, keys.target, actual_damage, nil)
	end
end
