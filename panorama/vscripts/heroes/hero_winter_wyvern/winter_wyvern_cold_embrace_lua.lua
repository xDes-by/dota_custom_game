
LinkLuaModifier( "modifier_winter_wyvern_cold_embrace_lua", "heroes/hero_winter_wyvern/modifier_winter_wyvern_cold_embrace_lua", LUA_MODIFIER_MOTION_NONE )

winter_wyvern_cold_embrace_lua = class({})

function winter_wyvern_cold_embrace_lua:GetCooldown(nLevel)
	local caster = self:GetCaster()
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	if caster and caster:HasShard() then
		cooldown = cooldown - self:GetSpecialValueFor("shard_cooldown")
	end
	return cooldown
end

function winter_wyvern_cold_embrace_lua:CastFilterResultTarget( hTarget )
	if not IsServer() then return end

	if PlayerResource:IsDisableHelpSetForPlayerID(hTarget:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()) then 	
		return UF_FAIL_DISABLE_HELP
	end
	
	local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	
	return nResult
end

function winter_wyvern_cold_embrace_lua:OnSpellStart()
	if not IsServer() then return end
	
	local caster 					= self:GetCaster();
	local target 					= self:GetCursorTarget();
	local ability 					= self;
	local duration 					= self:GetSpecialValueFor("duration");

	if target and not target:IsNull() then 		
		caster:EmitSound("Hero_Winter_Wyvern.ColdEmbrace.Cast");

		local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_start.vpcf", caster)
		local cold_embrace_start_particle = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT, caster);
		ParticleManager:SetParticleControl(cold_embrace_start_particle, 0, caster:GetAbsOrigin());
		ParticleManager:SetParticleControl(cold_embrace_start_particle, 1, caster:GetAbsOrigin());
		ParticleManager:ReleaseParticleIndex(cold_embrace_start_particle);

		target:AddNewModifier(caster, ability, "modifier_winter_wyvern_cold_embrace_lua", {duration = duration});
	end
end

function winter_wyvern_cold_embrace_lua:CastProjectile(keys)

	local target = keys.target
    local caster = self:GetCaster()
	
	local radius = self:GetSpecialValueFor("shard_radius")
	local damage = self:GetSpecialValueFor("shard_damage")
	local slow_duration = self:GetSpecialValueFor("shard_slow_duration")

	if caster:HasTalent("special_bonus_unique_winter_wyvern_7") then		-- +100 Splinter Blast Damage
		damage = damage + caster:FindTalentValue("special_bonus_unique_winter_wyvern_7")
	end

	local enemies = FindUnitsInRadius(
		caster:GetTeam(),
		target:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	);

	caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");

	for _,enemy in pairs(enemies) do 
		if enemy and enemy ~= target and enemy:IsAlive() then
			local extra_data = {
				damage 						= damage,			-- 340 max splinter blast damage + 100 talent damage
				slow_duration 				= slow_duration,
			}

			local projectile =
			{
				Target 				= enemy,
				Source 				= target,
				Ability 			= self,
				EffectName 			= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
				iMoveSpeed			= 600,
				vSourceLoc 			= target:GetAbsOrigin(),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 10,
				bProvidesVision 	= true,
				iVisionRadius 		= 400,
				iVisionTeamNumber 	= caster:GetTeamNumber(),
				ExtraData = extra_data
			}

			ProjectileManager:CreateTrackingProjectile(projectile);
		end
	end
    	
end

function winter_wyvern_cold_embrace_lua:OnProjectileHit_ExtraData(target, location, ExtraData)
	
    local caster = self:GetCaster()
	if target and not target:IsNull() then
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = DAMAGE_TYPE_MAGICAL})
		target:AddNewModifier(caster, self, "modifier_winter_wyvern_splinter_blast_slow", {duration = ExtraData.slow_duration})
		target:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Target")
		
		if caster:HasTalent("special_bonus_unique_winter_wyvern_4") then		-- stun on impact
			local stun_duration = caster:FindTalentValue("special_bonus_unique_winter_wyvern_4")
			target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
		end
	end
end

