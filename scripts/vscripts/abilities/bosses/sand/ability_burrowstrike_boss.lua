ability_burrowstrike_boss = class({})

LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_ability_burrowstrike_boss", "abilities/bosses/sand/ability_burrowstrike_boss", LUA_MODIFIER_MOTION_NONE )

function ability_burrowstrike_boss:OnSpellStart()
	self.mod = self:GetCaster():FindModifierByName("modifier_ability_caustic_boss")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_burrowstrike_boss", {duration = 5})
end
--------------------------------------------------------------------------------
-- Projectile
function ability_burrowstrike_boss:OnProjectileHit( target, location )
	if not target then return end

	local duration = self:GetSpecialValueFor( "burrow_duration" )
	target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = duration })

	target:AddNewModifier(self:GetCaster(), self, "modifier_generic_knockback_lua", {duration = 0.52, z = 350, IsStun = true})

	self.mod:OnAttackLanded({target = target, attacker = self:GetCaster()})
	
	ApplyDamage({
		victim = target,
		attacker = self:GetCaster(),
		damage = 50000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	})
end







modifier_ability_burrowstrike_boss = class({})
--Classifications template
function modifier_ability_burrowstrike_boss:IsHidden()
    return true
end

function modifier_ability_burrowstrike_boss:IsDebuff()
    return false
end

function modifier_ability_burrowstrike_boss:IsPurgable()
    return false
end

function modifier_ability_burrowstrike_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_burrowstrike_boss:IsStunDebuff()
    return false
end

function modifier_ability_burrowstrike_boss:RemoveOnDeath()
    return true
end

function modifier_ability_burrowstrike_boss:DestroyOnExpire()
    return true
end

function modifier_ability_burrowstrike_boss:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink( 1 )
    self:OnIntervalThink()
end

function modifier_ability_burrowstrike_boss:OnIntervalThink()
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1300,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for n,unit in pairs(units) do
        if unit ~= self.last_target then
            self.last_target = units[n]
            point = self.last_target:GetAbsOrigin()
			break
        end
    end
    if not self.last_target or units[1] == self.last_target then
        self:Destroy()
		return
    end
    local caster = self:GetCaster()

	local origin = caster:GetOrigin()

	local anim_time = 0.52

	local projectile_name = "particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf"
	local projectile_start_radius = 150
	local projectile_end_radius = projectile_start_radius
	local projectile_direction = (point-origin)
	projectile_direction.z = 0
	projectile_direction:Normalized()
	local projectile_speed = 2000
	local projectile_distance = (point-origin):Length2D()

	local info = {
		Source = caster,
		Ability = self:GetAbility(),
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	}
	ProjectileManager:CreateLinearProjectile(info)

	caster:AddNewModifier(caster,self,"modifier_sand_king_burrowstrike_lua",{duration = anim_time, pos_x = point.x, pos_y = point.y, pos_z = point.z,})

	self:PlayEffects( origin, point )  
end

function modifier_ability_burrowstrike_boss:PlayEffects( origin, target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Ability.SandKing_BurrowStrike", self:GetCaster() )
end






modifier_sand_king_burrowstrike_lua = class({})

function modifier_sand_king_burrowstrike_lua:IsHidden()
	return true
end

function modifier_sand_king_burrowstrike_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sand_king_burrowstrike_lua:OnCreated( kv )
    if not IsServer() then
        return
    end
	self.point = Vector( kv.pos_x, kv.pos_y, kv.pos_z )
	self:StartIntervalThink( self:GetDuration()/2 )
end

function modifier_sand_king_burrowstrike_lua:OnDestroy( kv )

end

function modifier_sand_king_burrowstrike_lua:OnIntervalThink()
	FindClearSpaceForUnit( self:GetParent(), self.point, true )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_sand_king_burrowstrike_lua:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
	}
end