modifier_empower_buff = {}

function modifier_empower_buff:IsHidden()
	return false
end

function modifier_empower_buff:IsDebuff()
	return false
end

function modifier_empower_buff:IsPurgable()
	return true
end

function modifier_empower_buff:OnCreated( kv )
	---------------------- init data
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" )
	self.mult = self:GetAbility():GetSpecialValueFor( "self_multiplier" )
	self.attack_count = self:GetAbility():GetSpecialValueFor( "attack_count" )
	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )
	----------------------- str
	self.str6 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_str6")
	self.str7 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_str7")
	self.str8 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_str8")
	self.str12 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_str_last")
	----------------------- agi
	self.agi9 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_agi9")
	self.agi10 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_agi10")
	self.agi11 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_agi11")
	self.agi12 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_agi_last")
	----------------------- int
	self.int7 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_int7")
	self.int12 = self.caster:FindAbilityByName("npc_dota_hero_magnataur_int_last")
	

	if self.parent==self.caster then
		self.damage = self.damage*self.mult
		self.cleave = self.cleave*self.mult
		self.attack_count = self.attack_count*self.mult
	end
	if self.agi10 ~= nil then
		local multiplier = self.agi10:GetSpecialValueFor("multiplier")
		self.damage = self.damage*multiplier
		self.cleave = self.cleave*multiplier
	end

	if self.agi9 == nil then 
		self:SetStackCount(self.attack_count)
	end

	if self.int7 ~= nil then
		
		local units = FindUnitsInRadius(self.caster:GetTeam(), 
		self.parent:GetOrigin(), 
		nil, 
		675,
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
		FIND_ANY_ORDER, 
		false)
		local damage = self.int7:GetSpecialValueFor("damage_per_level") * self.ability:GetLevel()
		for __,v in pairs(units) do 

			ApplyDamage({
				victim = v,
				attacker = self.caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self.ability,
			})

		end
		self:PlayEffect()
	end
	if self.str12 ~= nil then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_talent_str12", {
			duration = 3
		})
	end
end

-- modifier_empower_buff.OnRefresh = modifier_empower_buff.OnCreated

function modifier_empower_buff:OnRefresh(table)
	if table.existing_duration ~= nil then
		self:OnCreated(table)
	end
end

function modifier_empower_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
	}
end

function modifier_empower_buff:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker:GetAttackCapability()==DOTA_UNIT_CAP_MELEE_ATTACK then 
		local damage = params.damage*(self.cleave/100)
		local effect = "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf"
		DoCleaveAttack(
			params.attacker,
			params.target,
			self.ability,
			damage,
			self.radius_start,
			self.radius_end,
			self.radius_dist,
			effect
		)
	end
end

function modifier_empower_buff:OnAttackLanded( params )
	local attacker = params.attacker
	if attacker ~= self:GetParent() then return end
	if self.str8 ~= nil then
		local heal_amount = params.damage * self.str8:GetSpecialValueFor("vampirism") / 100
		self.parent:Heal(heal_amount, self.ability)
		local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end
	if self.agi9 == nil then 
		self:DecrementStackCount()
		if self:GetStackCount() < 1 then self:Destroy() end
	end
	
end

function modifier_empower_buff:GetModifierDamageOutgoing_Percentage()
	if self.agi12 ~= nil then
		return self.damage * self.agi12:GetSpecialValueFor("multiplier")
	else
		return 0
	end
end

function modifier_empower_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage
end

function modifier_empower_buff:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end

function modifier_empower_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_empower_buff:PlayEffect()
	local nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControlEnt(nfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(nfx)
end

--------------------------------------------------------------------------------
------ Talent Bonuses ----------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_empower_buff:GetModifierMagicalResistanceBonus()
	if self.str6 ~= nil then 
		return 30
	end
	return 0
end

function modifier_empower_buff:GetModifierExtraHealthPercentage()
	if self.str7 ~= nil then
		return self.str7:GetSpecialValueFor("extra_health_perc")
	end
	return 0
end

function modifier_empower_buff:GetModifierBaseAttack_BonusDamage()
	if self.agi11 ~= nil and self.parent:IsRealHero() then
		return self.parent:GetAgility() * self.agi11:GetSpecialValueFor("multiplier")
	else
		return 0
	end
end

function modifier_empower_buff:GetModifierBonusStats_Intellect()
	if self.int12 ~= nil and self.parent:IsRealHero() then
		-- return self.parent:GetIntellect() * (self.int12:GetSpecialValueFor("level_bonus") * self.ability:GetLevel())
		return 5 * self.ability:GetLevel()
	end
	return 0
end

function modifier_empower_buff:GetModifierMPRegenAmplify_Percentage()
	if self.int12 ~= nil then
		-- return self.int12:GetSpecialValueFor("level_bonus") * self.ability:GetLevel() * 100
		return 5 * self.ability:GetLevel()
	end
	return 0
end