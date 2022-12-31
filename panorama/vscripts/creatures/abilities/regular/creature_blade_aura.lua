LinkLuaModifier("modifier_creature_blade_aura", "creatures/abilities/regular/creature_blade_aura", LUA_MODIFIER_MOTION_NONE)

creature_blade_aura = class({})

function creature_blade_aura:GetIntrinsicModifierName()
	return "modifier_creature_blade_aura"
end



modifier_creature_blade_aura = class({})

function modifier_creature_blade_aura:IsHidden() return true end
function modifier_creature_blade_aura:IsDebuff() return false end
function modifier_creature_blade_aura:IsPurgable() return false end
function modifier_creature_blade_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_blade_aura:GetEffectName()
	return "particles/creature/blade_aura.vpcf"
end

function modifier_creature_blade_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_blade_aura:OnCreated()
	self.return_pct = 0.01 * self:GetAbility():GetSpecialValueFor("return_pct")
end

function modifier_creature_blade_aura:DeclareFunctions()
	if IsServer() then return { MODIFIER_EVENT_ON_ATTACK_LANDED } end
end

function modifier_creature_blade_aura:OnAttackLanded(keys)
	if keys.target == self:GetParent() then
		if keys.target and keys.attacker and not (keys.target:IsNull() or keys.attacker:IsNull()) then
			ApplyDamage({victim = keys.attacker, attacker = keys.target, damage = keys.original_damage * self.return_pct, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end
