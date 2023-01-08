marci_crystals = class({})

LinkLuaModifier("modifier_marci_crystals_bonus_str", 'heroes/hero_marci/marci_crystals', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_crystals_day", 'heroes/hero_marci/marci_crystals', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_crystals_nigth", 'heroes/hero_marci/marci_crystals', LUA_MODIFIER_MOTION_NONE)

function marci_crystals:GetIntrinsicModifierName()
	return "modifier_marci_crystals_day"
end

modifier_marci_crystals_day = class({})

function modifier_marci_crystals_day:IsHidden()
	return false
end

function modifier_marci_crystals_day:IsDebuff()
	return false
end

function modifier_marci_crystals_day:IsPurgable()
	return false
end

function modifier_marci_crystals_day:RemoveOnDeath()
	return false
end

function modifier_marci_crystals_day:OnCreated( kv )
	self.soul_release = self:GetAbility():GetSpecialValueFor("soul_release")
	if IsServer() then
		self:SetStackCount(0)
	end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_marci_crystals_nigth", nil)
end

modifier_marci_crystals_nigth = class({})

function modifier_marci_crystals_nigth:GetTexture()
    return "marci_1spell_night"
end

function modifier_marci_crystals_nigth:IsHidden()
	return false
end

function modifier_marci_crystals_nigth:IsDebuff()
	return false
end

function modifier_marci_crystals_nigth:IsPurgable()
	return false
end

function modifier_marci_crystals_nigth:RemoveOnDeath()
	return false
end

function modifier_marci_crystals_day:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_marci_crystals_day:GetModifierBonusStats_Intellect()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int8") ~= nil then 
        return self.nightstacks
    end
end

function modifier_marci_crystals_day:GetModifierSpellAmplify_Percentage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int6") ~= nil then 
        return self.nightstacks
    end
end

function modifier_marci_crystals_day:GetModifierBaseAttack_BonusDamage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str11") ~= nil then 
    return (self:GetParent():GetIntellect() + self:GetParent():GetAgility() + self:GetParent():GetStrength()) * 3
    end
end

function modifier_marci_crystals_day:GetModifierBonusStats_Strength()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str7") ~= nil then 
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str10") ~= nil then
            return self.daystacks + self.nightstacks
        end
        return self.daystacks 
    end
end

function modifier_marci_crystals_day:GetModifierHealthBonus()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str9") ~= nil then 
        return (self.nightstacks + self.daystacks) * 6
    end
end

