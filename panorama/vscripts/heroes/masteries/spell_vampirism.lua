modifier_chc_mastery_spell_vampirism = class({})

function modifier_chc_mastery_spell_vampirism:IsHidden() return true end
function modifier_chc_mastery_spell_vampirism:IsDebuff() return false end
function modifier_chc_mastery_spell_vampirism:IsPurgable() return false end
function modifier_chc_mastery_spell_vampirism:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_spell_vampirism:GetTexture() return "masteries/spell_vampirism" end

function modifier_chc_mastery_spell_vampirism:DeclareFunctions()
	if IsServer() then return {	MODIFIER_EVENT_ON_TAKEDAMAGE } end
end

function modifier_chc_mastery_spell_vampirism:OnTakeDamage(keys)
	if keys.attacker and self:GetParent() == keys.attacker and keys.unit and keys.inflictor and not (keys.attacker:IsNull() or keys.unit:IsNull() or keys.inflictor:IsNull() or keys.unit:IsBuilding()) and keys.damage > 0 then 
		if keys.damage_flags and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		if keys.damage_flags and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then return end

		local lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

		keys.attacker:Heal(keys.damage * self.lifesteal * ((keys.unit:IsHero() and 1) or 0.5), keys.inflictor)
	end
end



modifier_chc_mastery_spell_vampirism_1 = class(modifier_chc_mastery_spell_vampirism)
modifier_chc_mastery_spell_vampirism_2 = class(modifier_chc_mastery_spell_vampirism)
modifier_chc_mastery_spell_vampirism_3 = class(modifier_chc_mastery_spell_vampirism)

function modifier_chc_mastery_spell_vampirism_1:OnCreated(keys)
	self.lifesteal = 0.05
end

function modifier_chc_mastery_spell_vampirism_2:OnCreated(keys)
	self.lifesteal = 0.1
end

function modifier_chc_mastery_spell_vampirism_3:OnCreated(keys)
	self.lifesteal = 0.2
end
