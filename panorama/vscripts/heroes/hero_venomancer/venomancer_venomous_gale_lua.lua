venomancer_venomous_gale_lua = class({})

function venomancer_venomous_gale_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()

	-- Parameters
	local duration = self:GetSpecialValueFor("duration")
	local strike_damage = self:GetSpecialValueFor("strike_damage")
	local tick_damage = self:GetSpecialValueFor("tick_damage")
	local tick_interval = self:GetSpecialValueFor("tick_interval")
	local projectile_speed = self:GetSpecialValueFor("speed")
	local radius = self:GetSpecialValueFor("radius")
	local travel_distance = self:GetCastRange(target_loc, nil) + 50

	local direction
	if target_loc == caster_loc then
		direction = caster:GetForwardVector()
	else
		direction = (target_loc - caster_loc):Normalized()
	end

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1
	local delay = 0.5

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	-- Contains hitted targets as keys and wards created by that hit as values
	self.multicast_wards_tracker = {} ---@type table<CDOTA_BaseNPC, CDOTA_BaseNPC[]>

	local particle_mount = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_venomancer/venomancer_venomous_gale_mouth.vpcf", caster)
	local particle_projectile = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", caster)

	Timers:CreateTimer(0, function()
		local mouth_pfx = ParticleManager:CreateParticle(particle_mount, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(mouth_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_mouth", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(mouth_pfx)

		caster:EmitSound("Hero_Venomancer.VenomousGale")

		local projectile = {
			Ability				= self,
			EffectName			= particle_projectile,
			vSpawnOrigin		= caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")),
			fDistance			= travel_distance,
			fStartRadius		= radius,
			fEndRadius			= radius,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= self:GetAbilityTargetTeam(),
			iUnitTargetFlags	= self:GetAbilityTargetFlags(),
			iUnitTargetType		= self:GetAbilityTargetType(),
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * projectile_speed,
			bProvidesVision		= true,
			iVisionRadius 		= 280,
			iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
			ExtraData			= {strike_damage = strike_damage, duration = duration}
		}

		ProjectileManager:CreateLinearProjectile(projectile)

		multicast = multicast - 1
		if multicast > 0 then
			return delay
		end
	end)
end

---@param target CDOTA_BaseNPC
function venomancer_venomous_gale_lua:OnProjectileHit_ExtraData(target, location, ExtraData)
	local caster = self:GetCaster()
	if target then
		target:AddNewModifier(caster, self, "modifier_venomancer_venomous_gale", {duration = ExtraData.duration})
		target:EmitSound("Hero_Venomancer.VenomousGaleImpact")

		local create_wards = self:GetSpecialValueFor("create_wards")

		if create_wards > 0 then 
			-- First hit creates wards and next hits upgrades previously created wards
			if self.multicast_wards_tracker[target] then -- Upgrade for next hits
				self:UpgradeWardsMulticast(self.multicast_wards_tracker[target])
			else -- Summon for first hit
				self.multicast_wards_tracker[target] = {}
				
				local ward_count = target:IsRealHero() and create_wards or 1
				for i = 1, ward_count do
					table.insert(self.multicast_wards_tracker[target], self:SpawnPlagueWard(target))
				end
			end
		end
	end
end

---@param wards CDOTA_BaseNPC[]
function venomancer_venomous_gale_lua:UpgradeWardsMulticast(wards)
	for _,unit in pairs(wards) do
		if IsValidEntity(unit) and unit:IsAlive() then
			unit:SetBaseDamageMin(unit:GetBaseDamageMin() + unit.original_base_min_attack)
			unit:SetBaseDamageMax(unit:GetBaseDamageMax() + unit.original_base_max_attack)

			unit.multicast = unit.multicast and unit.multicast + 1 or 2

			-- Update summon buff values
			local modifier_summon_buff = unit:FindModifierByName("modifier_summon_buff")
			if modifier_summon_buff then 
				modifier_summon_buff.original_base_health = unit.original_base_max_health * unit.multicast
				modifier_summon_buff:ForceRefresh()
			end

			local particle_name = "particles/units/heroes/hero_ursa/ursa_overpower_cast.vpcf"
			local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, unit)
			ParticleManager:ReleaseParticleIndex(pfx)

			local modifier = unit:AddNewModifier(unit, nil, "modifier_multicast_grow", nil)
			if modifier then
				modifier:SetStackCount(unit.multicast)
			end
		end
	end
end

function venomancer_venomous_gale_lua:SpawnPlagueWard(target)
	local caster = self:GetCaster()
	local pos = target:GetAbsOrigin()
	local unit_name = "npc_dota_venomancer_plague_ward_4"

	local ward_ability = caster:FindAbilityByName("venomancer_plague_ward_lua")
	if ward_ability and ward_ability:IsTrained() then
		unit_name = "npc_dota_venomancer_plague_ward_" .. ward_ability:GetLevel()
	end

	local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_unique_venomancer_7")

	local unit = CreateUnitByName(unit_name, pos, true, caster, caster, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
	unit:AddNewModifier(caster, self, "modifier_magic_immune", {duration = duration})

	if caster:HasTalent("special_bonus_unique_venomancer") then
		local talent_multiplier = caster:FindTalentValue("special_bonus_unique_venomancer")

		unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * talent_multiplier)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin() * talent_multiplier)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() * talent_multiplier)
	end

	unit.original_base_max_health = unit:GetBaseMaxHealth()
	unit.original_base_min_attack = unit:GetBaseDamageMin()
	unit.original_base_max_attack = unit:GetBaseDamageMax()

	unit:AddAbility("summon_buff")

	ResolveNPCPositions(unit:GetAbsOrigin(), 64)

	return unit
end
