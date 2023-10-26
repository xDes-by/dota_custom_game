function up(event)
 		local caster = event.caster
		local target = event.target
		local ability = event.ability 
		if target:IsBuilding() then 
		local health = target:GetBaseMaxHealth()
		local health2 = target:GetMaxHealth()	
		local mindmg = target:GetBaseDamageMin()
		local maxdmg = target:GetBaseDamageMax()	
		local arm = target:GetPhysicalArmorBaseValue()
						
		local hp = ability:GetLevelSpecialValueFor( "hp", ability:GetLevel() - 1 )
		local dmg = ability:GetLevelSpecialValueFor( "dmg", ability:GetLevel() - 1 )
		local armor = ability:GetLevelSpecialValueFor( "armor", ability:GetLevel() - 1 )	
		local attak_speed = ability:GetLevelSpecialValueFor( "attak_speed", ability:GetLevel() - 1 )	
			
			
		local abil = caster:FindAbilityByName("npc_dota_hero_tinker_int8")
		if abil ~= nil then
		hp = hp * 2
		armor = armor * 2
		end	
		
		local abil = caster:FindAbilityByName("npc_dota_hero_tinker_int11")
		if abil ~= nil then
		dmg = dmg * 2
		attak_speed = attak_speed * 2
		end	
		local abil = caster:FindAbilityByName("npc_dota_hero_tinker_int_last")
		if abil ~= nil then
		hp = hp * 2
		armor = armor * 2
		dmg = dmg * 2
		attak_speed = attak_speed * 2
		end				
		target:SetMaxHealth(health2 + hp)	
		target:SetBaseMaxHealth(health + hp)	
		target:SetBaseDamageMin(mindmg + dmg)
		target:SetBaseDamageMax(maxdmg + dmg)
		target:SetPhysicalArmorBaseValue(arm + armor)
		
		target:AddNewModifier( target, nil, "modifier_attack_speed_towers", {} )
		local fleshHeapStackModifier = "modifier_attack_speed_towers"
		local currentStacks = target:GetModifierStackCount(fleshHeapStackModifier, target)
		target:SetModifierStackCount(fleshHeapStackModifier, target, (currentStacks + attak_speed))
	elseif 
		target == caster and caster:FindAbilityByName("npc_dota_hero_tinker_str_last") == nil then
		ability:EndCooldown()
	end	
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_tinker_int50") and RollPercentage(20) then
		caster:CastAbilityOnTarget(target, ability, -1)
	end
end

LinkLuaModifier("modifier_attack_speed_towers", "heroes/hero_builder/builder_upgrade/builder_tower_upgrade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_turel", "heroes/hero_builder/builder_upgrade/builder_tower_upgrade", LUA_MODIFIER_MOTION_NONE)
modifier_attack_speed_towers = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end,
})

function modifier_attack_speed_towers:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*1
end

modifier_hero_turel = {}

function modifier_hero_turel:IsHidden()
	return false
end

function modifier_hero_turel:IsDebuff()
	return false
end

function modifier_hero_turel:IsPurgable()
	return false
end

function modifier_hero_turel:OnCreated()
	--self:GetParent():SetModel("models/source/machinegun.vmdl")
end

function modifier_hero_turel:OnDestroy()
	--self:GetParent():SetModel("models/heroes/tinker/tinker.vmdl")
end
function modifier_hero_turel:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end

function modifier_hero_turel:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_hero_turel:GetModifierAttackSpeedBonus_Constant()
	return 1500
end