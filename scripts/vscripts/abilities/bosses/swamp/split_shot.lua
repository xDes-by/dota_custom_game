swamp_split_shot = class({})
LinkLuaModifier( "modifier_swamp_split_shot", "abilities/bosses/swamp/split_shot", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function swamp_split_shot:GetIntrinsicModifierName()
	return "modifier_swamp_split_shot"
end

--------------------------------------------------------------------------------

modifier_swamp_split_shot = class({})

function modifier_swamp_split_shot:IsHidden()
end

function modifier_swamp_split_shot:IsDebuff( kv )
	return false
end

function modifier_swamp_split_shot:IsPurgable( kv )
	return false
end


function modifier_swamp_split_shot:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

function modifier_swamp_split_shot:OnAttack(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local target_number = 0
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				self:GetParent():PerformAttack(enemy, false, true, true, true, true, false, false)
				target_number = target_number + 1
				if target_number >= 2 then
					break
				end
			end
		end
	end
end