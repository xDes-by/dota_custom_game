LinkLuaModifier("modifier_npc_dota_hero_skeleton_king_int7", "heroes/hero_skeleton/other/tomb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tomb", "modifiers/modifier_tomb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_skelet_resist", "heroes/hero_skeleton/other/modifier_skelet_resist", LUA_MODIFIER_MOTION_NONE )	

npc_dota_hero_skeleton_king_int7 = class({})

function npc_dota_hero_skeleton_king_int7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skeleton_king_int7"
end

if modifier_npc_dota_hero_skeleton_king_int7 == nil then 
    modifier_npc_dota_hero_skeleton_king_int7 = class({})
end

function modifier_npc_dota_hero_skeleton_king_int7:IsHidden()
	return true
end

function modifier_npc_dota_hero_skeleton_king_int7:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_skeleton_king_int7:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_skeleton_king_int7:OnCreated(kv)
	local caster = self:GetCaster()
	local ability = self
	local position = caster:GetAbsOrigin()
	skelet_tomb = CreateUnitByName("Skelet_tomb", position, true, caster, nil, caster:GetTeamNumber())
	skelet_tomb:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_invulnerable",{})
	skelet_tomb:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_tomb",{})
	skelet_tomb:SetOwner(caster)
	skelet_tomb:SetControllableByPlayer(caster:GetPlayerID(), true)
	self:StartIntervalThink(30)
end


function modifier_npc_dota_hero_skeleton_king_int7:OnIntervalThink()
	local caster = self:GetCaster()
	local owner = skelet_tomb:GetOwner()
	local ability = owner:FindAbilityByName("wraith_king_sceleton")
	local position = skelet_tomb:GetAbsOrigin()
	
	if ability ~= nil and ability:IsTrained() then 
	local sound_cast = "Hero_SkeletonKing.MortalStrike.Cast"
	EmitSoundOn( sound_cast, owner )
	
	owner.hp_mnoz = ability:GetSpecialValueFor( "hp" )
	owner.armor = ability:GetSpecialValueFor( "armor" )
	owner.dmg_mnoz = ability:GetSpecialValueFor( "dmg" )
	
		local abil = caster:FindAbilityByName("npc_dota_hero_skeleton_king_agi9")
		if abil ~= nil then 
			owner.hp_mnoz = ability:GetSpecialValueFor( "hp" ) + 90
			owner.armor = ability:GetSpecialValueFor( "armor" ) + 90
			owner.dmg_mnoz = ability:GetSpecialValueFor( "dmg" ) + 90
		end
	
	count = 1
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_int10")
		if abil ~= nil then 
			count = 2
		end
	
	for i=1, count do

		skelet = CreateUnitByName("npc_skelets", position, true, caster, nil, caster:GetTeam())
		skelet:AddNewModifier(skelet, self, "modifier_kill", {duration = 60})
		
		local abil = owner:FindAbilityByName("npc_dota_hero_skeleton_king_str9")
		if abil ~= nil then 
			skelet:AddNewModifier(skelet, nil, "modifier_skelet_resist", {duration = 60})
		end
			
		skelet:SetControllableByPlayer(owner:GetPlayerID(), true)
		skelet:SetOwner(owner)
		------------------------------------------------------------------------------------------------	
			local hero_health = owner:GetMaxHealth() * owner.hp_mnoz * 0.01
			local max_hp = skelet:GetMaxHealth()
			
		skelet:SetBaseMaxHealth(max_hp + (hero_health - 100))
		skelet:SetMaxHealth(max_hp + (hero_health - 100))
		skelet:SetHealth(max_hp + (hero_health - 100))
		------------------------------------------------------------------------------------------------		
			local hero_dmg = owner:GetBaseDamageMin() * 0.01
				
		skelet:SetBaseDamageMin(hero_dmg * owner.dmg_mnoz)
		skelet:SetBaseDamageMax(hero_dmg * owner.dmg_mnoz)
		
	--	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_int11")
	--	if abil ~= nil then 
	--	skelet:SetBaseDamageMin(skelet:GetBaseDamageMin() + owner:GetIntellect())
	--	skelet:SetBaseDamageMax(skelet:GetBaseDamageMax() + owner:GetIntellect())
	--	end
	
	------------------------------------------------------------------------------------------------		
		local hero_armor = owner:GetPhysicalArmorBaseValue() * 0.01
		
			skelet:SetPhysicalArmorBaseValue(hero_armor * owner.armor)	
		
		local abil = owner:FindAbilityByName("wraith_king_berserker_lua")
		if abil ~= nil and abil:IsTrained()	then 
		local level = abil:GetLevel()
			skelet:AddAbility("wraith_king_berserker_lua"):SetLevel(level)
		end	
		
		local abil = owner:FindAbilityByName("wraith_king_vampiric_aura_lua")
		if abil ~= nil and abil:IsTrained()	then 
		local level = abil:GetLevel()
			skelet:AddAbility("wraith_king_vampiric_aura_lua"):SetLevel(level)
		end	
		
		local abil = owner:FindAbilityByName("npc_dota_hero_skeleton_king_agi7")
		if abil ~= nil then 
			skelet:AddAbility("sven_great_cleave"):SetLevel(1)
		end	
	end
	end
end