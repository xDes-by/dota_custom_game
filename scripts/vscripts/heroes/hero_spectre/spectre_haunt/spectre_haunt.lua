spectre_haunt_lua = class({})
LinkLuaModifier( "modifier_spectre_haunt_lua", "heroes/hero_spectre/spectre_haunt/modifier_spectre_haunt", LUA_MODIFIER_MOTION_NONE )



function spectre_haunt_lua:GetCooldown(level)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int7") 
		if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - 60
	 else
		return self.BaseClass.GetCooldown(self, level)
	 end
end


function spectre_haunt_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect()/ 100)
end

function spectre_haunt_lua:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor( "illusion_duration" )
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_damage" )
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage" )
	local distance = 72
	count = 2
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi11")
	if abil ~= nil then 
	count = 3
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int_last")
	if abil ~= nil then 
	count = count + 3
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi10")
	if abil ~= nil then 
	outgoing = outgoing + 70
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str10")
	if abil ~= nil then 
	incoming = 50
	end
	
	-- create illusion
	local illusions = CreateIllusions(
		self:GetCaster(), -- hOwner
		caster, -- hHeroToCopy
		{
			outgoing_damage = outgoing,
			incoming_damage = incoming,
			duration = duration,
		}, -- hModiiferKeys
		count, -- nNumIllusions
		distance, -- nPadding
		false, -- bScramblePosition
		true -- bFindClearSpace
	)
	
	
	Timers:CreateTimer(duration - 0.1, function()
	for i = 1, #illusions do
			local illusion = illusions[i]
			if illusion ~= nil then
			UTIL_Remove( illusion )
			end
		end
	end)
	
	local sound_cast = "Hero_Spectre.HauntCast"
		EmitSoundOn( sound_cast, illusion )
end



function RealityCast (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local name = target:GetUnitName()
	
	local abil = caster:FindAbilityByName("npc_dota_hero_spectre_int9")
		if abil ~= nil then 
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
			if #enemies > 0 then        
				for _,unit in pairs(enemies) do
					ApplyDamage({ victim = unit, attacker = caster, damage = caster:GetIntellect(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})		
				end
			end	
		end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_spectre_str9")
		if abil ~= nil then 
			local point = target:GetAbsOrigin()
			local point_closed_zone = Entities:FindByName( nil, "closed_zone") 
			local closed_zone_point = point_closed_zone:GetAbsOrigin()
			
			local point_closed_zone2 = Entities:FindByName( nil, "silent") 
			local closed_zone_point2 = point_closed_zone2:GetAbsOrigin()
			
			local flDist = (point - closed_zone_point2):Length2D()
				if flDist < 3500 then return end
				
			local flDist = (point - closed_zone_point):Length2D()
				if flDist < 3500 then return end
				
			FindClearSpaceForUnit(caster, point, false)
			caster:Stop() 
			PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
			Timers:CreateTimer(0.1, function()
				PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
			end)
			EmitSoundOn("Hero_Spectre.Realitys", caster)
		end
	
	if name == "npc_dota_hero_spectre" and target:IsIllusion() and target:IsAlive() then		
		local point = target:GetAbsOrigin()
		local point_closed_zone = Entities:FindByName( nil, "closed_zone") 
		local closed_zone_point = point_closed_zone:GetAbsOrigin()

		local point_closed_zone2 = Entities:FindByName( nil, "silent") 
		local closed_zone_point2 = point_closed_zone2:GetAbsOrigin()

		local flDist = (point - closed_zone_point2):Length2D()
			if flDist < 3500 then return end
			
		local flDist = (point - closed_zone_point):Length2D()
			if flDist < 3500 then return end

		local caster_forward_vector = caster:GetForwardVector()
		local target_forward_vector = target:GetForwardVector()

		--Swaps the forward vector of the caster and the illusion
		caster:SetForwardVector(target_forward_vector)
		target:SetForwardVector(caster_forward_vector)

		--Store the caster and the illusions current position
		local caster_current_position = caster:GetAbsOrigin()
		local target_current_position = target:GetAbsOrigin()

		--Swaps the position of the caster and the illusion
		target:SetAbsOrigin(caster_current_position)	
		caster:SetAbsOrigin(target_current_position)

		FindClearSpaceForUnit( caster, target_current_position, true )

		EmitSoundOn("Hero_Spectre.Reality", caster)
	end
end
