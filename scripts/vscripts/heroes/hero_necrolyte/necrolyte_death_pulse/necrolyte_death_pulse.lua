LinkLuaModifier( "modifier_necrolyte_death_pulse_intrinsic_lua", "heroes/hero_necrolyte/necrolyte_death_pulse/modifier_necrolyte_death_pulse_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )
necrolyte_death_pulse_lua = class({})

function necrolyte_death_pulse_lua:GetAbilityTextureName()
	return "necrolyte_death_pulse"
end

function necrolyte_death_pulse_lua:GetIntrinsicModifierName()
	return "modifier_necrolyte_death_pulse_intrinsic_lua"
end
function necrolyte_death_pulse_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function necrolyte_death_pulse_lua:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end

function necrolyte_death_pulse_lua:GetBehavior()
    local caster = self:GetCaster()
    if caster:FindAbilityByName("npc_dota_hero_necrolyte_agi7") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
    end
end

function necrolyte_death_pulse_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int9") then
		return self.BaseClass.GetCooldown( self, level ) - 2
	end
end

function necrolyte_death_pulse_lua:GetAOERadius()
	return 600
end

function necrolyte_death_pulse_lua:OnSpellStart(location, radius)
	if not IsServer() then return end

	local caster = self:GetCaster()
	if caster:FindAbilityByName("npc_dota_hero_necrolyte_agi7") then
		location = location or self:GetCursorPosition()
		radius = radius or self:GetSpecialValueFor("radius")
	else
		location = location or caster:GetAbsOrigin()
		radius = radius or self:GetSpecialValueFor("radius")
	end
	local damage = self:GetSpecialValueFor("damage")
	local base_heal = self:GetSpecialValueFor("base_heal")
	if caster:FindAbilityByName("npc_dota_hero_necrolyte_str7") then
		base_heal = base_heal + caster:GetMaxHealth() * 0.1
	end
	local sec_heal_pct = self:GetSpecialValueFor("sec_heal_pct")
	local enemy_speed = self:GetSpecialValueFor("enemy_speed")
	local ally_speed = self:GetSpecialValueFor("ally_speed")

	caster:EmitSound("Hero_Necrolyte.DeathPulse")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
		-- Enemy projectile
		local enemy_projectile =
			{
				Target = caster,
				Source = enemy,
				Ability = self,
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = enemy_speed,
				flExpireTime = GameRules:GetGameTime() + 60,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData = {sec_heal_pct = sec_heal_pct, radius = radius, ally_speed = ally_speed}
			}

		-- Create the projectile
		ProjectileManager:CreateTrackingProjectile(enemy_projectile)
	end

	local allies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		-- Ally projectile
		local ally_projectile =
			{
				Target = ally,
				Source = caster,
				Ability = self,
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = ally_speed,
				flExpireTime = GameRules:GetGameTime() + 60,
				--	iVisionRadius = vision_radius,
				--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData = {base_heal = base_heal}
			}
		-- Create the projectile
		ProjectileManager:CreateTrackingProjectile(ally_projectile)
	end
end

function necrolyte_death_pulse_lua:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		local caster = self:GetCaster()

		-- Base Heal
		if extraData.base_heal then
			target:Heal(extraData.base_heal, self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, extraData.base_heal, nil)
			return
		end

		local caster_loc = caster:GetAbsOrigin()

		if not extraData.radius then
			local heal = target:GetMaxHealth() * (extraData.sec_heal_pct / 100)
			target:Heal(heal, self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
		end
		--Essence dilation
		if extraData.radius then
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, extraData.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,ally in pairs(allies) do
				-- Ally projectile
				local ally_projectile =
					{
						Target = ally,
						Source = caster,
						Ability = self,
						EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
						bDodgeable = false,
						bProvidesVision = false,
						iMoveSpeed = extraData.ally_speed,
						flExpireTime = GameRules:GetGameTime() + 60,
						--	iVisionRadius = vision_radius,
						--	iVisionTeamNumber = caster:GetTeamNumber(),
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
						ExtraData = {sec_heal_pct = extraData.sec_heal_pct, ally_speed = extraData.ally_speed}
					}

				-- Create the projectile
				ProjectileManager:CreateTrackingProjectile(ally_projectile)
			end
			return nil
		end
	end
end

function necrolyte_death_pulse_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end