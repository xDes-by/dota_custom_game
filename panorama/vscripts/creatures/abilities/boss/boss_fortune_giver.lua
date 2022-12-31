boss_fortune_giver = class({})
LinkLuaModifier("modifier_boss_fortune_giver", "creatures/abilities/boss/boss_fortune_giver", LUA_MODIFIER_MOTION_NONE)


function boss_fortune_giver:GetIntrinsicModifierName()
	return "modifier_boss_fortune_giver"
end


modifier_boss_fortune_giver = class({})

function modifier_boss_fortune_giver:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()

	self.max_hits = self:GetAbility():GetSpecialValueFor("hits")
	self.current_hits = self.max_hits
	self.attacker_exceptions = {
		npc_dota_unit_tombstone1 = true,
		npc_dota_unit_tombstone2 = true,
		npc_dota_unit_tombstone3 = true,
		npc_dota_unit_tombstone4 = true,
	}
end

function modifier_boss_fortune_giver:GetStatusEffectName()
	return "particles/custom/status_effect_fortune_boss.vpcf"
end

function modifier_boss_fortune_giver:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end

function modifier_boss_fortune_giver:GetAbsoluteNoDamagePhysical()
	return 1
end


function modifier_boss_fortune_giver:GetAbsoluteNoDamageMagical()
	return 1
end


function modifier_boss_fortune_giver:GetAbsoluteNoDamagePure()
	return 1
end


function modifier_boss_fortune_giver:GetDisableHealing()
	return 1
end


function modifier_boss_fortune_giver:GetModifierAvoidDamage(keys)
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and not self.attacker_exceptions[keys.attacker:GetUnitName()] then return end
	self.current_hits = self.current_hits - 1

	if self.current_hits == 0 then
		self.parent:Kill(nil, keys.attacker)
	else
		self.parent:SetHealth(self.parent:GetMaxHealth() * self.current_hits / self.max_hits)
	end

	if self.parent and (not self.parent:IsNull()) then
		self.parent:EmitSound("BossFortune.Crack")
		local bet_pfx = ParticleManager:CreateParticle("particles/custom/fortune_shower.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(bet_pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(bet_pfx)
	end

	return 0
end
