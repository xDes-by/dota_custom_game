LinkLuaModifier( "modifier_sniper_granade_debuff" , "heroes/hero_sniper/sniper_granade/sniper_granade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_flame", "heroes/hero_sniper/sniper_granade/sniper_granade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_flame_thinker", "heroes/hero_sniper/sniper_granade/sniper_granade", LUA_MODIFIER_MOTION_NONE )

sniper_granade = class({})

function sniper_granade:GetCooldown(level)
	local caster = self:GetCaster()
	local abil = caster:FindAbilityByName("npc_dota_hero_sniper_int7")
		if abil ~= nil	then 
		 return self.BaseClass.GetCooldown( self, level ) /2
		else
		return self.BaseClass.GetCooldown( self, level )
	end		
end

function sniper_granade:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function sniper_granade:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() /100)
end

function sniper_granade:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function sniper_granade:OnSpellStart()
    if not IsServer() then return end
	local caster = self:GetCaster()
    local point = self:GetCursorPosition() + 5
    local caster_loc = self:GetCaster():GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_ATTACK_1)
    local cast_direction = (point - self:GetCaster():GetOrigin()):Normalized()

    local info = {
        Source = self:GetCaster(),
        Ability = self,
        vSpawnOrigin = self:GetCaster():GetOrigin(),
        bDeleteOnHit = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        EffectName = "particles/units/heroes/hero_gob_squad/rocket_blast.vpcf",
        fDistance = 1500,
        fStartRadius = 100,
        fEndRadius =150,
        vVelocity = cast_direction * 2500,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        bProvidesVision = true,
        iVisionRadius = 400,
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    }
    self:GetCaster():EmitSound("Ability.Assassinate")
    ProjectileManager:CreateLinearProjectile(info)
	
	
end

function sniper_granade:OnProjectileHit( target, vLocation )
    if not IsServer() then return end
    if target ~= nil then
		point = target:GetOrigin()
        local base_dmg = self:GetSpecialValueFor("damage")
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
        local duration = self:GetSpecialValueFor("duration")
		damage_type = DAMAGE_TYPE_PHYSICAL
		self.ability_proc = "sniper_shrapnel_lua"
		
		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_str10")
		if abil ~= nil	then 
		base_dmg = caster:GetStrength()
		end
		
		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_int6")
		if abil ~= nil	then 
		base_dmg = base_dmg + (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() )/3
		end		
		
		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_int11")
		if abil ~= nil	then 
			local ability = self:GetCaster():FindAbilityByName( self.ability_proc )
				if ability~=nil and ability:GetLevel()>=1 then
					ability:OnSpellStart()
				end
		end
		
		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_int8")
		if abil ~= nil	then 
			CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_flame_thinker", -- modifier name
			{ duration = duration }, -- kv
			point,
			caster:GetTeamNumber(),
			false
		)
		end
		

		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_str7")
		if abil ~= nil then 
		duration = 10
		end
		
		
		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_int9")
		if abil ~= nil	then 
		damage_type = DAMAGE_TYPE_MAGICAL
		end		
		
		
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gob_squad/rocket_blast_explosion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin()+Vector(0,0,75))
        ParticleManager:SetParticleControl(particle, 1, Vector(300,0,0))
        target:EmitSound("Hero_Techies.LandMine.Detonate")
        AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 300, 1, false )
        local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
        for i,unit in ipairs(units) do
            ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = self:GetCaster():GetAttackDamage() + base_dmg, damage_type = damage_type })
            unit:AddNewModifier( self:GetCaster(), self, "modifier_sniper_granade_debuff", { duration = duration } )
        end 
    end
    return true
end

modifier_sniper_granade_debuff = class({}) 

function modifier_sniper_granade_debuff:IsPurgable() return true end

function modifier_sniper_granade_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_sniper_granade_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("movespeed_slow") 
end



------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

modifier_flame_thinker = class({})



--------------------------------------------------------------------------------
function modifier_flame_thinker:IsHidden()
	return true
end

function modifier_flame_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.burn_interval = 0.5
	local interval = self.burn_interval

	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, true )

		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}

		self:StartIntervalThink( interval )

		self:PlayEffects()
	end
end

function modifier_flame_thinker:OnDestroy()
	if IsServer() then

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_flame_thinker:OnIntervalThink()
	-- find units in radius
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
		-- apply damage
		self.damageTable.victim = enemy
		self.damageTable.damage = self.damage
		ApplyDamage( self.damageTable )
		
	--[[	enemy:AddNewModifier(
			self.caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_flame", -- modifier name
			{
				duration = 2,
				interval = 0.5,
				damage = self.damage * self.burn_interval,
				damage_type = self.abilityDamageType,
			} -- kv
		)]]
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_flame_thinker:PlayEffects()
	-- Get Resources
	local particle_cast =  "particles/dk.vpcf"
	self.sound_cast =  "hero_jakiro.macropyre"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( self.sound_cast, self:GetParent() )
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

modifier_flame = class({})

function modifier_flame:IsHidden()
	return false
end

function modifier_flame:IsDebuff()
	return true
end

function modifier_flame:IsStunDebuff()
	return false
end

function modifier_flame:IsPurgable()
	return false
end

function modifier_flame:OnCreated( kv )
	if not IsServer() then return end
	local interval = kv.interval
	local damage = kv.damage
	local damage_type = kv.damage_type
	
	
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	 ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )
end

function modifier_flame:OnRefresh( kv )
	if not IsServer() then return end
	local damage = kv.damage
	local damage_type = kv.damage_type

	-- update damage
	self.damageTable.damage = damage
	self.damageTable.damage_type = damage_type
end

function modifier_flame:OnRemoved()
end

function modifier_flame:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_flame:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_flame:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_flame:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
