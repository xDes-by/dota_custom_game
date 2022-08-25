tomb_teleport = class({})

function tomb_teleport:OnSpellStart()
	local caster = self:GetCaster()
	local owner = caster:GetOwner()
	local ability = self
	local sound_cast = "Hero_SkeletonKing.MortalStrike.Cast"
	EmitSoundOn( sound_cast, caster )

	local point_cater = caster:GetAbsOrigin()
	local point_owner = owner:GetAbsOrigin()
	
	if caster:GetTeam() == owner:GetTeam() then
		
		local point_closed_zone_1 = Entities:FindByName( nil, "forest_boss_point") 
		local closed_zone_point_1 = point_closed_zone_1:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_1):Length2D()
		if flDist < 1500 then return end
		
		local point_closed_zone_2 = Entities:FindByName( nil, "village_boss_point") 
		local closed_zone_point_2 = point_closed_zone_2:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_2):Length2D()
		if flDist < 1500 then return end
		
		local point_closed_zone_3 = Entities:FindByName( nil, "mines_boss_point") 
		local closed_zone_point_3 = point_closed_zone_3:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_3):Length2D()
		if flDist < 1500 then return end
		
		local point_closed_zone_4 = Entities:FindByName( nil, "dust_boss_point") 
		local closed_zone_point_4 = point_closed_zone_4:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_4):Length2D()
		if flDist < 1500 then return end
		
		local point_closed_zone_5 = Entities:FindByName( nil, "swamp_boss_point") 
		local closed_zone_point_5 = point_closed_zone_5:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_5):Length2D()
		if flDist < 1500 then return end

		local point_closed_zone_6 = Entities:FindByName( nil, "snow_boss_point") 
		local closed_zone_point_6 = point_closed_zone_6:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_6):Length2D()
		if flDist < 1500 then return end
		
		local point_closed_zone_6 = Entities:FindByName( nil, "last_boss_point") 
		local closed_zone_point_6 = point_closed_zone_6:GetAbsOrigin()
		
		local flDist = (point_owner - closed_zone_point_6):Length2D()
		if flDist < 1500 then return end	
		
		self:GetCaster():SetAbsOrigin( point_owner )
		FindClearSpaceForUnit(self:GetCaster(), point_owner, false)
		self:GetCaster():Stop() 
	end
end


