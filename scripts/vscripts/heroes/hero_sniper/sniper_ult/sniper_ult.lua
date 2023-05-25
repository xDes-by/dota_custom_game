sniper_ult = class({})
LinkLuaModifier( "modifier_sniper_ult", "heroes/hero_sniper/sniper_ult/sniper_ult.lua", LUA_MODIFIER_MOTION_NONE )

function sniper_ult:GetIntrinsicModifierName()
	return "modifier_sniper_ult"
end

--------------------------------------------------------------------------

modifier_sniper_ult = class({})

function modifier_sniper_ult:IsHidden()
	return true
end

function modifier_sniper_ult:IsPurgable()
	return false
end

function modifier_sniper_ult:OnCreated( kv )
end

function modifier_sniper_ult:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_sniper_ult:OnAttackLanded(keys)
if not IsServer() then return end
	if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() then
	local chance = self:GetAbility():GetSpecialValueFor("chance")
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local caster_damage = keys.attacker:GetBaseDamageMin()
		if RandomInt(1,100) <= chance then
			
			if self:GetParent():FindAbilityByName("npc_dota_hero_sniper_agi11") ~= nil then 
				caster_damage = keys.attacker:GetAverageTrueAttackDamage(nil)
			end
			flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
			
			if self:GetParent():FindAbilityByName("npc_dota_hero_sniper_agi_last") ~= nil then
				flags = DOTA_DAMAGE_FLAG_NONE 
			end
			local boom_damage = math.ceil(caster_damage * damage / 100)
			
			damage_table = {
				attacker = keys.attacker,
				damage = boom_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = flags
			}
			
			local enemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, keys.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _,enemy in pairs(enemies) do
				damage_table.victim = enemy
				ApplyDamage(damage_table)
			end
			
			EmitSoundOn("Hero_Jakiro.LiquidFire", keys.attacker)
		end
	end
end