enfos_wizard_disjunction = class({})

LinkLuaModifier("modifier_disjunction_debuff", "creatures/abilities/5v5/wizard/enfos_wizard_disjunction", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_disjunction:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local target_loc = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")

	EmitSoundOnLocationWithCaster(target_loc, "Wizard.Disjunction", caster)

	local cast_pfx = ParticleManager:CreateParticle("particles/5v5/disjunction_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	local enemies = FindUnitsInRadius(team, target_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy:GetTeam() ~= DOTA_TEAM_NEUTRALS or (enemy.spawner_team and enemy.spawner_team == team) then
			enemy:Purge(true, false, false, false, false)
			enemy:AddNewModifier(caster, self, "modifier_disjunction_debuff", {duration = duration})

			if (enemy.is_elite or enemy.is_boss) then
				enemy:RemoveAbility("creature_decay_aura")
				enemy:RemoveAbility("creature_lifesteal_aura")
				enemy:RemoveAbility("creature_speed_aura")
				enemy:RemoveAbility("creature_health_aura")
				enemy:RemoveAbility("creature_frost_aura")
				enemy:RemoveAbility("creature_armor_aura")
				enemy:RemoveAbility("creature_attack_speed_aura")
				enemy:RemoveAbility("creature_damage_aura")
				enemy:RemoveAbility("creature_mana_burn_aura")
				enemy:RemoveAbility("creature_acid_aura")
				enemy:RemoveAbility("creature_evasion_aura")
				enemy:RemoveAbility("creature_steroids")
				enemy:RemoveAbility("creature_solidity_aura")
				enemy:RemoveAbility("creature_blade_aura")
				enemy:RemoveAbility("boss_berserking")
				enemy:RemoveAbility("creature_magic_resist_aura")
				enemy:RemoveAbility("creature_fire_aura")
				enemy:RemoveAbility("big_thunder_lizard_wardrums_aura")
				enemy:RemoveAbility("creature_desecrate_aura")
				enemy:RemoveAbility("creature_bubble_aura")
				enemy:RemoveModifierByName("modifier_creature_decay_aura")
				enemy:RemoveModifierByName("modifier_creature_lifesteal_aura")
				enemy:RemoveModifierByName("modifier_creature_speed_aura")
				enemy:RemoveModifierByName("modifier_creature_health_aura")
				enemy:RemoveModifierByName("modifier_creature_frost_aura")
				enemy:RemoveModifierByName("modifier_creature_armor_aura")
				enemy:RemoveModifierByName("modifier_creature_attack_speed_aura")
				enemy:RemoveModifierByName("modifier_creature_damage_aura")
				enemy:RemoveModifierByName("modifier_creature_mana_burn_aura")
				enemy:RemoveModifierByName("modifier_creature_acid_aura")
				enemy:RemoveModifierByName("modifier_creature_evasion_aura")
				enemy:RemoveModifierByName("modifier_creature_steroids")
				enemy:RemoveModifierByName("modifier_creature_solidity_aura")
				enemy:RemoveModifierByName("modifier_creature_blade_aura")
				enemy:RemoveModifierByName("modifier_creature_magic_resist_aura")
				enemy:RemoveModifierByName("modifier_creature_fire_aura")
				enemy:RemoveModifierByName("modifier_boss_berserking")
				enemy:RemoveModifierByName("modifier_creature_desecrate_aura")
				enemy:RemoveModifierByName("modifier_creature_bubble_aura")
			end
		end
	end

	EnfosWizard:CastSpellResult(caster, "disjunction")
end

function enfos_wizard_disjunction:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



modifier_disjunction_debuff = class({})

function modifier_disjunction_debuff:IsHidden() return false end
function modifier_disjunction_debuff:IsDebuff() return false end
function modifier_disjunction_debuff:IsPurgable() return false end

function modifier_disjunction_debuff:GetTexture() return "enfos_wizard_disjunction" end

function modifier_disjunction_debuff:GetEffectName()
	return "particles/5v5/disjunction_debuff.vpcf"
end

function modifier_disjunction_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_disjunction_debuff:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
end 

function modifier_disjunction_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_disjunction_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end 
