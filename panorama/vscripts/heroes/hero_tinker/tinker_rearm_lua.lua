tinker_rearm_lua = class({})

LinkLuaModifier("modifier_rearm_animation", "heroes/hero_tinker/tinker_rearm_lua", LUA_MODIFIER_MOTION_NONE)

function tinker_rearm_lua:GetChannelTime()
	local time = self.BaseClass.GetChannelTime(self)
	return time
end

function tinker_rearm_lua:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rearm_animation", {duration = self:GetChannelTime()})
end

function tinker_rearm_lua:OnChannelFinish(interrupted)
	if IsClient() then return end

	if interrupted then
		self:GetCaster():RemoveModifierByName("modifier_rearm_animation")
	else
		self:RefreshCoooldowns()
	end
end

function tinker_rearm_lua:RefreshCoooldowns()
	local caster = self:GetCaster()
	
	-- Abilities that rearm doesn't refresh
	local ability_exempt_table = {
		slark_depth_shroud					= true,
		clinkz_death_pact_lua 				= true,
		abaddon_borrowed_time 				= true,
		arc_warden_tempest_double_lua 		= true,
		dark_willow_shadow_realm			= true,
		dazzle_shallow_grave 				= true,
		doom_bringer_devour					= true,
		faceless_void_chronosphere  		= true,
		omniknight_guardian_angel			= true,
		oracle_false_promise 				= true,
		phoenix_supernova 	  				= true,
		rattletrap_overclocking 			= true,
		razor_eye_of_the_storm 				= true,
		shadow_shaman_mass_serpent_ward_lua = true,
		skeleton_king_reincarnation 		= true,
		slark_shadow_dance 					= true,
		spectre_haunt 						= true,
		warlock_fatal_bonds					= true,
		warlock_rain_of_chaos_lua 			= true,
		arc_warden_scepter					= true,
		chen_hand_of_god_lua 				= true,
		night_stalker_hunter_in_the_night_lua = true,
		phantom_assassin_fan_of_knives		= true,
		enigma_black_hole					= true,
		broodmother_spawn_spiderlings_lua	= true,
		dazzle_good_juju					= true,
		visage_gravekeepers_cloak_lua		= true,
		meepo_petrify						= true,
		ursa_enrage							= true,
		doom_bringer_doom					= true,
		-- temporarily disabled to investigate lag
		furion_force_of_nature 				= true,
		terrorblade_reflection_lua			= true,
		undying_tombstone_lua				= true,
		zeus_cloud_lua						= true,
		mars_arena_of_blood					= true,
	}

	for i = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability ~= self and (not ability_exempt_table[ability:GetAbilityName()]) then
			if ability.RefreshCharges then ability:RefreshCharges() end
			if ability.charge_modifier then ability:_RefreshCharges() end
			if ability.EndCooldown then ability:EndCooldown() end
		end
	end
	
	-- Put item exemption in here
	local exempt_table = {
		item_hand_of_midas 			= true,
		item_refresher				= true,
		item_black_king_bar			= true,
		item_aeon_disk_lua			= true,
		item_helm_of_the_dominator	= true,
		item_guardian_helmet		= true,
		item_sphere					= true,
		item_wraith_pact_lua		= true,
	}

	-- Reset cooldown for items
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		local item = caster:GetItemInSlot(i)
		if item and not exempt_table[item:GetAbilityName()] and not item:IsNeutralDrop() then
			item:EndCooldown()
		end
	end
end

modifier_rearm_animation = class({})

function modifier_rearm_animation:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local level = self:GetAbility():GetLevel()
		
		---------------------------------------------------------------------------------------------
		-- Valve made shitty animation logic on Rearm, so each channel-time needs proper adjustment
		---------------------------------------------------------------------------------------------
		caster:EmitSound("Hero_Tinker.RearmStart")
		caster:EmitSound("Hero_Tinker.Rearm")
		local cast_main_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_main_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_main_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		local cast_pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_b.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_pfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		local cast_pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_b.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_pfx2, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster:GetAbsOrigin(), true)
		local cast_sparkle_pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_c.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_sparkle_pfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		local cast_sparkle_pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_c.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_sparkle_pfx2, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster:GetAbsOrigin(), true)
		
		local animation_reset = 0
		if level == 1 or level == 2 then
			caster:StartGesture(ACT_DOTA_TINKER_REARM1)
		elseif level == 3 then
			caster:StartGesture(ACT_DOTA_TINKER_REARM2)
		end

		Timers:CreateTimer(FrameTime(), function()
			if caster:HasModifier("modifier_rearm_animation") then
				animation_reset = animation_reset + 1
				if (level == 1 and animation_reset == 60) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM1)
					caster:StartGesture(ACT_DOTA_TINKER_REARM3)
				elseif (level == 2 and animation_reset == 45) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM1)
					caster:StartGesture(ACT_DOTA_TINKER_REARM3)
				elseif (level == 3 and animation_reset == 23) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM2)
					caster:StartGestureWithPlaybackRate(ACT_DOTA_TINKER_REARM3, 0.9)
				end
				return FrameTime()
			else
				ParticleManager:DestroyParticle(cast_main_pfx, false)
				ParticleManager:DestroyParticle(cast_pfx1, false)
				ParticleManager:DestroyParticle(cast_pfx2, false)
				ParticleManager:DestroyParticle(cast_sparkle_pfx1, false)
				ParticleManager:DestroyParticle(cast_sparkle_pfx2, false)
				ParticleManager:ReleaseParticleIndex(cast_main_pfx)
				ParticleManager:ReleaseParticleIndex(cast_pfx1)
				ParticleManager:ReleaseParticleIndex(cast_pfx2)
				ParticleManager:ReleaseParticleIndex(cast_sparkle_pfx1)
				ParticleManager:ReleaseParticleIndex(cast_sparkle_pfx2)
				return nil
			end
		end)
	end
end

function modifier_rearm_animation:GetEffectName()
	return "particles/units/heroes/hero_tinker/tinker_rearm.vpcf"
end

function modifier_rearm_animation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
