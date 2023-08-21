death_prophet_crypt_swarm_bh = class({})

function death_prophet_crypt_swarm_bh:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	local direction = (position - caster:GetAbsOrigin()):Normalized()
	-- if caster:HasTalent("special_bonus_unique_death_prophet_crypt_swarm_2") then
	-- 	direction = caster:GetForwardVector()
	-- end
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("range")
	local width = self:GetSpecialValueFor("start_radius")
	local endWidth = self:GetSpecialValueFor("end_radius")
	
	self.projectiles = self.projectiles or {}
	local proj = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf"

    local directions = {
        caster:GetForwardVector()  -- Original direction
    }
    if self:GetCaster():FindAbilityByName("npc_dota_hero_death_prophet_str6") then
        table.insert(directions, RotatePosition(Vector(0, 0, 0), QAngle(0, 40, 0), caster:GetForwardVector()))
        table.insert(directions, RotatePosition(Vector(0, 0, 0), QAngle(0, -40, 0), caster:GetForwardVector()))
    end
    for _, direction in pairs(directions) do
        local info = {
            Ability = self,
            EffectName = "",
            vSpawnOrigin = caster:GetAbsOrigin(),
            fDistance = distance,
            fStartRadius = width,
            fEndRadius = width,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            bDeleteOnHit = false,
            vVelocity = direction * speed,
            bProvidesVision = true,
            iVisionRadius = self:GetSpecialValueFor("vision_aoe"),
            iVisionTeamNumber = caster:GetTeamNumber(),
        }
        local id = ProjectileManager:CreateLinearProjectile(info)
        local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( fx, 0, caster:GetAbsOrigin() )
        ParticleManager:SetParticleControl( fx, 1, direction * speed )
        ParticleManager:SetParticleControl( fx, 2, Vector(endWidth, width, endWidth) )
        self.projectiles[id] = fx
    end
	caster:EmitSound("Hero_DeathProphet.CarrionSwarm")
end

function death_prophet_crypt_swarm_bh:OnProjectileHitHandle( target, position, id )
	if target and not target:TriggerSpellAbsorb(self) then
		local caster = self:GetCaster()
		-- if caster:HasTalent("special_bonus_unique_death_prophet_crypt_swarm_1") then
		-- 	target:AddNewModifier( caster, self, "modifier_death_prophet_crypt_swarm_talent", {duration = caster:FindTalentValue("special_bonus_unique_death_prophet_crypt_swarm_1", "duration")})
		-- else
			
		-- end
        local damage = self:GetSpecialValueFor("damage")
        if self:GetCaster():FindAbilityByName("npc_dota_hero_death_prophet_agi7") then
            damage = damage + self:GetCaster():GetAgility() * 0.75
        end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_death_prophet_str9") then
            damage = damage + self:GetCaster():GetStrength() * 0.75
        end
        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        })
		target:EmitSound("Hero_DeathProphet.CarrionSwarm.Damage")
	elseif id then
		ParticleManager:DestroyParticle(self.projectiles[id], false)
		self.projectiles[id] = nil
	end
end

modifier_death_prophet_crypt_swarm_talent = class({})
LinkLuaModifier( "modifier_death_prophet_crypt_swarm_talent", "heroes/hero_death_prophet/death_prophet_crypt_swarm_bh/death_prophet_crypt_swarm_bh", LUA_MODIFIER_MOTION_NONE )

-- if IsServer() then
-- 	function modifier_death_prophet_crypt_swarm_talent:OnCreated()
-- 		self.tick = self:GetRemainingTime() / self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_crypt_swarm_1", "duration")
-- 		self.damage = self:GetSpecialValueFor("damage") / self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_crypt_swarm_1", "duration")
-- 		self.lifesteal = 1
-- 		if not self:GetParent():IsRoundNecessary() then
-- 			self.lifesteal = 0.25
-- 		end
-- 		self:StartIntervalThink(self.tick)
-- 	end
	
-- 	function modifier_death_prophet_crypt_swarm_talent:OnRefresh()
-- 		if self.tick - self:GetRemainingTime() / self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_crypt_swarm_1", "duration") > 0.01 then
-- 			self.tick = self:GetRemainingTime() / self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_crypt_swarm_1", "duration")
-- 			self:StartIntervalThink( self.tick )
-- 		end
-- 		self.damage = self:GetSpecialValueFor("damage") / self:GetCaster():FindTalentValue("special_bonus_unique_death_prophet_crypt_swarm_1", "duration")
-- 		self.lifesteal = 1
-- 		if not self:GetParent():IsRoundNecessary() then
-- 			self.lifesteal = 0.25
-- 		end
-- 	end
	
-- 	function modifier_death_prophet_crypt_swarm_talent:OnIntervalThink()
-- 		local caster = self:GetCaster()
-- 		local ability = self:GetAbility()
-- 		local damage = ability:DealDamage( caster, self:GetParent(), self.damage )
-- 		caster:HealEvent( damage * self.lifesteal, ability, caster )
-- 	end
-- end

-- function modifier_death_prophet_crypt_swarm_talent:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_MULTIPLE
-- end