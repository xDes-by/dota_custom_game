--[[Author: Pizzalol
	Date: 21.04.2015.
	Creates a dummy with a dummy deafening spell
	The dummy acts as the projectile while following the particle projectile]]

LinkLuaModifier( "modifier_spectre_deafening_blast_burn_lua", "heroes/hero_spectre/spectre_haunt/deafening_blast", LUA_MODIFIER_MOTION_NONE )

spectre_deafening_blast_lua = class({})

function spectre_deafening_blast_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function spectre_deafening_blast_lua:GetCastRange(level)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str11") then
        return self:GetSpecialValueFor("travel_distance") + 1000
    end
    return self:GetSpecialValueFor("travel_distance")
end
function spectre_deafening_blast_lua:GetCooldown(level)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int10") then 
        return self.BaseClass.GetCooldown( self, level ) / 2
    end
    return self.BaseClass.GetCooldown( self, level )		
end
function spectre_deafening_blast_lua:OnSpellStart()
    local caster = self:GetCaster()
    local caster_location = caster:GetAbsOrigin()
    local target_point = self:GetCursorPosition()

    -- Ability and projectile variables
    local knockback_duration = 1
    local travel_distance = self:GetSpecialValueFor("travel_distance")
    local travel_speed = self:GetSpecialValueFor("travel_speed") 
    local radius_start = self:GetSpecialValueFor("radius_start") 
    local radius_end = self:GetSpecialValueFor("radius_end") 
    local dummy_ability_name = "invoker_deafening_blast_dummy_datadriven"
    local projectile_name = "particles/invoker_deafening_blast.vpcf"
    local direction = (target_point - caster_location):Normalized()
    if caster:FindAbilityByName("npc_dota_hero_spectre_str11") then
        travel_distance = travel_distance + 1000
    end

    -- Create the dummy
    local deafening_dummy = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeamNumber())
    deafening_dummy:AddAbility(dummy_ability_name)

    -- Set up the dummy ability
    local dummy_ability = deafening_dummy:FindAbilityByName(dummy_ability_name)
    dummy_ability:SetLevel(1)

    -- Initialize the dummy calculation variables
    local distance_traveled = 0
    local dummy_speed = travel_speed * 1/30


    -- Create projectile
    local projectile_table =
    {
        EffectName = projectile_name,
        Ability = dummy_ability,
        vSpawnOrigin = caster_location,
        vVelocity = direction * travel_speed,
        fDistance = travel_distance,
        fStartRadius = radius_start,
        fEndRadius = radius_end,
        Source = deafening_dummy,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = self:GetAbilityTargetTeam(),
        iUnitTargetFlags = self:GetAbilityTargetFlags(),
        iUnitTargetType = self:GetAbilityTargetType()
    }
    ProjectileManager:CreateLinearProjectile( projectile_table )

    -- Move the dummy
    Timers:CreateTimer(function()
        -- If the dummy traveled the whole distance then kill it
        if distance_traveled < travel_distance then
            -- Otherwise keep track of the distance traveled and set the new position
            local dummy_location = deafening_dummy:GetAbsOrigin() + direction * dummy_speed
            deafening_dummy:SetAbsOrigin(dummy_location)
            distance_traveled = distance_traveled + dummy_speed

            return 1/30
        else
            -- Remove the dummy after the knockback duration to allow all the modifiers to be applied
            Timers:CreateTimer(knockback_duration,function()
                deafening_dummy:RemoveSelf()
            end)
        end
    end)
    EmitSoundOn("Hero_Spectre.Reality", caster)
end

    
    --[[Author: Pizzalol
        Date: 21.04.2015.
        Triggers upon hitting a target
        Deals damage depending on Exort and applies the knockback modifier depending on Quas]]
    function deafening_blast_hit( keys )
        local caster = keys.caster -- Dummy
        local caster_owner = caster:GetOwner() -- Hero
        local target = keys.target
        local ability = keys.ability
        local owner_ability = caster_owner:FindAbilityByName("spectre_deafening_blast_lua")
    
        -- Ability variables
        local damage = owner_ability:GetLevelSpecialValueFor("damage", owner_ability:GetLevel() -1) 
        if caster_owner:FindAbilityByName("npc_dota_hero_spectre_str11") then
            damage = damage + caster_owner:GetStrength()
        end
        if caster_owner:FindAbilityByName("npc_dota_hero_spectre_int7") then
            damage = damage + caster_owner:GetIntellect() * 2
        end
        if caster_owner:FindAbilityByName("npc_dota_hero_spectre_agi9") then
            if caster_owner:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
                damage = damage + caster_owner:GetStrength() * 2
            end
            if caster_owner:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
                damage = damage + caster_owner:GetAgility() * 2
            end
            if caster_owner:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
                damage = damage + caster_owner:GetIntellect() * 2
            end
        end
        if caster_owner:HasModifier("modifier_step_buff") then
            damage = damage * 2
        end

        local knockback_duration = owner_ability:GetLevelSpecialValueFor("disarm_duration", 1) 
    
        -- Apply the knockback modifier
        -- ability:ApplyDataDrivenModifier(caster_owner, target, "modifier_spectre_deafening_blast_burn_lua", {duration = knockback_duration, ability = owner_ability}) 
        target:AddNewModifier(caster_owner, owner_ability, "modifier_spectre_deafening_blast_burn_lua", {duration = knockback_duration, ability = owner_ability:entindex(), hero = caster_owner:entindex(), damage = damage})
        -- Initialize the damage table and deal the damage
        local damage_table = {}
        damage_table.attacker = caster_owner
        damage_table.victim = target
        damage_table.ability = owner_ability
        damage_table.damage_type = owner_ability:GetAbilityDamageType() 
        damage_table.damage = damage
        ApplyDamage(damage_table)
    end


    modifier_spectre_deafening_blast_burn_lua = class({})

    function modifier_spectre_deafening_blast_burn_lua:IsPurgable()
        return true
    end

    function modifier_spectre_deafening_blast_burn_lua:IsDebuff()
        return true
    end

    function modifier_spectre_deafening_blast_burn_lua:OnCreated(kv)
        if IsServer() then
            self.hero = EntIndexToHScript( kv.hero )
            self.ability = EntIndexToHScript( kv.ability )
            self.damage = kv.damage
        end
        self:StartIntervalThink(1)
    end

    function modifier_spectre_deafening_blast_burn_lua:OnIntervalThink()
        if not IsServer() then return end
        local damage_table = {}
        damage_table.attacker = self:GetCaster()
        damage_table.victim = self:GetParent()
        damage_table.ability = self.ability
        damage_table.damage_type = self.ability:GetAbilityDamageType() 
        damage_table.damage = self.damage / 10
    
        ApplyDamage(damage_table)
    end