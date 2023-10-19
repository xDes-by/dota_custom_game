ability_apparition_boss_split = class({})
LinkLuaModifier( "modifier_ability_apparition_boss_split", "abilities/bosses/apparition/ability_apparition_boss_split", LUA_MODIFIER_MOTION_NONE )

function ability_apparition_boss_split:GetIntrinsicModifierName()
	return "modifier_ability_apparition_boss_split"
end

modifier_ability_apparition_boss_split = class({})

function modifier_ability_apparition_boss_split:IsHidden()
    return true
end

function modifier_ability_apparition_boss_split:IsDebuff()
	return false
end

function modifier_ability_apparition_boss_split:IsPurgable()
	return false
end


function modifier_ability_apparition_boss_split:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end

function modifier_ability_apparition_boss_split:OnAttack(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local target_number = 0
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
	
				self:GetParent():PerformAttack(enemy, true, true, true, true, true, false, true)

				target_number = target_number + 1
				
				if target_number >= 3 then
					break
				end
			end
		end
	end
end