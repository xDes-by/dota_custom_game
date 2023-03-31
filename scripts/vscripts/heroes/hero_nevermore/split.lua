npc_dota_hero_nevermore_agi8 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_nevermore_agi8", "heroes/hero_nevermore/split", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_dota_hero_nevermore_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_nevermore_agi8"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_nevermore_agi8 = class({})

function modifier_npc_dota_hero_nevermore_agi8:IsHidden()
end

function modifier_npc_dota_hero_nevermore_agi8:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_nevermore_agi8:IsPurgable( kv )
	return false
end


function modifier_npc_dota_hero_nevermore_agi8:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_nevermore_agi8:OnAttack(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
		local target_number = 0
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
	
				self:GetParent():PerformAttack(enemy, false, true, true, true, true, false, false)

				target_number = target_number + 1
				
				if target_number >= 1 then
					break
				end
			end
		end
	end
end