LinkLuaModifier( "modifier_unit_on_death", "modifiers/modifier_unit_on_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )

function difficality_modifier(unit)
	if diff_wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end		
end	

----------------------------------------------------------------

if modifier_unit_on_death == nil then modifier_unit_on_death = class({}) end

function modifier_unit_on_death:IsHidden()
	return true
end

function modifier_unit_on_death:IsPurgable()
	return false
end

function modifier_unit_on_death:OnCreated(kv)
	if not IsServer() then return end
	self.spawnPos = Vector(kv.posX, kv.posY, kv.posZ)
	self.unitName = kv.name
	self.unit = self:GetParent()
end

function modifier_unit_on_death:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

creep_respawn_20 = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_2","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}
creep_respawn_8 = {"village_creep_1","village_creep_2","village_creep_3"}
creep_respawn_5 = {"mines_creep_1","mines_creep_2","mines_creep_3"}

point_village = {"village_spawn_1","village_spawn_2","village_spawn_3","village_spawn_4","village_spawn_5"}
point_mines = {"mines_spawn_1","mines_spawn_2","mines_spawn_3","mines_spawn_4","mines_spawn_5","mines_spawn_6","mines_spawn_7"}

function modifier_unit_on_death:OnDeath(event)
    if not IsServer() then return end

    local creep = event.unit
    if creep ~= self:GetParent() then return end
	
	if creep:GetUnitName() == "farm_zone_dragon" then
		amountTime = 0.05
		respawn(amountTime, self.spawnPos, self.unitName)
		return
	end
	
	for _,t in ipairs(creep_respawn_8) do
		if t and t == creep:GetUnitName() then 			
			local point = point_village[RandomInt(1,#point_village)]
			local caster_respoint = Entities:FindByName(nil,point):GetAbsOrigin()    
			self.spawnPos = caster_respoint
			amountTime = 6
			respawn(amountTime, self.spawnPos, self.unitName)
			return
		end
    end

	for _,t in ipairs(creep_respawn_5) do
		if t and t == creep:GetUnitName() then 
			local point = point_mines[RandomInt(1,#point_mines)]
			local caster_respoint = Entities:FindByName(nil,point):GetAbsOrigin()    
			self.spawnPos = caster_respoint
			amountTime = 2
			respawn(amountTime, self.spawnPos, self.unitName)
			return
		end
    end

	for _,t in ipairs(creep_respawn_20) do
		if t and t == creep:GetUnitName() then 
			amountTime = 18
			respawn(amountTime, self.spawnPos, self.unitName)
			return
		end
    end

	Timers:CreateTimer(0.05, function()
		UTIL_Remove( creep )
	end)
end

function respawn(amountTime, position, unit_name)
	Timers:CreateTimer(amountTime, function()
		if _G.kill_invoker == false or self.unitName == "farm_zone_dragon" then
			CreateUnitByNameAsync(unit_name, position, true, nil, nil, DOTA_TEAM_BADGUYS, function(unit)
				difficality_modifier(unit)
				unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
					posX = position.x,
					posY = position.y,
					posZ = position.z,
					name = unit_name
				})
			end)
		end
	end)
end