function modifier_marci_crystals_day:OnDeath( params )
	local target = params.unit
	local attacker = params.attacker
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if not target:IsBuilding() and not self:GetParent():PassivesDisabled() and RandomInt(1,100) <= self:GetAbility():GetSpecialValueFor("chance") then
			local count = 1 
			
			if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str_last") ~= nil and self:GetParent():GetLevel() >= 50 then 
				count = 5
			end
			
			if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi6") ~= nil then 
				self:GetParent():ModifyAgility(count)
			end

			if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str6") ~= nil then 
				for i=1,count do
					self:IncrementStackCount()
					self:GetParent():FindModifierByName("modifier_marci_crystals_nigth"):IncrementStackCount()
				end
			else
				for i=1,count do
					if GameRules:IsDaytime() then
						self:IncrementStackCount()
					else
						self:GetParent():FindModifierByName("modifier_marci_crystals_nigth"):IncrementStackCount()
					end
				end
			end
		end
	end
	self.daystacks = self:GetStackCount()
	self.nightstacks = self:GetParent():FindModifierByName("modifier_marci_crystals_nigth"):GetStackCount()
	
    local particleName = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	local Particle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, attacker)
	ParticleManager:SetParticleControlEnt(Particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(Particle, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
marci_prigok = class({})

LinkLuaModifier( "modifier_marci_prigok_lua_helper", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_BOTH )

function marci_prigok:GetIntrinsicModifierName()
	return "modifier_marci_prigok_lua_helper"
end

modifier_marci_prigok_lua_helper = class({})

function modifier_marci_prigok_lua_helper:IsHidden()
	return true
end

function modifier_marci_prigok_lua_helper:IsPurgable()
	return false
end

function modifier_marci_prigok_lua_helper:OnCreated()
	self:StartIntervalThink(0.2)
end

function modifier_marci_prigok_lua_helper:OnIntervalThink() 
    if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then return end

    local caster = self:GetCaster()
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    if GameRules:IsDaytime() then
    self.modifier = self:GetParent():FindModifierByName("modifier_marci_crystals_day")
    if self.modifier == nil then return end
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)
    if enemies[1] == nil then return end
    local cd = self:GetAbility():GetSpecialValueFor("cd")
    self:GetAbility():StartCooldown(cd)
	local damage = self.modifier:GetStackCount() + self:GetParent():GetAttackDamage()
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int11") ~= nil and RandomInt(1,100) <=35 then 
            damage = damage * 2
			cd = cd - 1
        end
        local damageTable = {attacker = caster,damage = damage,damage_type = DAMAGE_TYPE_PHYSICAL,ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION}

		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			self:PlayEffects4( enemy )
		end
    else
    self.modifier = self:GetParent():FindModifierByName("modifier_marci_crystals_nigth")
    if self.modifier == nil then return end
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)
    if enemies[1] == nil then return end
    local cd = self:GetAbility():GetSpecialValueFor("cd") * 0.7
    self:GetAbility():StartCooldown(cd)

        local damage = self.modifier:GetStackCount()
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int11") ~= nil and RandomInt(1,100) <=35 then 
            damage = damage * 2
			cd = cd - 1
        end
        local damageTable = {attacker = caster,damage = damage,damage_type = DAMAGE_TYPE_MAGICAL,ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE}

		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			self:PlayEffects4( enemy )
		end
    end
	self:PlayEffects2()
	self:PlayEffects3()
end

function modifier_marci_prigok_lua_helper:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function modifier_marci_prigok_lua_helper:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump.Shield"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function modifier_marci_prigok_lua_helper:PlayEffects4( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
marci_sidekick_lua = class({})

function marci_sidekick_lua:GetManaCost(iLevel)
	return math.min(65000, self:GetCaster():GetIntellect())
end

LinkLuaModifier( "modifier_marci_sidekick_lua", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_BOTH )

function marci_sidekick_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor( "buff_duration" )

	if target==caster or target == nil then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,700,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO,0,FIND_CLOSEST,false)

		local closest = nil
		for _,ally in pairs(allies) do
			if ally~=caster then
				closest = ally
				break
			end
		end

		target = closest
	end

	caster:AddNewModifier(caster,self,"modifier_marci_sidekick_lua",{ duration = duration })

	if not target then return end
	target:AddNewModifier(caster,self,"modifier_marci_sidekick_lua",{ duration = duration })
end

modifier_marci_sidekick_lua = class({})

function modifier_marci_sidekick_lua:IsHidden()
	return false
end

function modifier_marci_sidekick_lua:IsDebuff()
	return false
end

function modifier_marci_sidekick_lua:IsPurgable()
	return true
end

function modifier_marci_sidekick_lua:RemoveOnDeath()
	return true
end

function modifier_marci_sidekick_lua:OnCreated()
    if self:GetParent():FindModifierByName("modifier_marci_crystals_day") == nil then return end
    if GameRules:IsDaytime() then
        self.night = 0
        self.day = self:GetParent():FindModifierByName("modifier_marci_crystals_day"):GetStackCount()
    else
        self.night = self:GetParent():FindModifierByName("modifier_marci_crystals_nigth"):GetStackCount()
        self.day = 0
    end
    if not IsServer() then return end
    self:PlayEffects()
end

function modifier_marci_sidekick_lua:OnDestroy()
    if not IsServer() or self.effect_cast == nil then return end
    ParticleManager:DestroyParticle(self.effect_cast,false)
end

function modifier_marci_sidekick_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    }
end

function modifier_marci_sidekick_lua:GetModifierProcAttack_BonusDamage_Physical(keys)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi9") ~= nil then 
        return self.day + self.day * 0.1
    end
    return self.day
