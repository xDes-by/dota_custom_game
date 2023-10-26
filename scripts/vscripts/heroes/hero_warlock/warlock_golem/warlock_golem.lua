LinkLuaModifier("modifier_golem_stun", "heroes/hero_warlock/warlock_golem/warlock_golem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golem", "heroes/hero_warlock/warlock_golem/warlock_golem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golem_lifesteal", "heroes/hero_warlock/other/modifier_golem_lifesteal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cleave", "heroes/generic/modifier_cleave", LUA_MODIFIER_MOTION_NONE)

warlock_golem = class({})

function warlock_golem:IsHiddenWhenStolen()
	return false
end

function warlock_golem:IsNetherWardStealable()
	return false
end

function warlock_golem:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function warlock_golem:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	EmitSoundOn(sound_precast, caster)

	return true
end

function warlock_golem:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	StopSoundOn(sound_precast, caster)
end


function warlock_golem:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end


function warlock_golem:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorPosition()
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	
	damage_type = DAMAGE_TYPE_PHYSICAL
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_int8")
		if abil ~= nil	then 
		damage_type = DAMAGE_TYPE_MAGICAL
		damage = damage + self:GetCaster():GetIntellect()
	end

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_golem_stun", {duration = self:GetSpecialValueFor("stun_duration") * (1 - enemy:GetStatusResistance())})
			local damageTable = {victim = enemy,
								 attacker = caster, 
								 damage = damage,
								 damage_type = damage_type,
								ability =ability
			}

			ApplyDamage(damageTable)
		end
	EmitSoundOn("Hero_Warlock.RainOfChaos", self:GetCaster())

	local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_start_fx, 0, target)
	ParticleManager:ReleaseParticleIndex(particle_start_fx)

	local min_damage = caster:GetBaseDamageMin()
	local max_damage = caster:GetBaseDamageMax()
	local armor = caster:GetPhysicalArmorBaseValue()
	local mag_resist = caster:GetBaseMagicalResistanceValue()
	local max_hp = caster:GetMaxHealth()
	local max_base_hp = caster:GetBaseMaxHealth()
	local hp = caster:GetMaxHealth()
	count = 1
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi11")
		if abil ~= nil	then 
		count = 2
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi_last")
		if abil ~= nil	then 
		count = count + 3
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_warlock_str50")
	if abil ~= nil	then 
		count = count + 2
	end
	for i =1, count do
	
	local creep = CreateUnitByName( "max_golem", target + RandomVector( RandomFloat( 50, 50 )), true, nil, nil, DOTA_TEAM_GOODGUYS )
	creep:SetControllableByPlayer(caster:GetPlayerID(), true)
	creep:SetOwner(caster)
	
	mnozhitel = 2
	dmg = 1
	hpa = 1
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_str10")
		if abil ~= nil	then 
		mnozhitel = 4
	end
	
	creep_damage_min = min_damage*mnozhitel
	creep_damage_max = max_damage*mnozhitel
	creep_armor = armor*mnozhitel
	creep_resist = mag_resist*mnozhitel
	creep_max_hp = max_hp*mnozhitel
	creep_base_hp = max_base_hp*mnozhitel
	creep_hp = hp*mnozhitel
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_warlock_agi6")
		if abil ~= nil	then 
			dmg = 3
			hpa = 0.5
	end
	
	creep:SetBaseDamageMin(creep_damage_min * dmg)
	creep:SetBaseDamageMax(creep_damage_max * dmg)
	creep:SetPhysicalArmorBaseValue(creep_armor * hpa)
	creep:SetBaseMagicalResistanceValue(creep_resist * hpa)
	creep:SetMaxHealth(creep_max_hp * hpa)
	creep:SetBaseMaxHealth(creep_base_hp * hpa)
	creep:SetHealth(creep_hp * hpa)		
	
	creep:AddNewModifier(self:GetCaster(), self, "modifier_golem", {duration = self:GetSpecialValueFor("duration")})	
	
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

----------------------------------------------------------------------------

modifier_golem = class({})

function modifier_golem:IsHidden() return false end

----------------------------------------------------------------------------

modifier_golem_stun = class({})

function modifier_golem_stun:CheckState() 
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_golem_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_golem_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_golem_stun:IsHidden() return false end
function modifier_golem_stun:IsPurgeException() return true end
function modifier_golem_stun:IsStunDebuff() return true end