modifier_cosmetic_skin_nightwing = class({})

function modifier_cosmetic_skin_nightwing:IsHidden() return true end
function modifier_cosmetic_skin_nightwing:IsDebuff() return false end
function modifier_cosmetic_skin_nightwing:IsPurgable() return false end
function modifier_cosmetic_skin_nightwing:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_cosmetic_skin_nightwing:GetStatusEffectName()
	return "particles/cosmetic/hero_skins/nightwing.vpcf"
end

-- function modifier_cosmetic_skin_nightwing:GetEffectName()
-- 	return "particles/cosmetic/hero_skins/nightwing_sparkles.vpcf"
-- end

-- function modifier_cosmetic_skin_nightwing:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end