end

function modifier_marci_sidekick_lua:GetModifierSpellAmplify_Percentage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi9") ~= nil then 
        return self.night * 5 + (self.night * 0.1)
    end
    return self.night * 5
end

function modifier_marci_sidekick_lua:PlayEffects()
    if not IsServer() then return end
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
	if self:GetParent()~=self:GetCaster() then
		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
	end

	local sound_target = "Hero_Marci.Guardian.Applied"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetOrigin() )
	--ParticleManager:ReleaseParticleIndex( self.effect_cast )

	--self:AddParticle(self.effect_cast,false,false,-1,false,false)

	EmitSoundOn( sound_target, self:GetParent() )
end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
marci_unleash_lua = class({})

function marci_unleash_lua:GetManaCost(iLevel)
	return math.min(65000, self:GetCaster():GetIntellect() * 3)
end


LinkLuaModifier( "modifier_unleash_weakness", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_animation", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_fury", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_debuff", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_recovery", "heroes/hero_marci/marci_crystals", LUA_MODIFIER_MOTION_NONE )

modifier_unleash_weakness = class({})

function modifier_unleash_weakness:IsHidden()
    return true
end

function modifier_unleash_weakness:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_unleash_weakness:GetModifierMagicalResistanceBonus()
    return -25
end

function marci_unleash_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

function marci_unleash_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int10") ~= nil then
        duration = duration + 6
    end 
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi_last") ~= nil then 
	    caster:AddNewModifier(caster,self,"modifier_magic_immune",{ duration = duration })
    end
	caster:AddNewModifier(caster,self,"modifier_marci_unleash_lua",{ duration = duration })
end

modifier_marci_unleash_lua = class({})

function modifier_marci_unleash_lua:IsHidden()
	return false
end

function modifier_marci_unleash_lua:IsDebuff()
	return false
end

function modifier_marci_unleash_lua:IsPurgable()
	return false
end

function modifier_marci_unleash_lua:OnCreated( kv )
	
	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	if not IsServer() then return end
	self:GetParent():Purge( false, true, false, false, false )
	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_marci_unleash_lua_fury",{})
	self:PlayEffects()
end

function modifier_marci_unleash_lua:OnRefresh( kv )
	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )	
	if not IsServer() then return end
	self:GetParent():Purge( false, true, false, false, false )
	self:PlayEffects()
end

function modifier_marci_unleash_lua:OnRemoved()
end

function modifier_marci_unleash_lua:OnDestroy()
	if not IsServer() then return end

	-- destroy fury or recovery modifiers
	local fury = self:GetParent():FindModifierByNameAndCaster( "modifier_marci_unleash_lua_fury", self:GetParent() )
	if fury then
		fury:ForceDestroy()
	end

	local recovery = self:GetParent():FindModifierByNameAndCaster( "modifier_marci_unleash_lua_recovery", self:GetParent() )
	if recovery then
		recovery:ForceDestroy()
	end
end

function modifier_marci_unleash_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATUS_RESISTANCE
	}

	return funcs
end

function modifier_marci_unleash_lua:GetModifierStatusResistance()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi_last") ~= nil then 
        return 100
    end
end

function modifier_marci_unleash_lua:GetModifierAttackSpeedBonus_Constant()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi10") ~= nil then 
        return self:GetParent():GetLevel() * 5
    end
end

function modifier_marci_unleash_lua:GetModifierBaseAttack_BonusDamage()
    if GameRules:IsDaytime() and self:GetCaster():FindModifierByName("modifier_marci_crystals_nigth") ~= nil then
        return self:GetCaster():FindModifierByName("modifier_marci_crystals_nigth"):GetStackCount() * 10
    end
end

function modifier_marci_unleash_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_ms
end

function modifier_marci_unleash_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

modifier_marci_unleash_lua_animation = class({})

function modifier_marci_unleash_lua_animation:IsHidden()
	return true
end

function modifier_marci_unleash_lua_animation:IsDebuff()
	return false
end

function modifier_marci_unleash_lua_animation:IsPurgable()
	return false
end

