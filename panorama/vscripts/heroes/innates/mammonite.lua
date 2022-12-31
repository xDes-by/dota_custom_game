innate_mammonite = class({})

LinkLuaModifier("modifier_innate_mammonite", "heroes/innates/mammonite", LUA_MODIFIER_MOTION_NONE)

function innate_mammonite:GetIntrinsicModifierName()
	return "modifier_innate_mammonite"
end

modifier_innate_mammonite = class({})

function modifier_innate_mammonite:IsHidden() return false end
function modifier_innate_mammonite:IsDebuff() return false end
function modifier_innate_mammonite:IsPurgable() return false end
function modifier_innate_mammonite:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_mammonite:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_innate_mammonite:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_innate_mammonite:GetModifierProcAttack_Feedback(keys)
	local particleName = "particles/custom/mammonite_small.vpcf"
	if self:GetStackCount() > 50 and self:GetStackCount() < 200 then
		particleName = "particles/custom/mammonite_medium.vpcf"
	elseif self:GetStackCount() >= 200 then
		particleName = "particles/custom/mammonite_large.vpcf"
	end
	
	local coin_pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(coin_pfx, 0, keys.target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(coin_pfx)
end

function modifier_innate_mammonite:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_innate_mammonite:OnIntervalThink()
	if IsClient() then return end
	self:SetStackCount(math.floor(self:GetParent():GetGold() / self:GetAbility():GetSpecialValueFor("gold_per_damage")))
end
