innate_soul_link = class({})

LinkLuaModifier("modifier_innate_soul_link", "heroes/innates/soul_link", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_soul_link_buff", "heroes/innates/soul_link", LUA_MODIFIER_MOTION_NONE)

function innate_soul_link:GetIntrinsicModifierName()
	return "modifier_innate_soul_link"
end

modifier_innate_soul_link = class({})

function modifier_innate_soul_link:OnCreated(keys)
	self.player_id = self:GetParent():GetPlayerOwnerID()
end

function modifier_innate_soul_link:IsHidden() return true end
function modifier_innate_soul_link:IsDebuff() return false end
function modifier_innate_soul_link:IsPurgable() return false end
function modifier_innate_soul_link:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_soul_link:IsAura() return true end
function modifier_innate_soul_link:GetAuraRadius() return 1200 end
function modifier_innate_soul_link:GetModifierAura() return "modifier_innate_soul_link_buff" end
function modifier_innate_soul_link:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_innate_soul_link:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_OTHER end
function modifier_innate_soul_link:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end

function modifier_innate_soul_link:GetAuraEntityReject(unit)
	return self.player_id and self.player_id ~= unit:GetPlayerOwnerID()
end



modifier_innate_soul_link_buff = class({})

function modifier_innate_soul_link_buff:IsHidden() return false end
function modifier_innate_soul_link_buff:IsDebuff() return false end
function modifier_innate_soul_link_buff:IsPurgable() return false end
function modifier_innate_soul_link_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_soul_link_buff:OnCreated(keys)
	if IsClient() then return end

	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	if (not self.ability) or (not self.caster) or self.ability:IsNull() or self.caster:IsNull() then return end

	self.hero_lifesteal = 0.01 * (self.ability:GetLevelSpecialValueFor("hero_to_creep_lifesteal", 1) or 0)
	self.creep_lifesteal = 0.01 * (self.ability:GetLevelSpecialValueFor("creep_to_hero_lifesteal", 1) or 0)
end

function modifier_innate_soul_link_buff:DeclareFunctions()
	if IsServer() then return { MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_innate_soul_link_buff:GetModifierProcAttack_Feedback(keys)
	if keys.target:GetTeam() == keys.attacker:GetTeam() or keys.target:IsBuilding() or keys.target:IsOther() then return end

	if (not self.ability) or (not self.caster) or self.ability:IsNull() or self.caster:IsNull() then return end

	-- Hero is attacking
	if keys.attacker == self.caster then
		local heal_amount = keys.damage * self.hero_lifesteal
		local summons = FindUnitsInRadius(
			keys.attacker:GetTeam(),
			keys.target:GetAbsOrigin(),
			nil,
			1200,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_OTHER,
			DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
			FIND_ANY_ORDER,
			false)

		for _, summon in pairs(summons) do
			if summon:HasModifier("modifier_innate_soul_link_buff") and summon ~= self.caster then
				summon:Heal(heal_amount, self.ability)

				local lifesteal_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, summon)
				ParticleManager:SetParticleControl(lifesteal_pfx, 1, self.caster:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
			end
		end

	-- Summon is attacking
	else
		self.caster:Heal(keys.damage * self.creep_lifesteal, self.ability)

		local lifesteal_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(lifesteal_pfx, 1, keys.attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
	end
end