function modifier_marci_unleash_lua_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_marci_unleash_lua_animation:GetActivityTranslationModifiers()
	return "unleash"
end

modifier_marci_unleash_lua_debuff = class({})

function modifier_marci_unleash_lua_debuff:IsHidden()
	return false
end

function modifier_marci_unleash_lua_debuff:IsDebuff()
	return true
end

function modifier_marci_unleash_lua_debuff:IsPurgable()
	return true
end

function modifier_marci_unleash_lua_debuff:OnCreated( kv )
	-- references
	self.as_slow = -self:GetAbility():GetSpecialValueFor( "pulse_attack_slow_pct" )
	self.ms_slow = -self:GetAbility():GetSpecialValueFor( "pulse_move_slow_pct" )

	if not IsServer() then return end
end

function modifier_marci_unleash_lua_debuff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_unleash_lua_debuff:OnRemoved()
end

function modifier_marci_unleash_lua_debuff:OnDestroy()
end

function modifier_marci_unleash_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_marci_unleash_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_marci_unleash_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_marci_unleash_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf"
end

function modifier_marci_unleash_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marci_unleash_lua_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_marci_unleash_lua_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

modifier_marci_unleash_lua_fury = class({})

function modifier_marci_unleash_lua_fury:GetTexture()
    return "Unleash_Flurry_icon"
end

function modifier_marci_unleash_lua_fury:IsHidden()
	return false
end

function modifier_marci_unleash_lua_fury:IsDebuff()
	return false
end

function modifier_marci_unleash_lua_fury:IsPurgable()
	return false
end

function modifier_marci_unleash_lua_fury:OnCreated( kv )
	
	

	-- references
	self.bonus_as = self:GetAbility():GetSpecialValueFor( "flurry_bonus_attack_speed" )
    self.recovery = self:GetAbility():GetSpecialValueFor( "time_between_flurries" )
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi8") ~= nil then 
	    self.recovery = self.recovery - 0.5
    end
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi11") ~= nil then 
	    self.recovery = self.recovery - 0.5
    end
	self.charges = self:GetAbility():GetSpecialValueFor( "charges_per_flurry" )
	self.timer = self:GetAbility():GetSpecialValueFor( "max_time_window_per_hit" )

	self.radius = self:GetAbility():GetSpecialValueFor( "pulse_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "pulse_damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "pulse_debuff_duration" )

	if not IsServer() then return end

	self.counter = self.charges
	self:SetStackCount( self.counter )

	self.success = 0

	self.animation = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_marci_unleash_lua_animation",{})

	self:PlayEffects1()
	self:PlayEffects2( self:GetParent(), self.counter )

end

function modifier_marci_unleash_lua_fury:OnDestroy()
	if not IsServer() then return end

	if not self.animation:IsNull() then
		self.animation:Destroy()
	end

	local main = self:GetParent():FindModifierByNameAndCaster( "modifier_marci_unleash_lua", self:GetParent() )
	if not main then return end

	if self.forced then return end

	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_marci_unleash_lua_recovery",
		{
			duration = self.recovery,
			success = self.success,
		})

	if self.success~=1 then return end
end

function modifier_marci_unleash_lua_fury:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_marci_unleash_lua_fury:GetModifierAttackSpeed_Limit()
	return 1
end

function modifier_marci_unleash_lua_fury:GetModifierProcAttack_Feedback( params )
    if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_agi7") ~= nil then 
	    self:StartIntervalThink( self.timer + 2 )
    else
	    self:StartIntervalThink( self.timer )
    end
	self.counter = self.counter - 1
	self:SetStackCount( self.counter )
	self:EditEffects2( self.counter )
	self:PlayEffects3( self:GetParent(), params.target )

	if self.counter<=0 then
		self.success = 1
		self:Pulse( params.target:GetOrigin() )
		self:Destroy()
	end

end

function modifier_marci_unleash_lua_fury:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_marci_unleash_lua_fury:GetActivityTranslationModifiers()
	if self:GetStackCount()==1 then
		return "flurry_pulse_attack"
	end

	if self:GetStackCount()%2==0 then
		return "flurry_attack_b"
	end

	return "flurry_attack_a"
