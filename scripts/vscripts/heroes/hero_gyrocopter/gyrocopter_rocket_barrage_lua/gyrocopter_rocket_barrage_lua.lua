
LinkLuaModifier("modifier_gyrocopter_rocket_barrage_lua", "heroes/hero_gyrocopter/gyrocopter_rocket_barrage_lua/gyrocopter_rocket_barrage_lua", LUA_MODIFIER_MOTION_NONE)

gyrocopter_rocket_barrage_lua = gyrocopter_rocket_barrage_lua or class({})

function gyrocopter_rocket_barrage_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function gyrocopter_rocket_barrage_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_gyrocopter_int50") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function gyrocopter_rocket_barrage_lua:GetCooldown()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_gyrocopter_int50") then
		return 0
	end
end

function gyrocopter_rocket_barrage_lua:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Gyrocopter.Rocket_Barrage")
		if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and RollPercentage(75) then
			if not self.responses then
				self.responses = 
				{
					"gyrocopter_gyro_rocket_barrage_01",
					"gyrocopter_gyro_rocket_barrage_02",
					"gyrocopter_gyro_rocket_barrage_04",
				}
			end
			EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
		end
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_rocket_barrage_lua", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_gyrocopter_rocket_barrage_lua")
	end
end

function gyrocopter_rocket_barrage_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function gyrocopter_rocket_barrage_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function gyrocopter_rocket_barrage_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.Rocket_Barrage")

	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and RollPercentage(75) then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_rocket_barrage_01",
				"gyrocopter_gyro_rocket_barrage_02",
				"gyrocopter_gyro_rocket_barrage_04",
			}
		end
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_rocket_barrage_lua", {duration = self:GetDuration()})
end

function gyrocopter_rocket_barrage_lua:OnProjectileHit(target, location)
	if target then
		target:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
		damage = self:GetSpecialValueFor("rocket_damage")
			
		if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str6") ~= nil then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_gyrocopter_rocket_barrage_lua_slow", {duration = 5 * (1 - target:GetStatusResistance())})
		end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi7") ~= nil then 
			damage = self:GetSpecialValueFor("rocket_damage") + self:GetCaster():GetLevel() * 5
		end
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_gyrocopter_int50") ~= nil then 
			damage = damage + self:GetCaster():GetIntellect() * 0.5
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int10") ~= nil then 
			if self:GetCaster():GetIntellect() > self:GetCaster():GetStrength() and self:GetCaster():GetIntellect() > self:GetCaster():GetAgility() then
				damage = damage * 2
			end
		end		
		

		ApplyDamage({
			victim 			= target,
			damage 			= damage,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
		return true
	end
end

-------------------------------------------------------------------------------------------------------

modifier_gyrocopter_rocket_barrage_lua = modifier_gyrocopter_rocket_barrage_lua or class({})

function modifier_gyrocopter_rocket_barrage_lua:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.rockets_per_second	= self:GetAbility():GetSpecialValueFor("rockets_per_second")
	self.sniping_speed		= self:GetAbility():GetSpecialValueFor("sniping_speed")
	self.sniping_distance	= self:GetAbility():GetSpecialValueFor("sniping_distance")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi10") ~= nil then 
		self.rockets_per_second	= self:GetAbility():GetSpecialValueFor("rockets_per_second") + 5
	end

	if not IsServer() then return end
	
	self.rocket_damage	= self:GetAbility():GetSpecialValueFor("rocket_damage")	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi7") ~= nil then 
		self.rocket_damage = self:GetAbility():GetSpecialValueFor("rocket_damage") + self:GetCaster():GetLevel() * 5
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int10") ~= nil then 
		if self:GetCaster():GetIntellect() > self:GetCaster():GetStrength() and self:GetCaster():GetIntellect() > self:GetCaster():GetAgility() then
			self.rocket_damage = self.rocket_damage * 2
		end
	end	

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_gyrocopter_int50") ~= nil then 
		self.rocket_damage = self.rocket_damage + self:GetCaster():GetIntellect() * 0.5
	end

	self.damage_type = self:GetAbility():GetAbilityDamageType()
	self.weapons = {"attach_attack1", "attach_attack2"}
	self:StartIntervalThink(1 / self.rockets_per_second)
end

function modifier_gyrocopter_rocket_barrage_lua:OnRefresh()
	self:OnCreated()
end

function modifier_gyrocopter_rocket_barrage_lua:OnIntervalThink()
	if not self:GetParent():IsOutOfGame() then
		self:GetParent():EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
		self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #self.enemies >= 1 then
			for _, enemy in pairs(self.enemies) do
				enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
				
				self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.weapons[RandomInt(1, #self.weapons)], self:GetParent():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.barrage_particle)
			
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.rocket_damage,
					damage_type		= self.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
				break
			end
		else
			ProjectileManager:CreateLinearProjectile({
				EffectName	= "particles/base_attacks/ranged_tower_bad_linear.vpcf",
				Ability		= self:GetAbility(),
				Source		= self:GetCaster(),
				vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),
				vVelocity	= self:GetParent():GetForwardVector() * self.sniping_speed * Vector(1, 1, 0),
				vAcceleration	= nil, --hmm...
				fMaxSpeed	= nil, -- What's the default on this thing?
				fDistance	= self.sniping_distance + self:GetCaster():GetCastRangeBonus(),
				fStartRadius	= 25,
				fEndRadius		= 25,
				fExpireTime		= nil,
				iUnitTargetTeam	= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bIgnoreSource		= true,
				bHasFrontalCone		= false,
				bDrawsOnMinimap		= false,
				bVisibleToEnemies	= true,
				bProvidesVision		= false,
				iVisionRadius		= nil,
				iVisionTeamNumber	= nil,
				ExtraData			= {}
			})
		end
	end
end

function modifier_gyrocopter_rocket_barrage_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_gyrocopter_rocket_barrage_lua:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end

-------------------------------------------------------------------------------------------------------------------------

modifier_gyrocopter_rocket_barrage_lua_slow = modifier_gyrocopter_rocket_barrage_lua_slow or class({})

function modifier_gyrocopter_rocket_barrage_lua_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_gyrocopter_rocket_barrage_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return -50
end