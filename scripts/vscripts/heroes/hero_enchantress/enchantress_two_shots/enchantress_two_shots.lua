LinkLuaModifier("modifier_enchantress_two_shots", "heroes/hero_enchantress/enchantress_two_shots/enchantress_two_shots", LUA_MODIFIER_MOTION_NONE)

enchantress_two_shots = class({}) 

function enchantress_two_shots:GetIntrinsicModifierName()
    return "modifier_enchantress_two_shots"
end

function enchantress_two_shots:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_agi_last") ~= nil then
	return self.BaseClass.GetCooldown( self, level ) - 0.1
	end
	return self.BaseClass.GetCooldown( self, level )
end

modifier_enchantress_two_shots = class({}) 

function modifier_enchantress_two_shots:IsHidden()      return true end
function modifier_enchantress_two_shots:IsPurgable()    return false end

function modifier_enchantress_two_shots:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK,
    }	
end


function modifier_enchantress_two_shots:OnAttack( keys )
    if not IsServer() then return end
    local attacker = self:GetParent()
  
    if attacker ~= keys.attacker then
        return
    end

    if attacker:PassivesDisabled() or attacker:IsIllusion() then
        return
    end

    local target = keys.target

	local range_total = attacker:Script_GetAttackRange()
 	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int6") ~= nil	then 
			if self:GetAbility():IsCooldownReady() and keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() then	
				local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
				if #enemies > 0 then
				for _, enemy in pairs(enemies) do
				--	if enemy ~= keys.target then
						local projectile_info = 
						{
							EffectName = "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
							Ability = self:GetAbility(),
							vSpawnOrigin = self:GetParent():GetAbsOrigin(),
							Target = enemy,
							Source = self:GetParent(),
							bHasFrontalCone = false,
							iMoveSpeed = 1200,
							bReplaceExisting = false,
							bProvidesVision = true
						}
						ProjectileManager:CreateTrackingProjectile(projectile_info)                    
						self:GetAbility():UseResources(false,false,true)
						self:GetParent():EmitSound("Hero_Enchantress.Impetus")
					--end
				end
			end
		end
	else
------------------------------------------------------------------------------------------------------------------------------------	
		if  self:GetAbility():IsCooldownReady() and keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			local target_number = 0
			for _, enemy in pairs(enemies) do
				--if enemy ~= keys.target then
					local projectile_info = 
					{
						EffectName = "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
						Ability = self:GetAbility(),
						vSpawnOrigin = self:GetParent():GetAbsOrigin(),
						Target = enemy,
						Source = self:GetParent(),
						bHasFrontalCone = false,
						iMoveSpeed = 1200,
						bReplaceExisting = false,
						bProvidesVision = true
					}
					ProjectileManager:CreateTrackingProjectile(projectile_info)                    
					self:GetAbility():UseResources(false,false,true)
					self:GetParent():EmitSound("Hero_Enchantress.Impetus")		
					
					target_number = target_number + 1
					if target_number >= 2 then
						break
					end
				--end
			end
		end
	end
end

function enchantress_two_shots:OnProjectileHit( target, location )
    if not IsServer() then return end
    if target then
		local damage = self:GetSpecialValueFor("damage_bonus") + self:GetCaster():GetIntellect() / 100 *  self:GetSpecialValueFor("int")
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int9") ~= nil then 
			damage = damage + self:GetCaster():GetIntellect()
		end
		
        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
		if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str8") ~= nil then 
			self:GetCaster():Heal(damage,nil)
		end
    end
    return true
end