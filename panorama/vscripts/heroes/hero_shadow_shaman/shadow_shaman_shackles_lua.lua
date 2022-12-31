shadow_shaman_shackles_lua = class({})
LinkLuaModifier("modifier_shadow_shaman_serpent_ward_chc", "heroes/hero_shadow_shaman/modifier_shadow_shaman_serpent_ward_chc", LUA_MODIFIER_MOTION_NONE)

function shadow_shaman_shackles_lua:GetChannelTime()
	self.duration = self:GetSpecialValueFor("channel_time") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_2")
	
	if IsClient() then 
		return self.duration 
	end
	
	if self.shackle_target then
		return self.duration
	end

	return 0
end

function shadow_shaman_shackles_lua:GetCastRange()
	local cast_range = self:GetSpecialValueFor("AbilityCastRange")

	-- The +100 cast range talent is not calculated here because it works separately like aether lens
	local caster = self:GetCaster()
	if caster and caster:HasShard() then
		cast_range = cast_range + self:GetSpecialValueFor("shard_cast_range_increase")
	end
	return cast_range
end

function shadow_shaman_shackles_lua:OnSpellStart()
	-- unit identifier
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	self.shackle_target = target
	
	-- cancel if linken
	if target:TriggerSpellAbsorb(self) then
		Timers:CreateTimer(0.01, function()
			self:EndChannel(true)
		end)
		return
	end

	local duration = self:GetSpecialValueFor("channel_time") + self:GetCaster():FindTalentValue("special_bonus_unique_shadow_shaman_2")

	-- Total Damage and tick damage is calculated in the modifier
	target:AddNewModifier(caster, self, "modifier_shadow_shaman_shackles", {duration = duration})

	--Summon Shard Serpent Wards
	if caster:HasShard() then
		local ward_count = self:GetSpecialValueFor("shard_ward_number")
		local ward_duration = self:GetSpecialValueFor("shard_ward_duration")
		local fv = caster:GetForwardVector()

		local unit_name = "npc_dota_shadow_shaman_ward_1"

		local msw_ability = caster:FindAbilityByName("shadow_shaman_mass_serpent_ward_lua")
		if msw_ability and msw_ability:IsTrained() then
			unit_name = "npc_dota_shadow_shaman_ward_" .. msw_ability:GetLevel()
		end

		-- Positioning the ward spawn
		local origin = target:GetAbsOrigin()
		local position = origin + RandomVector(100)

		local serpent_ward = CreateUnitByName(unit_name, position, true, caster, caster, caster:GetTeamNumber())
		serpent_ward:SetControllableByPlayer(caster:GetPlayerID(), false)
		serpent_ward:SetForwardVector(fv)
		serpent_ward:SetAttacking(target)

		-- Spawn one ward with x4 stats
		serpent_ward:SetBaseMaxHealth(serpent_ward:GetBaseMaxHealth() * ward_count)
		serpent_ward:SetBaseDamageMin(serpent_ward:GetBaseDamageMin() * ward_count)
		serpent_ward:SetBaseDamageMax(serpent_ward:GetBaseDamageMax() * ward_count)

		serpent_ward:SetBaseMaxHealth(serpent_ward:GetBaseMaxHealth() + caster:FindTalentValue("special_bonus_custom_shadow_shaman_1"))
		serpent_ward:SetBaseDamageMin(serpent_ward:GetBaseDamageMin() + caster:FindTalentValue("special_bonus_custom_shadow_shaman_4"))
		serpent_ward:SetBaseDamageMax(serpent_ward:GetBaseDamageMax() + caster:FindTalentValue("special_bonus_custom_shadow_shaman_4"))

		serpent_ward:AddAbility("summon_buff")
		serpent_ward:AddNewModifier(caster, self, "modifier_shadow_shaman_serpent_ward_chc", {duration = ward_duration, ward_count = ward_count})
	end

	-- Particles
	EmitSoundOn("Hero_ShadowShaman.shackles.Cast", caster)
	
	self.shackles_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(self.shackles_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.shackles_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.shackles_pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.shackles_pfx, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	
	ParticleManager:SetParticleControlEnt(self.shackles_pfx, 5, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.shackles_pfx, 6, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
end

function shadow_shaman_shackles_lua:OnChannelFinish()
	StopSoundOn("Hero_ShadowShaman.Shackles", self:GetCaster())
	if self.shackles_pfx then
		ParticleManager:DestroyParticle(self.shackles_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.shackles_pfx)
	end
end



