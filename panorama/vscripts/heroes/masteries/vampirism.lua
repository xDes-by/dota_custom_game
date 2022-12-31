modifier_chc_mastery_vampirism = class({})

function modifier_chc_mastery_vampirism:IsHidden() return true end
function modifier_chc_mastery_vampirism:IsDebuff() return false end
function modifier_chc_mastery_vampirism:IsPurgable() return false end
function modifier_chc_mastery_vampirism:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_vampirism:GetTexture() return "masteries/vampirism" end

function modifier_chc_mastery_vampirism:DeclareFunctions()
	if IsServer() then return {	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_chc_mastery_vampirism:GetModifierProcAttack_Feedback(keys)
	if keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.target:IsBuilding()) and keys.damage > 0 then

		if keys.target:IsOther() then return end

		local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

		keys.attacker:HealWithParams(keys.damage * (self.lifesteal or 0), nil, true, false, keys.attacker, false)
	end
end



modifier_chc_mastery_vampirism_1 = class(modifier_chc_mastery_vampirism)
modifier_chc_mastery_vampirism_2 = class(modifier_chc_mastery_vampirism)
modifier_chc_mastery_vampirism_3 = class(modifier_chc_mastery_vampirism)

function modifier_chc_mastery_vampirism_1:OnCreated(keys)
	self.lifesteal = 0.2
end

function modifier_chc_mastery_vampirism_2:OnCreated(keys)
	self.lifesteal = 0.4
end

function modifier_chc_mastery_vampirism_3:OnCreated(keys)
	self.lifesteal = 0.8
end
