ability_npc_snow_boss = class({})

LinkLuaModifier("modifier_ability_npc_snow_boss", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_ability_npc_snow_boss_second_phase", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tiny_phase1", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tiny_phase2", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tiny_phase3", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tiny_phase3_strike", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tiny_phase4", "abilities/bosses/snow/ability_npc_snow_boss", LUA_MODIFIER_MOTION_NONE)

function ability_npc_snow_boss:OnSpellStart()
    local direction = self:GetCaster():GetForwardVector()
    local pos = self:GetCaster():GetAbsOrigin()
    for i=1,3 do 
        local dir = RotatePosition( Vector(0,0,0), QAngle( 0, 120 * i, 0 ), direction )
        local unit = CreateUnitByName("npc_snow_boss_feeld_caster", pos + dir * 600, true, nil, nil, self:GetCaster():GetTeamNumber())
        unit:AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_snow_boss", {duration = 5.6})
    end
end

function ability_npc_snow_boss:GetIntrinsicModifierName()
    return "modifier_ability_npc_snow_boss_second_phase"
end

function ability_npc_snow_boss:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end

	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = 50000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = hTarget:GetMaxHealth() * 0.3,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

    local p = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_persona/mirana_starstorm.vpcf", PATTACH_POINT_FOLLOW, hTarget)
    ParticleManager:SetParticleControl(p, 0, hTarget:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p)

	-- stun
	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 5 } -- kv
	)
	EmitSoundOn( "Hero_Mirana.ArrowImpact", hTarget )
	return true
end

modifier_ability_npc_snow_boss = class({})
--Classifications template
function modifier_ability_npc_snow_boss:IsHidden()
    return true
end

function modifier_ability_npc_snow_boss:IsDebuff()
    return false
end

function modifier_ability_npc_snow_boss:IsPurgable()
    return false
end

function modifier_ability_npc_snow_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_snow_boss:IsStunDebuff()
    return false
end

function modifier_ability_npc_snow_boss:RemoveOnDeath()
    return true
end

function modifier_ability_npc_snow_boss:DestroyOnExpire()
    return true
end

function modifier_ability_npc_snow_boss:OnCreated()
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.pos = self.parent:GetAbsOrigin()
    self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_snow_boss:OnIntervalThink()
    local pos = self.pos + RandomVector(RandomFloat(100, 400))
    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden_persona/cm_persona_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(p, 0, pos)
    ParticleManager:ReleaseParticleIndex(p)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),pos,nil,300,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,0,false)
    for _,unit in pairs(enemies) do
        ApplyDamage({
            victim = unit,
            attacker = self.parent,
            damage = unit:GetHealth() * 0.2,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
end

function modifier_ability_npc_snow_boss:OnDestroy()
    UTIL_Remove(self.parent)
end

function modifier_ability_npc_snow_boss:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end

modifier_ability_npc_snow_boss_second_phase = class({})
--Classifications template
function modifier_ability_npc_snow_boss_second_phase:IsHidden()
    return true
end

function modifier_ability_npc_snow_boss_second_phase:IsDebuff()
    return false
end

function modifier_ability_npc_snow_boss_second_phase:IsPurgable()
    return false
end

function modifier_ability_npc_snow_boss_second_phase:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_snow_boss_second_phase:IsStunDebuff()
    return false
end

function modifier_ability_npc_snow_boss_second_phase:RemoveOnDeath()
    return false
end

function modifier_ability_npc_snow_boss_second_phase:DestroyOnExpire()
    return true
end

function modifier_ability_npc_snow_boss_second_phase:OnCreated()
    self.secon_phase = false
end

function modifier_ability_npc_snow_boss_second_phase:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_ability_npc_snow_boss_second_phase:GetMinHealth()
    if not self.secon_phase then
        return self:GetParent():GetMaxHealth() / 2.5
    end
end

function modifier_ability_npc_snow_boss_second_phase:OnTakeDamage(data)
    if data.unit ~= self:GetParent() then
        return
    end
    if not self.secon_phase and self:GetParent():GetHealth() <= self:GetParent():GetMaxHealth() / 2 then
        self.secon_phase = true
        data.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tiny_phase" .. RandomInt(1, 4), {})

        local playerid = data.attacker:GetPlayerOwnerID()
        local hero = data.attacker
        local tab = CustomNetTables:GetTableValue("player_pets", tostring(playerid))
        if tab then
            if tab.pet ~= nil then
                local ability = hero:FindAbilityByName(tab.pet)
                ability:StartCooldown(5)
            end
        end
    end
end

modifier_tiny_phase1 = class({})
--Classifications template
function modifier_tiny_phase1:IsHidden()
    return true
end

function modifier_tiny_phase1:IsDebuff()
    return true
end

function modifier_tiny_phase1:IsPurgable()
    return false
end

function modifier_tiny_phase1:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_tiny_phase1:IsStunDebuff()
    return false
end

function modifier_tiny_phase1:RemoveOnDeath()
    return true
end

function modifier_tiny_phase1:DestroyOnExpire()
    return true
end

function modifier_tiny_phase1:OnCreated()
    if not IsServer() then
        return
    end
    if self:GetAbility().modifier1 then
        self:GetAbility().modifier1:Destroy()
    end
    if self:GetAbility().modifier2 then
        self:GetAbility().modifier2:Destroy()
    end
    if self:GetAbility().modifier3 then
        self:GetAbility().modifier3:Destroy()
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 5})
    self:Destroy()
end

