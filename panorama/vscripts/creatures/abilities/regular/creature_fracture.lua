LinkLuaModifier("modifier_creature_fracture", "creatures/abilities/regular/creature_fracture", LUA_MODIFIER_MOTION_NONE)

creature_fracture = class({})

function creature_fracture:OnSpellStart()
	if IsServer() then
		self:GetCaster():EmitSound("CreatureFracture.Cast")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_creature_fracture", {duration = self:GetSpecialValueFor("duration")})
	end
end



modifier_creature_fracture = class({})

function modifier_creature_fracture:IsHidden() return false end
function modifier_creature_fracture:IsDebuff() return false end
function modifier_creature_fracture:IsPurgable() return false end
function modifier_creature_fracture:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_fracture:GetEffectName()
	return "particles/creature/fracture.vpcf"
end

function modifier_creature_fracture:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_fracture:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_creature_fracture:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("dmg_reduction")
end
