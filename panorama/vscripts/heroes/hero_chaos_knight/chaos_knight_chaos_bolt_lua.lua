chaos_knight_chaos_bolt_lua = class({})

function chaos_knight_chaos_bolt_lua:GetCastRange()
	local cast_range = self:GetSpecialValueFor("AbilityCastRange")
	local caster = self:GetCaster()

	if caster and caster:HasShard() then
		cast_range = cast_range + self:GetSpecialValueFor("shard_cast_range_increase")
	end
	return cast_range
end

function chaos_knight_chaos_bolt_lua:GetCooldown(level)
    return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_chaos_knight_8")
end

function chaos_knight_chaos_bolt_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local fake_bolt_distance = self:GetSpecialValueFor("fake_bolt_distance")
	
    -- Change Phantasm Illusions animation
    self.allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, fake_bolt_distance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    self.phantasm_illusions = {}

    for key, ally in pairs(self.allies) do
        if ally and ally:IsIllusion() and ally:HasModifier("modifier_chaos_knight_phantasm_illusion") then
            -- Use this in OnAbilityPhaseInterrupted and OnSpellStart
            self.phantasm_illusions[key] = ally

            -- Make it look good
            ally:FaceTowards(target:GetAbsOrigin())
            ally:StartGesture(self:GetCastAnimation())
        end
    end

	return true
end

function chaos_knight_chaos_bolt_lua:OnAbilityPhaseInterrupted()
    if self.phantasm_illusions then
        for _, illusion in pairs(self.phantasm_illusions) do
            illusion:RemoveGesture(self:GetCastAnimation())
        end
    end
end

function chaos_knight_chaos_bolt_lua:OnSpellStart()

    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    local projectile_speed = self:GetSpecialValueFor("chaos_bolt_speed")
    
    local projectile_info = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
        bDodgeable = true,
        bProvidesVision = false,
        iMoveSpeed = projectile_speed,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        ExtraData			= { iFakeBolt = 0 }
    }
    
    if caster and target then
        ProjectileManager:CreateTrackingProjectile( projectile_info )
    end
    
    caster:EmitSound("Hero_ChaosKnight.ChaosBolt.Cast")

    -- Change Phantasm Illusions animation
    if self.phantasm_illusions then
        for _, illusion in pairs(self.phantasm_illusions) do    
            -- Shoot your shot
            projectile_info.Source = illusion
            projectile_info.ExtraData = { iFakeBolt = 1 }
            ProjectileManager:CreateTrackingProjectile( projectile_info )
        end
    end
    
end

function chaos_knight_chaos_bolt_lua:OnProjectileHit_ExtraData(target, location, ExtraData)

	if not self or self:IsNull() then return end

    if not target or target:IsNull() or target:IsMagicImmune() then return end

	-- Cancel if linken
	if target:TriggerSpellAbsorb(self) then
		return
	end
    
    -- Create the stun and damage particle for the spell
    -- Illusions also trigger on hit animations
    local chaos_bolt_particle = "particles/units/heroes/hero_chaos_knight/chaos_knight_bolt_msg.vpcf"
    local target_location = target:GetAbsOrigin()
    local particle = ParticleManager:CreateParticle(chaos_bolt_particle, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(particle, 0, target_location)

    -- If the projectile source is an illusion, do nothing
    if ExtraData.iFakeBolt == 1 then
        return
    end

    -- Unit identifier
    local caster = self:GetCaster()
    local ability = self
	local ability_level = ability:GetLevel() - 1

    -- Ability variables
	local stun_min = ability:GetLevelSpecialValueFor("stun_min", ability_level)
	local stun_max = ability:GetLevelSpecialValueFor("stun_max", ability_level) 
	local damage_min = ability:GetLevelSpecialValueFor("damage_min", ability_level) 
	local damage_max = ability:GetLevelSpecialValueFor("damage_max", ability_level)

    -- Talent
    if caster:HasTalent("special_bonus_unique_chaos_knight_3") then
		stun_min = stun_min + caster:GetTalentValue("special_bonus_unique_chaos_knight_3")
        stun_max = stun_max + caster:GetTalentValue("special_bonus_unique_chaos_knight_3")
	end

    -- Calculate the stun and damage values
	local random = RandomFloat(0, 1)
	local stun = stun_min + (stun_max - stun_min) * random
	local damage = damage_min + (damage_max - damage_min) * (1 - random)

	-- Calculate the number of digits needed for the particle
	local stun_digits = string.len(tostring(math.floor(stun))) + 1
	local damage_digits = string.len(tostring(math.floor(damage))) + 1


	-- Damage particle
	ParticleManager:SetParticleControl(particle, 1, Vector(9,damage,4)) -- prefix symbol, number, postfix symbol
	ParticleManager:SetParticleControl(particle, 2, Vector(2,damage_digits,0)) -- duration, digits, 0

	-- Stun particle
	ParticleManager:SetParticleControl(particle, 3, Vector(8,stun,0)) -- prefix symbol, number, postfix symbol
	ParticleManager:SetParticleControl(particle, 4, Vector(2,stun_digits,0)) -- duration, digits, 0
	ParticleManager:ReleaseParticleIndex(particle)

    -- Apply the stun duration
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun * (1 - target:GetStatusResistance())})

    -- Precache damage values
    local damage_table = {
		attacker = caster,
		victim = target,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}

    ApplyDamage(damage_table)

    caster:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

    -- Create Shard Illusion on impact
    if caster and caster:HasShard() then
        local illusions = CreateIllusions(caster, caster, {}, 1, caster:GetHullRadius(), false, true)
        local shard_illusion = illusions[1]
			    		
        if shard_illusion ~= nil then

            FindClearSpaceForUnit(shard_illusion, target_location, true)

            shard_illusion.IsMainHero = function() return false end
            shard_illusion.IsRealHero = function() return false end
            
            local shard_duration = self:GetSpecialValueFor("shard_duration")
            shard_illusion:AddNewModifier( caster, ability, "modifier_illusion", { duration = shard_duration } )
            -- Phantasm damage and damage taken are the same on all levels
            shard_illusion:AddNewModifier( caster, ability, "modifier_chaos_knight_phantasm_illusion", { duration = shard_duration } )

        end
	end
end
