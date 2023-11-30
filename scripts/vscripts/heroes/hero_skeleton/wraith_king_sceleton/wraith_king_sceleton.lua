wraith_king_sceleton = class({})

LinkLuaModifier( "modifier_wraith_king_sceleton", "heroes/hero_skeleton/wraith_king_sceleton/wraith_king_sceleton", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_armor_debuff", "heroes/hero_skeleton/other/armor_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_skelet_resist", "heroes/hero_skeleton/other/modifier_skelet_resist", LUA_MODIFIER_MOTION_NONE )	

function wraith_king_sceleton:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function wraith_king_sceleton:GetCooldown(level)
	local caster = self:GetCaster()
	local abil = caster:FindAbilityByName("npc_dota_hero_skeleton_king_int6")
		if abil ~= nil	then 
		 return self.BaseClass.GetCooldown( self, level ) / 2
		end
		return self.BaseClass.GetCooldown( self, level )		
end

function wraith_king_sceleton:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local position = caster:GetAbsOrigin()
	local sound_cast = "Hero_SkeletonKing.MortalStrike.Cast"
	EmitSoundOn( sound_cast, caster )
	self.hp_mnoz = self:GetSpecialValueFor( "hp" )
	self.armor = self:GetSpecialValueFor( "armor" )
	self.dmg_mnoz = self:GetSpecialValueFor( "dmg" )
	count = 2
	
	if caster:FindAbilityByName("npc_dota_hero_skeleton_king_agi10") ~= nil then 
		count = 3
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_skeleton_king_agi9")
		if abil ~= nil then 
			self.hp_mnoz = self:GetSpecialValueFor( "hp" ) + 90
			self.armor = self:GetSpecialValueFor( "armor" ) + 90
			self.dmg_mnoz = self:GetSpecialValueFor( "dmg" ) + 90
		end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_agi_last") ~= nil then
		self.dmg_mnoz = self.dmg_mnoz * 2
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skeleton_king_agi50") ~= nil then
		count = 1
		self.hp_mnoz = self.hp_mnoz * 10
		self.armor = self.armor * 10
		self.dmg_mnoz = self.dmg_mnoz * 10
	end	
	for i =1, count do
		caster.skelet = CreateUnitByName("npc_skelets", position + RandomVector( RandomFloat( 150, 150 )), true, caster, nil, caster:GetTeam())
		caster.skelet:AddNewModifier(caster.skelet, ability, "modifier_kill", {duration = 60})
		caster.skelet:AddNewModifier(caster.skelet, ability, "modifier_skelet_resist", {duration = 60})
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_str9")
		if abil ~= nil then 
			caster.skelet:AddNewModifier(caster.skelet, ability, "modifier_health_voker", {}):SetStackCount(1)
		end
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skeleton_king_agi50") ~= nil then
			caster.skelet:SetModelScale(3)
			caster.skelet:SetHullRadius(70)
		else
			caster.skelet:SetHullRadius(20)
		end
		
		caster.skelet:SetControllableByPlayer(caster:GetPlayerID(), true)
		caster.skelet:SetOwner(caster)
	------------------------------------------------------------------------------------------------	
		local hero_health = caster:GetMaxHealth() * self.hp_mnoz * 0.01
		local max_hp = caster.skelet:GetMaxHealth()
		
		caster.skelet:SetBaseMaxHealth(max_hp + (hero_health - 100))
		caster.skelet:SetMaxHealth(max_hp + (hero_health - 100))
		caster.skelet:SetHealth(max_hp + (hero_health - 100))
	------------------------------------------------------------------------------------------------		
		local hero_dmg = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * 0.01
		
		caster.skelet:SetBaseDamageMin(hero_dmg * self.dmg_mnoz)
		caster.skelet:SetBaseDamageMax(hero_dmg * self.dmg_mnoz)
		
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_int11")
		if abil ~= nil then 
		caster.skelet:SetBaseDamageMin(caster.skelet:GetBaseDamageMin() + caster:GetIntellect())
		caster.skelet:SetBaseDamageMax(caster.skelet:GetBaseDamageMax() + caster:GetIntellect())
		end
		
	------------------------------------------------------------------------------------------------		
		local hero_armor = caster:GetPhysicalArmorBaseValue() * 0.01
		
		caster.skelet:SetPhysicalArmorBaseValue(hero_armor * self.armor)	
		
		local abil = caster:FindAbilityByName("npc_dota_hero_skeleton_king_agi7")
		if abil ~= nil then 
		caster.skelet:AddAbility("sven_great_cleave"):SetLevel(1)
		end	
		
		local abil = caster:FindAbilityByName("wraith_king_berserker_lua")
		if abil ~= nil and abil:IsTrained()	then 
		local level = abil:GetLevel()
		caster.skelet:AddAbility("wraith_king_berserker_lua"):SetLevel(level)
		end	
		
		local abil = caster:FindAbilityByName("wraith_king_vampiric_aura_lua")
		if abil ~= nil and abil:IsTrained()	then 
		local level = abil:GetLevel()
		caster.skelet:AddAbility("wraith_king_vampiric_aura_lua"):SetLevel(level)
		end	
		
		local abil = caster:FindAbilityByName("npc_dota_hero_skeleton_king_agi11")
		if abil ~= nil then 
		caster.skelet:AddNewModifier( caster.skelet, nil, "modifier_armor_debuff", { } )
		end	
	end
end

function boom(data)
	local caster = data.caster
	data.caster:ForceKill(false)
end

function boom2(data)
	local caster = data.caster
	local ability = data.ability
	local owner = caster:GetOwner()
	local abil = owner:FindAbilityByName("npc_dota_hero_skeleton_king_int9")
		if abil ~= nil then 
			local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		
	for _,enemy in pairs(enemies) do
		damage = caster:GetMaxHealth() 
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
		end
	end
end