modifier_tiny_phase2 = class({})
--Classifications template
function modifier_tiny_phase2:IsHidden()
    return true
end

function modifier_tiny_phase2:IsDebuff()
    return true
end

function modifier_tiny_phase2:IsPurgable()
    return false
end

function modifier_tiny_phase2:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_tiny_phase2:IsStunDebuff()
    return false
end

function modifier_tiny_phase2:RemoveOnDeath()
    return true
end

function modifier_tiny_phase2:DestroyOnExpire()
    return true
end

function modifier_tiny_phase2:OnCreated()
    if not IsServer() then
        return
    end
    if self:GetAbility().modifier1 then
        self:GetAbility().modifier1:Destroy()
    end
    if self:GetAbility().modifier2 then
        self:GetAbility().modifier2:Destroy()
    end
    if self:GetAbility().modifier3 then
        self:GetAbility().modifier3:Destroy()
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_invulnerable", {duration = 3})

    self.counter = 0
    self:StartIntervalThink(1)
end

function modifier_tiny_phase2:OnIntervalThink()
	local caster = self:GetCaster()
	local origin = caster:GetOrigin() + RandomVector(2000)
	local point = self:GetCaster():GetAbsOrigin() 

	-- load data
	local projectile_name = "particles/econ/items/mirana/mirana_persona/mirana_persona_spell_arrow.vpcf"
	local projectile_speed = 857
	local projectile_distance = 4000
	local projectile_start_radius = 115
	local projectile_end_radius = 115


	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	local info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = origin,
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,

	}

    self.counter = self.counter + 1
	ProjectileManager:CreateLinearProjectile(info)

	EmitSoundOn( "Hero_Mirana.ArrowCast", self:GetCaster() )
    if self.counter == 8 then
        self:Destroy()
    end
end

modifier_tiny_phase3 = class({})
--Classifications template
function modifier_tiny_phase3:IsHidden()
    return true
end

function modifier_tiny_phase3:IsDebuff()
    return true
end

function modifier_tiny_phase3:IsPurgable()
    return false
end

function modifier_tiny_phase3:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_tiny_phase3:IsStunDebuff()
    return false
end

function modifier_tiny_phase3:RemoveOnDeath()
    return true
end

function modifier_tiny_phase3:DestroyOnExpire()
    return true
end

function modifier_tiny_phase3:OnCreated()
    if not IsServer() then
        return
    end
    if self:GetAbility().modifier1 then
        self:GetAbility().modifier1:Destroy()
    end
    if self:GetAbility().modifier2 then
        self:GetAbility().modifier2:Destroy()
    end
    if self:GetAbility().modifier3 then
        self:GetAbility().modifier3:Destroy()
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_invulnerable", {duration = 3})
    self.counter = 0
    self:StartIntervalThink(0.2)
end

function modifier_tiny_phase3:OnIntervalThink()
    self.counter = self.counter + 1
    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_tiny_phase3_strike", { duration = 1.7 }, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
    if self.counter == 15 then
        self:Destroy()
    end
end

modifier_tiny_phase3_strike = class({})

function modifier_tiny_phase3_strike:IsHidden()
	return true
end

function modifier_tiny_phase3_strike:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tiny_phase3_strike:OnCreated( kv )
	if IsServer() then
		self.radius = 175
		self:PlayEffects1()
	end
end

function modifier_tiny_phase3_strike:OnDestroy( kv )
	if IsServer() then
		-- Damage enemies
		local damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			-- damage = self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}

		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			damageTable.damage = enemy:GetMaxHealth() / 2
			ApplyDamage(damageTable)
		end

		-- Play effects
		self:PlayEffects2()

		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tiny_phase3_strike:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Charge"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_tiny_phase3_strike:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Ignite"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_tiny_phase4 = class({})
--Classifications template
function modifier_tiny_phase4:IsHidden()
    return true
end

function modifier_tiny_phase4:IsDebuff()
    return true
end

function modifier_tiny_phase4:IsPurgable()
    return false
end

function modifier_tiny_phase4:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_tiny_phase4:IsStunDebuff()
    return false
end

function modifier_tiny_phase4:RemoveOnDeath()
    return true
end

function modifier_tiny_phase4:DestroyOnExpire()
    return true
end

function modifier_tiny_phase4:OnCreated()
    if not IsServer() then
        return
    end
    if self:GetAbility().modifier1 then
        self:GetAbility().modifier1:Destroy()
    end
    if self:GetAbility().modifier2 then
        self:GetAbility().modifier2:Destroy()
    end
    if self:GetAbility().modifier3 then
        self:GetAbility().modifier3:Destroy()
    end
    self.damage = self:GetParent():GetMaxHealth() * FrameTime()
    self.pos = self:GetCaster():GetAbsOrigin() + RandomVector(500)
    local unit = CreateUnitByName("npc_dota_lich_ice_spire", self.pos, true, nil, nil, DOTA_TEAM_BADGUYS)
    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ivulnerable", {})
    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = 5})
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_invulnerable", {duration = 3})
    self.counter = 0
    self:StartIntervalThink(FrameTime())
end

function modifier_tiny_phase4:OnIntervalThink()
    local pos = self:GetParent():GetAbsOrigin()
    local direction = (self.pos - pos):Normalized() * 5
    FindClearSpaceForUnit(self:GetParent(), pos + direction, true)
    if self.counter > 5 / FrameTime() then
        self:Destroy()
    else
        self.counter = self.counter + 1
    end
end