end

function modifier_marci_unleash_lua_fury:OnIntervalThink()
	self:Destroy()
end

function modifier_marci_unleash_lua_fury:Pulse( center )
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),center,nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)

    if not GameRules:IsDaytime() and self:GetCaster():FindModifierByName("modifier_marci_crystals_nigth") ~= nil then
        self.damage = self.damage + self:GetCaster():FindModifierByName("modifier_marci_crystals_nigth"):GetStackCount() * 3
    end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int7") ~= nil then 
            self.damage = self.damage +self:GetCaster():GetIntellect()
        end
        local pass = false
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_str8") ~= nil then 
            pass = true
            self.damage = self.damage + self:GetCaster():GetStrength()
        end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int_last") ~= nil and self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int7") ~= nil then 
            self.damage = self.damage + self.damage
        else
            self.damage = self.damage +self:GetCaster():GetIntellect()
        end
        local talentpass = false
        if self:GetCaster():FindAbilityByName("npc_dota_hero_marci_int9") ~= nil then 
            talentpass = true
        end

    
	local damageTable = {attacker = self:GetParent(),damage = self.damage,damage_type = DAMAGE_TYPE_MAGICAL,ability = self:GetAbility(),}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
        if pass == true then
		    enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_disarmed",{ duration = self.duration })
        end
        if talentpass == true then
		    enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_unleash_weakness",{ duration = self.duration })
        end
		enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_marci_unleash_lua_debuff",{ duration = self.duration })
	end

	self:PlayEffects4( center, self.radius )
end

function modifier_marci_unleash_lua_fury:ForceDestroy()
	self.forced = true
	self:Destroy()
end

function modifier_marci_unleash_lua_fury:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Charged"
	local sound_cast2 = "Hero_Marci.Unleash.Charged.2D"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"eye_l",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,2,self:GetParent(),PATTACH_POINT_FOLLOW,"eye_r",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,3,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,4,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack2",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,5,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack1",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,6,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_attack2",Vector(0,0,0),true)
	self:AddParticle(effect_cast,false,false,-1, false,false)
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_cast2, self:GetParent() )
end

function modifier_marci_unleash_lua_fury:PlayEffects2( caster, counter )
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 0, counter, 0 ) )
	self:AddParticle(effect_cast,false,false,-1,false,false)
	self.effect_cast = effect_cast
end

function modifier_marci_unleash_lua_fury:EditEffects2( counter )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, counter, 0 ) )
end

function modifier_marci_unleash_lua_fury:PlayEffects3( caster, target )
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(effect_cast,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_marci_unleash_lua_fury:PlayEffects4( point, radius )
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Pulse"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,radius,radius) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetParent() )
end

modifier_marci_unleash_lua_recovery = class({})

function modifier_marci_unleash_lua_recovery:IsHidden()
	return false
end

function modifier_marci_unleash_lua_recovery:IsDebuff()
	return true
end

function modifier_marci_unleash_lua_recovery:IsPurgable()
	return false
end

function modifier_marci_unleash_lua_recovery:OnCreated( kv )
	
	self.rate = self:GetAbility():GetSpecialValueFor( "recovery_fixed_attack_rate" )
	if not IsServer() then return end
	self.success = kv.success==1
end

function modifier_marci_unleash_lua_recovery:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_unleash_lua_recovery:OnRemoved()
end

function modifier_marci_unleash_lua_recovery:OnDestroy()
	if not IsServer() then return end

	local main = self:GetParent():FindModifierByNameAndCaster( "modifier_marci_unleash_lua", self:GetParent() )
	if not main then return end
	if self.forced then return end

	self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_marci_unleash_lua_fury",{})

end

function modifier_marci_unleash_lua_recovery:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
	}

	return funcs
end

function modifier_marci_unleash_lua_recovery:GetModifierFixedAttackRate( params )
	return self.rate
end

function modifier_marci_unleash_lua_recovery:ForceDestroy()
	self.forced = true
	self:Destroy()
end