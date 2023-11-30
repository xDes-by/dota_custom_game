LinkLuaModifier("modifier_cleave", "heroes/generic/modifier_cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golem_lifesteal", "heroes/hero_warlock/other/modifier_golem_lifesteal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golems", "heroes/hero_warlock/warlock_ripping/warlock_ripping", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------
----------------------------------------------------
modifier_golems = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
		CheckState = function(self) return 
		{

		} end,
})

function die(data)
		local caster = data.caster
		local own = caster:GetOwner()
		local currentStacks = own:GetModifierStackCount( "modifier_golems", ability)
		own:SetModifierStackCount( "modifier_golems", own,currentStacks - 1 )
end
----------------------------------------------------
----------------------------------------------------

warlock_ripping = class({})

function warlock_ripping:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function warlock_ripping:CastFilterResultTarget( hTarget )
	self.max_golems = 5

	if self:GetCaster():GetModifierStackCount( "modifier_golems", self) == self.max_golems then 
		local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_COURIER,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
		return nResult
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int10") == nil and	(
	hTarget:GetUnitName() == "comandir_creep_1"
	or hTarget:GetUnitName() == "comandir_creep_2" 
	or hTarget:GetUnitName() == "comandir_creep_3"
	or hTarget:GetUnitName() == "comandir_creep_4"
	or hTarget:GetUnitName() == "comandir_creep_5"
	or hTarget:GetUnitName() == "comandir_creep_6"
	or hTarget:GetUnitName() == "comandir_creep_7"
	or hTarget:GetUnitName() == "comandir_creep_8"
	or hTarget:GetUnitName() == "comandir_creep_9"
	or hTarget:GetUnitName() == "comandir_creep_10" ) then 
		local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_COURIER,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
		return nResult
	end
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end
	return UF_SUCCESS
end

function warlock_ripping:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local target_point = target:GetAbsOrigin()
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	
	count = 3
	local modifier = caster:AddNewModifier(caster, ability,  "modifier_golems", nil)
	local currentStacks = caster:GetModifierStackCount( "modifier_golems", ability)
	
	if currentStacks < count then
	
	caster:SetModifierStackCount( "modifier_golems", caster,currentStacks + 1 )
	
	if target:IsAncient() then return end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int10")
	if abil == nil and	(
	target:GetUnitName() == "comandir_creep_1"
	or target:GetUnitName() == "comandir_creep_2" 
	or target:GetUnitName() == "comandir_creep_3"
	or target:GetUnitName() == "comandir_creep_4"
	or target:GetUnitName() == "comandir_creep_5"
	or target:GetUnitName() == "comandir_creep_6"
	or target:GetUnitName() == "comandir_creep_7"
	or target:GetUnitName() == "comandir_creep_8"
	or target:GetUnitName() == "comandir_creep_9"
	or target:GetUnitName() == "comandir_creep_10" ) then return 
	
	else

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int7")
	if abil ~= nil	then 
		damage = self:GetCaster():GetIntellect()
	end

	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_warlock_int50")
	if abil ~= nil	then 
		damage = damage + self:GetCaster():GetIntellect()
	end

	 local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			local damageTable = {victim = enemy,
								 attacker = caster, 
								 damage = damage,
								 damage_type = DAMAGE_TYPE_PHYSICAL,
								ability =ability
			}

			ApplyDamage(damageTable)
		end

		min_damage = target:GetBaseDamageMin()
		max_damage = target:GetBaseDamageMax()
		armor = target:GetPhysicalArmorBaseValue()
		mag_resist = target:GetBaseMagicalResistanceValue()
		max_hp = target:GetMaxHealth()
		max_base_hp = target:GetBaseMaxHealth()
		hp = target:GetMaxHealth()

	ApplyDamage({victim = target, attacker = caster, damage = target:GetMaxHealth(), damage_type = DAMAGE_TYPE_PURE, ability = ability})
	
	EmitSoundOn("Hero_Warlock.RainOfChaos", self:GetCaster())
	local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_mid.vpcf", PATTACH_ABSORIGIN, self:GetCaster())  --particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf
	ParticleManager:SetParticleControl(particle_start_fx, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle_start_fx)
	
	local particle_start_fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_start_fx2, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle_start_fx2)
	

	
	mnozhitel = 1
	dmg = 1
	hpa = 1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str_last") ~= nil then
		mnozhitel = mnozhitel + 2
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi8")
		if abil ~= nil	then 
		mnozhitel = mnozhitel + 0.5
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_warlock_agi50")
		if abil ~= nil	then 
		mnozhitel = mnozhitel + 0.5
	end	
	-----------------------------------------------------
	creep_damage_min = min_damage*mnozhitel
	creep_damage_max = max_damage*mnozhitel
	creep_armor = armor*mnozhitel
	creep_resist = mag_resist*mnozhitel
	creep_max_hp = max_hp*mnozhitel
	creep_base_hp = max_base_hp*mnozhitel
	creep_hp = hp*mnozhitel
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi6")
		if abil ~= nil then 
			dmg = 3
			hpa = 0.5
	end
	for i=1, (self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_warlock_str50") and 2 or 1) do
		local creep = CreateUnitByName( "mini_golem", target_point + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_GOODGUYS )
		creep:SetControllableByPlayer(caster:GetPlayerID(), true)
		creep:SetOwner(caster)

		creep:SetBaseDamageMin(creep_damage_min * dmg)
		creep:SetBaseDamageMax(creep_damage_max * dmg)
		creep:SetPhysicalArmorBaseValue(creep_armor * hpa)
		creep:SetBaseMagicalResistanceValue(creep_resist * hpa)
		creep:SetMaxHealth(creep_max_hp * hpa)
		creep:SetBaseMaxHealth(creep_base_hp * hpa)
		creep:SetHealth(creep_hp * hpa)		
		-----------------------------------------------------
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi10")
			if abil ~= nil	then 
			creep:AddNewModifier(self:GetCaster(), self, "modifier_cleave", {})	
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str7")
			if abil ~= nil	then 
			creep:AddNewModifier(self:GetCaster(), self, "modifier_magic_immune", {})	
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi9")
			if abil ~= nil	then 
			creep:AddNewModifier(self:GetCaster(), self, "modifier_golem_lifesteal", {})	
		end
		
		end
	end
	end
end