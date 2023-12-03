modifier_riki_cloak_and_dagger_lua	= modifier_riki_cloak_and_dagger_lua or class({})


function modifier_riki_cloak_and_dagger_lua:DestroyOnExpire()	return false end
function modifier_riki_cloak_and_dagger_lua:IsPurgable()		return false end
function modifier_riki_cloak_and_dagger_lua:RemoveOnDeath()	return false end

function modifier_riki_cloak_and_dagger_lua:IsHidden()			return true end

function modifier_riki_cloak_and_dagger_lua:OnCreated()
	self.parent = self:GetParent()
	if not IsServer() then return end
	self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("fade_delay"))
	self:SetDuration(self:GetAbility():GetSpecialValueFor("fade_delay"), true)
	self:StartIntervalThink(0.2)
end

function modifier_riki_cloak_and_dagger_lua:OnIntervalThink()
	if self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_riki_cloak_and_dagger_invisibility") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_riki_cloak_and_dagger_invisibility", {})
	elseif not self:GetAbility():IsFullyCastable() and self:GetParent():HasModifier("modifier_riki_cloak_and_dagger_invisibility") then
		self:GetParent():RemoveModifierByName("modifier_riki_cloak_and_dagger_invisibility")
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int12") or self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int13") then
		if self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_riki_cloak_and_dagger_invisibility_spell_amplify") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_riki_cloak_and_dagger_invisibility_spell_amplify", {})
		elseif not self:GetAbility():IsFullyCastable() and self:GetParent():HasModifier("modifier_riki_cloak_and_dagger_invisibility_spell_amplify") then
			self:GetParent():RemoveModifierByName("modifier_riki_cloak_and_dagger_invisibility_spell_amplify")
		end
	end
end

function modifier_riki_cloak_and_dagger_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end

function modifier_riki_cloak_and_dagger_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
		end
	end
end

function modifier_riki_cloak_and_dagger_lua:GetModifierPreAttack_BonusDamage(keys)
	if keys.attacker == self:GetParent() and keys.target then
		self.bBackstab = false
		if not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() and not keys.target:IsOther() and math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(self:GetParent():GetForwardVector()).y)) <= self:GetAbility():GetSpecialValueFor("backstab_angle") then
			self.bBackstab = true
		end
		if not self:GetParent():PassivesDisabled() and self:GetCaster():FindAbilityByName("npc_dota_hero_riki_str10") and keys.target:HasModifier("modifier_riki_smoke_screen_lua") then
			self.bBackstab = true
		end
		if not self:GetParent():PassivesDisabled() and self:GetCaster():HasModifier("modifier_riki_tricks_of_the_trade_lua") then
			self.bBackstab = true
		end
		if self.bBackstab then
			return self:CalculateDamage()
		end
	end
end

function modifier_riki_cloak_and_dagger_lua:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		if self.bBackstab then
			if self.parent:FindAbilityByName("npc_dota_hero_riki_str8") then
				self.parent:Heal( keys.damage * 0.4, self:GetAbility() )
				local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
				ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )
				ParticleManager:ReleaseParticleIndex( effect_cast )
			end
			keys.target:EmitSound("Hero_Riki.Backstab")
			
			self.backstab_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			ParticleManager:SetParticleControlEnt(self.backstab_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.backstab_particle)
		end
		self:GetAbility():StartCooldown(3.0)
	end
end

function modifier_riki_cloak_and_dagger_lua:CalculateDamage()
	local damage_multiplier = self:GetAbility():GetSpecialValueFor("damage_multiplier")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi8") then
		damage_multiplier = damage_multiplier * 1.5
	end
	local damage = self:GetParent():GetAgility() * self:GetAbility():GetSpecialValueFor("damage_multiplier")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_str7") then
		damage = damage + self:GetParent():GetStrength() * damage_multiplier * 0.5
	end
	return damage
end

modifier_riki_cloak_and_dagger_invisibility = class({})

function modifier_riki_cloak_and_dagger_invisibility:CheckState()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int10") then
		return {
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		}
	end
end

function modifier_riki_cloak_and_dagger_invisibility:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end

function modifier_riki_cloak_and_dagger_invisibility:GetModifierInvisibilityLevel()
	return 1
end
function modifier_riki_cloak_and_dagger_invisibility:GetModifierHealthRegenPercentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_str6") then
		return 5
	end
end

modifier_riki_cloak_and_dagger_invisibility_spell_amplify = class({})

function modifier_riki_cloak_and_dagger_invisibility_spell_amplify:OnCreated()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int13") then
			self:SetStackCount(self:GetCaster():GetSpellAmplification(false) * 100 * 2.5)
		elseif self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int12") then
			self:SetStackCount(self:GetCaster():GetSpellAmplification(false) * 100 * 6.0)
		end
	end	
end

function modifier_riki_cloak_and_dagger_invisibility_spell_amplify:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
	}
end

function modifier_riki_cloak_and_dagger_invisibility_spell_amplify:GetModifierInvisibilityLevel()
	return 1
end
function modifier_riki_cloak_and_dagger_invisibility_spell_amplify:GetModifierSpellAmplify_PercentageUnique()
	return self:GetStackCount()
end
