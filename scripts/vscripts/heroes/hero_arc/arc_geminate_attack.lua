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
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
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
		self:GetAbility():UseResources(true, true, true)
	end
end

function modifier_arc_geminate_attack:GetModifierProcAttack_Feedback(keys)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int_last") ~= nil then
		if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and RandomInt(1, 100) <= 5 then
			local enemy_projectile =
				{
					Target = keys.target,
					Source = keys.attacker,
					Ability = self:GetAbility(),
					EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = 700,
					flExpireTime = GameRules:GetGameTime() + 60,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				}
				

			ProjectileManager:CreateTrackingProjectile(enemy_projectile)
		end
	end
end

function arc_geminate_attack:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		self.abi = self:GetCaster():FindAbilityByName("ark_spark_lua")
		local caster = self:GetCaster()
		local damage = self.abi:GetSpecialValueFor("damage")	

		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi7") ~= nil then 
			damage = damage + caster:GetAgility()
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int10") ~= nil then 
			damage = damage + caster:GetIntellect()*0.75
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int11") ~= nil then
			damage = damage * 2
		end
	
		ApplyDamage({attacker = caster, victim = target, ability = self.abi, damage = damage, damage_type = self.abi:GetAbilityDamageType()})
		target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
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
		ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
	end
end