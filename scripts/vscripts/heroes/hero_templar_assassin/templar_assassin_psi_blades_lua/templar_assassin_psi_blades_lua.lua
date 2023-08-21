LinkLuaModifier("modifier_templar_assassin_psi_blades_lua_damage", "heroes/hero_templar_assassin/templar_assassin_psi_blades_lua/templar_assassin_psi_blades_lua", LUA_MODIFIER_MOTION_NONE)

templar_assassin_psi_blades_lua = class({})

function templar_assassin_psi_blades_lua:GetIntrinsicModifierName()
	return "modifier_templar_assassin_psi_blades_lua_damage"
end

-----------------------------------------------

modifier_templar_assassin_psi_blades_lua_damage = class({})

function modifier_templar_assassin_psi_blades_lua_damage:IsHidden()
	return true
end

function modifier_templar_assassin_psi_blades_lua_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_templar_assassin_psi_blades_lua_damage:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_templar_assassin_psi_blades_lua_damage:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and self:GetAbility():IsTrained() and not self:GetParent():PassivesDisabled() and keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and not keys.unit:IsBuilding() and (not keys.unit:IsOther() or (keys.unit:IsOther() and keys.damage > 0)) then
		local damage_to_use = keys.damage
		
		for _, enemy in pairs(FindUnitsInLine(self:GetCaster():GetTeamNumber(), keys.unit:GetAbsOrigin(), keys.unit:GetAbsOrigin() + ((keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized() * self:GetAbility():GetSpecialValueFor("attack_spill_range")), nil, self:GetAbility():GetSpecialValueFor("attack_spill_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)) do
			if enemy ~= keys.unit then
				enemy:EmitSound("Hero_TemplarAssassin.PsiBlade")
			
				self.psi_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
				ParticleManager:SetParticleControlEnt(self.psi_particle, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.psi_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.psi_particle)
				
				local prc = self:GetAbility():GetSpecialValueFor("attack_spill_pct")
				
				local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_templar_assassin_tal3")
				if ability ~= nil and ability:GetLevel() > 0 then 
					prc = prc + 25
				end

				
				ApplyDamage({
					victim 			= enemy,
					damage 			= damage_to_use * prc * 0.01,
					damage_type		= self:GetAbility():GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					attacker 		= self:GetParent(),
					ability 		= self:GetAbility()
				})
			end
		end
	end
end