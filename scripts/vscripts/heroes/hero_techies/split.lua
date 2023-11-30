npc_dota_hero_techies_agi9 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_techies_agi9", "heroes/hero_techies/split", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_dota_hero_techies_agi9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_techies_agi9"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_techies_agi9 = class({})

function modifier_npc_dota_hero_techies_agi9:IsHidden()
end

function modifier_npc_dota_hero_techies_agi9:IsDebuff()
	return false
end

function modifier_npc_dota_hero_techies_agi9:IsPurgable()
	return false
end

function modifier_npc_dota_hero_techies_agi9:OnCreated()
	if not IsServer() then
		return
	end
end

function modifier_npc_dota_hero_techies_agi9:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end

--------------------------------------------------------------------------------

function modifier_npc_dota_hero_techies_agi9:OnAttack( params )
	if params.attacker ~= self:GetParent() and params.no_attack_cooldown then
		return
	end

	local caster = params.attacker
	local target = params.target
	local ability = self
	local attack_range = caster:Script_GetAttackRange() + 100
	local arrow_count = 2
	
	if ability ~= nil then 
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(),nil,attack_range,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,FIND_CLOSEST, false) 
		
		if ability.split == nil then
			ability.split = true
		elseif ability.split == false then
			return
		end
		
		ability.split = false 
		if arrow_count > #units-1  then 
			arrow_count = #units-1
		end

		local index = 1
		local arrow_deal = 0
		while arrow_deal < arrow_count   do
			if units[index] ~= target then
				caster:PerformAttack(units[ index ], true, true, true, false, true, false, false)
				arrow_deal = arrow_deal + 1
			end	
			index = index + 1
		end
		ability.split = true	
	end
end