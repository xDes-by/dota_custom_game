LinkLuaModifier("modifier_arc_geminate_attack", "heroes/hero_arc/arc_geminate_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_geminate_attack_delay", "heroes/hero_arc/arc_geminate_attack", LUA_MODIFIER_MOTION_NONE)

arc_geminate_attack = class({})

function arc_geminate_attack:GetIntrinsicModifierName()
	return "modifier_arc_geminate_attack"
end

function arc_geminate_attack:OnAbilityPhaseStart()
	return false
end

function arc_geminate_attack:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi_last") ~= nil then
		return self.BaseClass.GetCooldown(self, level) - 0.3
	end
	return self.BaseClass.GetCooldown(self, level)
end

------------------------------------------------------------------------------

modifier_arc_geminate_attack = class({})

function modifier_arc_geminate_attack:IsHidden()
	return true
end

function modifier_arc_geminate_attack:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end

function modifier_arc_geminate_attack:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility():IsFullyCastable() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown and keys.target:GetUnitName() ~= "npc_dota_observer_wards" and keys.target:GetUnitName() ~= "npc_dota_sentry_wards" then
	local how_much = self:GetAbility():GetSpecialValueFor("tooltip_attack")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi9") ~= nil then 
		how_much = how_much + 1
	end
	
		for geminate_attacks = 1, how_much do
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_geminate_attack_delay", {delay = self:GetAbility():GetSpecialValueFor("delay") * geminate_attacks})
		end	
		self:GetAbility():UseResources(true, false, true, true)
	end
end

-----------------------------------------------------------------------------------------------

modifier_arc_geminate_attack_delay	= class({}) 

function modifier_arc_geminate_attack_delay:IsHidden() return true end
function modifier_arc_geminate_attack_delay:IsPurgable() return false end
function modifier_arc_geminate_attack_delay:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_arc_geminate_attack_delay:OnCreated(params)
	if not IsServer() then return end
	
		local enemy_projectile2 =
		{
			Target = self:GetParent(),
			Source = self:GetCaster(),
			Ability = self:GetAbility(),
			EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_base_attack.vpcf",
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = 900,
			flExpireTime = GameRules:GetGameTime() + 60,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		}
				

	ProjectileManager:CreateTrackingProjectile(enemy_projectile2)
end

function arc_geminate_attack:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		mult = self:GetSpecialValueFor("bonus_damage")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi7") ~= nil then 
			mult = mult + 25
		end
		local damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*0.01*mult
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_arc_warden_agi50") ~= nil then
			damage = damage * (self:GetCaster():GetSpellAmplification(false) * 0.05 + 1)
		end
		ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
	end
end