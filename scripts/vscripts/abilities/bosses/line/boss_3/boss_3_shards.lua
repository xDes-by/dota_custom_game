LinkLuaModifier("modifier_tusk_ice_shards_dummy", "abilities/bosses/line/boss_3/boss_3_shards",LUA_MODIFIER_MOTION_NONE)

boss_3_shards = class({})

function boss_3_shards:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
	
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * 1000
	local rotation_rate = 360 / 8
			
	for i = 1, 8 do
		line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, 0), line_pos)
		self:CreateShard(line_pos)
	end	
end	
	
function boss_3_shards:CreateShard(point)	
	local caster = self:GetCaster()
    local length = (point-caster:GetAbsOrigin()):Length2D() - self:GetSpecialValueFor("shard_distance")
    local direction = (point-caster:GetAbsOrigin()):Normalized()
    direction.z = 0
    self.direction = direction
  --  self.dummy = CreateUnitByName("npc_dummy_unit",caster:GetAbsOrigin(),false,nil,nil,caster:GetTeamNumber())
  --  self.dummy:AddNewModifier(caster,self,"modifier_tusk_ice_shards_dummy",{})
    local projectile_table = {
        Ability = self,
        EffectName = "particles/units/heroes/hero_tusk/tusk_ice_shards_projectile.vpcf",
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = length,
        fStartRadius = self:GetSpecialValueFor("shard_width"),
        fEndRadius = self:GetSpecialValueFor("shard_width"),
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 3,
        bDeleteOnHit = false,
        vVelocity = direction * self:GetSpecialValueFor("shard_speed"),
        bProvidesVision = true,
        iVisionRadius = self:GetSpecialValueFor("shard_width"),
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    ProjectileManager:CreateLinearProjectile(projectile_table)

    caster:EmitSound("Hero_Tusk.IceShards.Projectile")
end


function boss_3_shards:OnProjectileThink(vLocation)
  --  self.dummy:SetAbsOrigin(vLocation)
end

function boss_3_shards:OnProjectileHit(hTarget, vLocation)
    if hTarget then
        local damage_table = {
            victim = hTarget,
            attacker = self:GetCaster(),
            ability = self,
            damage = hTarget:GetMaxHealth()/100*self:GetSpecialValueFor("shard_damages"),
            damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
        }
        ApplyDamage(damage_table  )
    else
        self:GetCaster():StopSound("Hero_Tusk.IceShards.Projectile")
        self:GetCaster():EmitSound("Hero_Tusk.IceShards")
     --   UTIL_Remove(self.dummy)
        local shard_distance = self:GetSpecialValueFor("shard_distance")
        local shard_angle_step = self:GetSpecialValueFor("shard_angle_step")
        self.shards = {}
        self.blockers = {}
        -- 7 shards, from -120 to 120
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards.vpcf",PATTACH_WORLDORIGIN,self:GetCaster())
        ParticleManager:SetParticleControl(particle,0,Vector(self:GetSpecialValueFor("shard_duration"),0,0))
        for i=0,3 do
            local angle = -120 + i * shard_angle_step
            local direction = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), self.direction)
            local position = GetGroundPosition(vLocation + direction * shard_distance,nil)
        --    self.blockers[i] = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = position})
            ParticleManager:SetParticleControl(particle,i+1,position)
        end
     --   self:SetContextThink("think_duration",function() self:RemoveShards() end,self:GetSpecialValueFor("shard_duration"))
    end
end

-- function boss_3_shards:RemoveShards()
    -- for i=0,3 do
        -- UTIL_Remove(self.blockers[i])
    -- end
    -- self.blockers = nil
-- end

-----------------------------------------------------------------------

modifier_tusk_ice_shards_dummy = class({})

function modifier_tusk_ice_shards_dummy:IsPermanent() return true end

function modifier_tusk_ice_shards_dummy:CheckState()
    return {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end