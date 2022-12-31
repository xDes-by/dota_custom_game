LinkLuaModifier("modifier_creature_ancient", "creatures/abilities/regular/creature_ancient", LUA_MODIFIER_MOTION_NONE)

creature_ancient = class({})

function creature_ancient:GetIntrinsicModifierName()
	return "modifier_creature_ancient"
end

modifier_creature_ancient = class({})

function modifier_creature_ancient:IsHidden() return true end
function modifier_creature_ancient:IsDebuff() return false end
function modifier_creature_ancient:IsPurgable() return false end
function modifier_creature_ancient:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_ancient:GetEffectName()
	return "particles/creature/ancient_buff.vpcf"
end

function modifier_creature_ancient:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_creature_ancient:ShouldUseOverheadOffset()
	return true
end
