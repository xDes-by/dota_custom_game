luna_moon_glaive_lua = class({})

LinkLuaModifier( "modifier_luna_moon_glaive_lua", "heroes/hero_luna/luna_moon_glaive_lua/luna_moon_glaive_lua", LUA_MODIFIER_MOTION_NONE )

modifier_luna_moon_glaive_lua = {}

function luna_moon_glaive_lua:GetIntrinsicModifierName()
	return "modifier_luna_moon_glaive_lua"
end

function luna_moon_glaive_lua:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not IsServer() then return end
		self.bounces = self:GetSpecialValueFor( "bounces" )
		self.range = self:GetSpecialValueFor( "range" )
		self.reduction = self:GetSpecialValueFor( "damage_reduction_percent" )

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_luna_agi10")
	if abil ~= nil then 
		self.bounces = self.bounces + 5
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_luna_agi9")
	if abil ~= nil then 
		self.reduction = self.reduction - 16
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_luna_agi_last") ~= nil then
		self.reduction = 1
	end

	if hTarget then
		local damageTable = {
			victim 			= hTarget,
			damage 			= ExtraData.damage * ((100 - self.reduction) * 0.01) ^ (ExtraData.bounces + 1),
			damage_type		= DAMAGE_TYPE_PHYSICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, -- IMBAfication: Waning Gibbous
			attacker 		= self:GetCaster(),
			ability 		= self
		}

		damage_dealt = ApplyDamage(damageTable)
		
		if not self.target_tracker then
			self.target_tracker = {}
		end

		if not self.target_tracker[ExtraData.record] then
			self.target_tracker[ExtraData.record] = {}
		end
		
		self.target_tracker[ExtraData.record][hTarget:GetEntityIndex()] = true
	end
	
	ExtraData.bounces = ExtraData.bounces + 1
	
	local glaive_launched = false
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	
	if ExtraData.bounces < self.bounces and #enemies > 1 then
		local all_enemies_bounced = true
		
		for _, enemy in pairs(enemies) do
			if enemy ~= hTarget and not self.target_tracker[ExtraData.record][enemy:GetEntityIndex()] then -- Yes, hTarget can be nil here. That is intended
				all_enemies_bounced = false
				break
			end
		end
		
		for _, enemy in pairs(enemies) do
			if enemy ~= hTarget and (not self.target_tracker[ExtraData.record][enemy:GetEntityIndex()] or all_enemies_bounced) then -- Yes, hTarget can be nil here. Same as above
				local glaive =
				{
					Target 				= enemy,
					Ability 			= self,
					EffectName 			= "particles/units/heroes/hero_luna/luna_moon_glaive_bounce.vpcf",
					iMoveSpeed			= 900,
					vSourceLoc 			= vLocation,
					bDrawsOnMinimap 	= false,
					bDodgeable 			= false,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 10,
					bProvidesVision 	= false,

					ExtraData = {
						bounces			= ExtraData.bounces,
						record			= ExtraData.record,
						damage			= ExtraData.damage
					}
				}

				ProjectileManager:CreateTrackingProjectile(glaive)
				
				glaive_launched = true
				
				break
			end
		end
		
		if not glaive_launched then
			self.target_tracker[ExtraData.record] = nil
		end
	else
		self.target_tracker[ExtraData.record] = nil
	end
end

--------------------------
-- MOON GLAIVE MODIFIER --
--------------------------

function modifier_luna_moon_glaive_lua:IsHidden()	return true end

function modifier_luna_moon_glaive_lua:OnCreated()
	if not IsServer() then return end
			self.bounces = self:GetAbility():GetSpecialValueFor( "bounces" )
		self.range = self:GetAbility():GetSpecialValueFor( "range" )
		self.reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction_percent" )
end

function modifier_luna_moon_glaive_lua:OnRefresh()
	if not IsServer() then return end
	
	if not self.glaive_particle and self:GetAbility():IsTrained() then
		self.glaive_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_ambient_moon_glaive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.glaive_particle,	0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(self.glaive_particle, false, false, -1, false, false)
	end
end

function modifier_luna_moon_glaive_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_luna_moon_glaive_lua:GetModifierProcAttack_Feedback(keys)
	if not IsServer() then return end
	
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target and enemy == enemies[2] then
				local glaive =
				{
					Target 				= enemy,
					Source 				= keys.target,
					Ability 			= self:GetAbility(),
					EffectName 			= "particles/units/heroes/hero_luna/luna_moon_glaive_bounce.vpcf",
					iMoveSpeed			= 900,
					bDrawsOnMinimap 	= false,
					bDodgeable 			= false,
					bIsAttack 			= false,
					bVisibleToEnemies 	= true,
					bReplaceExisting 	= false,
					flExpireTime 		= GameRules:GetGameTime() + 10,
					bProvidesVision 	= false,

					ExtraData = {
						bounces			= 0,
						record			= keys.record, -- Will use this to attempt proper bounce logic
						damage			= keys.original_damage
					}
				}

				ProjectileManager:CreateTrackingProjectile(glaive)
			
			end
		end
	end
end