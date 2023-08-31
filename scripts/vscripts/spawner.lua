require("data/data")

if Spawner == nil then
	Spawner = class({})
end

function add_modifier(unit)
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
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
	unit:AddNewModifier(unit, nil, "modifier_unit_on_death2", {})
end	

wave = 0
_G.wave_count = 1
rat = 0

count_comandir = 5
count_creeps = 25

line_time = 120

damage_creeps = 6
health = 110
armor = 0.001
magermor = 10
golddrop = 1.5
xp = 2


t_creeps = {"creep_1","creep_2","creep_3","creep_4","creep_5","creep_6","creep_7","creep_8","creep_9","creep_10"}
t_boss = {"boss_1","boss_2","boss_3","boss_5","boss_7","boss_10","boss_6","boss_4","boss_8","boss_9"}  --  порядок боссов!!!!!!!!!
actual_t_boss = {}

function Spawner:Init()
	Timers:CreateTimer(120,function()
		_G.point_line_spawner = Entities:FindByName( nil, "line_spawner"):GetAbsOrigin() 
		if spawnCreeps then
			Spawn_system()
		end
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Spawn_system()
	Timers:CreateTimer(function()
		local barack = Entities:FindByName( nil, "badguys_creeps")  
		if barack == nil then 
			talants.barakDestroy = true
			wave_count = 0
		end
		
		local barack = Entities:FindByName( nil, "badguys_comandirs")  
		if barack == nil then 
			wave_count = 0
			talants.barakDestroy = true
		end
		
		local barack = Entities:FindByName( nil, "badguys_boss")  
		if barack == nil then 
			wave_count = 0
			talants.barakDestroy = true
		end
		wave = wave + 1
		rat = rat + wave_count * 2
		for i = 0, 4 do
			Quests:UpdateCounter("bonus", 17, 1, i, 1)
			Quests:UpdateCounter("bonus", 15, 1, i, 1)
		end
		if wave ~= 0 and wave % 5 == 0 then 
			xpcall(Spawner:SpawnBosses(), function(e) GameRules:SendCustomMessage(e,0,0) end)
			return line_time
		else
			xpcall(Spawner:settings(), function(e) GameRules:SendCustomMessage(e,0,0) end)																					
		  return line_time
		end
	end)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Spawner:settings()
	creeps_name = t_creeps[RandomInt(1,#t_creeps)]	
	health = health * 1.16
	damage_creeps = damage_creeps * 1.16

	set_health = math.floor(health + health*(wave/2)) * 2
	
	set_health_commandir = set_health * 2
	set_health_boss = set_health * 50
	
	if set_health >= 1000000000 then
		set_health = 1000000000
	end
	
	if set_health_commandir >= 1000000000 then
		set_health_commandir = 1000000000
	end
	
	if set_health_boss >= 2000000000 then
		set_health_boss = 2000000000
	end		
	
	set_damage = math.floor(damage_creeps + damage_creeps*(wave/2)) * 2
	
	set_damage_commandir = set_damage * 2
	set_damage_boss = set_damage * 20
	
	if set_damage >= 1000000000 then
		set_damage = 1000000000
	end
	
	if set_damage_commandir >= 1000000000 then
		set_damage_commandir = 1000000000
	end
	
	if set_damage_boss >= 2000000000 then
		set_damage_boss = 2000000000
	end		
		
	set_armor = math.floor(wave*2^(1.02+wave*2*armor) * 1.25 )
 	set_armor_commandir = set_armor * 1.5
	set_armor_boss = set_armor * 2
	
	set_mag_resist = math.floor(magermor + wave) * 2
	set_mag_resist_creep = math.min(set_mag_resist / 3, 90)
	set_mag_resist_commandir =  math.min(set_mag_resist / 2.5, 90)
	set_mag_resist_boss =  math.min(set_mag_resist / 2, 90)
	
	xp = xp + 8
	golddrop = golddrop + 5
	
	Spawner:SpawnCreeps(creeps_name)					
	Spawner:SpawnCommandirs(creeps_name)	
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Spawner:SpawnCreeps(name)   	
	local barack = Entities:FindByName( nil, "badguys_creeps")  
	if barack ~= nil then 		
		for i = 1, count_creeps do
			local point = _G.point_line_spawner + RandomVector(RandomInt(50, 250))
			local creep = CreateUnitByName( name, point, true, nil, nil, DOTA_TEAM_BADGUYS )
			FindClearSpaceForUnit(creep, point, false)
			creep:SetBaseDamageMin(set_damage)
			creep:SetBaseDamageMax(set_damage)
			creep:SetPhysicalArmorBaseValue(set_armor)
			creep:SetBaseMagicalResistanceValue(set_mag_resist_creep)
			creep:SetMaxHealth(set_health)
			creep:SetBaseMaxHealth(set_health)
			creep:SetHealth(set_health)	
			creep:SetDeathXP(xp)
							
			creep:AddNewModifier(creep, nil, "modifier_attack_speed", nil):SetStackCount(wave)
			creep:AddNewModifier(creep, nil, "modifier_hp_regen_creep", nil)
			add_modifier(creep)
		end
		creeps_line_notification() 
	end
end

function Spawner:SpawnCommandirs(name)
	local barack = Entities:FindByName( nil, "badguys_comandirs")  
	if barack ~= nil then
		for i = 1, count_comandir do
			local point = _G.point_line_spawner + RandomVector(RandomInt(50, 250))
			local creep = CreateUnitByName( "comandir_"..name, point, true, nil, nil, DOTA_TEAM_BADGUYS )	
			FindClearSpaceForUnit(creep, point, false)			
			creep:SetBaseDamageMin(set_damage_commandir)
			creep:SetBaseDamageMax(set_damage_commandir)
			creep:SetPhysicalArmorBaseValue(set_armor_commandir)
			creep:SetBaseMagicalResistanceValue(set_mag_resist_commandir)
			creep:SetMaxHealth(set_health_commandir)
			creep:SetBaseMaxHealth(set_health_commandir)
			creep:SetHealth(set_health_commandir)		
			creep:SetDeathXP(xp*2)

			creep:AddNewModifier(creep, nil, "modifier_attack_speed", nil):SetStackCount(wave * 2)
			creep:AddNewModifier(creep, nil, "modifier_spell_ampl_creep", nil):SetStackCount(wave * 2)
			creep:AddNewModifier(creep, nil, "modifier_hp_regen_commandir", nil)
			add_modifier(creep)
		end
	end
end

function table.copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end

function Spawner:SpawnBosses()
	local barack = Entities:FindByName( nil, "badguys_boss")  
	if barack ~= nil then
	
		if #actual_t_boss == 0 then
			actual_t_boss = table.copy(t_boss)
		end
		name = actual_t_boss[1]	
		for i,k in pairs(actual_t_boss) do
			if name == k then
				table.remove(actual_t_boss, i)
			end
		end

		local point = _G.point_line_spawner + RandomVector(RandomInt(50, 250))
		local creep = CreateUnitByName( name, point, true, nil, nil, DOTA_TEAM_BADGUYS )
		FindClearSpaceForUnit(creep, point, false)
		creep:SetBaseDamageMin(set_damage_boss)
		creep:SetBaseDamageMax(set_damage_boss)
		creep:SetPhysicalArmorBaseValue(set_armor_boss)
		creep:SetBaseMagicalResistanceValue(set_mag_resist_boss)
		creep:SetMaxHealth(set_health_boss)
		creep:SetBaseMaxHealth(set_health_boss)
		creep:SetHealth(set_health_boss)		
		creep:SetDeathXP(xp*3)
		
		local total_hp = creep:GetMaxHealth()
		local porog_hp = 20000000
		local stack_modifier = math.floor(total_hp/porog_hp)
		
		if total_hp >= porog_hp then
			total_hp = porog_hp
			creep:SetBaseMaxHealth(total_hp)
			creep:SetMaxHealth(total_hp)
			creep:SetHealth(total_hp)
			creep:AddNewModifier(creep, nil, "modifier_health", nil):SetStackCount(stack_modifier)
		end      

		creep:AddNewModifier(creep, nil, "modifier_attack_speed", nil):SetStackCount(wave * 2)
		creep:AddNewModifier(creep, nil, "modifier_spell_ampl_creep", nil):SetStackCount(wave * 2)
		creep:AddNewModifier(creep, nil, "modifier_hp_regen_boss", nil)
		add_modifier(creep)
		bosses_line_notification(name)  
	end
end

function Spawner:SpawnBaracksBosses(name)
	local point = _G.point_line_spawner + RandomVector(RandomInt(50, 250))
	local creep = CreateUnitByName( name, point, true, nil, nil, DOTA_TEAM_BADGUYS )
	FindClearSpaceForUnit(creep, point, false)
	creep:SetBaseDamageMin(set_damage_boss)
	creep:SetBaseDamageMax(set_damage_boss)
	creep:SetPhysicalArmorBaseValue(set_armor_boss)
	creep:SetBaseMagicalResistanceValue(set_mag_resist_boss)
	creep:SetMaxHealth(set_health_boss)
	creep:SetBaseMaxHealth(set_health_boss)
	creep:SetHealth(set_health_boss)		
	creep:SetDeathXP(xp*3)
	
	local total_hp = creep:GetMaxHealth()
	local porog_hp = 20000000
	local stack_modifier = math.floor(total_hp/porog_hp)
	
	if total_hp >= porog_hp then
		total_hp = porog_hp
		creep:SetBaseMaxHealth(total_hp)
		creep:SetMaxHealth(total_hp)
		creep:SetHealth(total_hp)
		creep:AddNewModifier(creep, nil, "modifier_health", nil):SetStackCount(stack_modifier)
	end      

	creep:AddNewModifier(creep, nil, "modifier_attack_speed", nil):SetStackCount(wave * 2)
	creep:AddNewModifier(creep, nil, "modifier_spell_ampl_creep", nil):SetStackCount(wave * 2)
	creep:AddNewModifier(creep, nil, "modifier_hp_regen_boss", nil)
	add_modifier(creep)
end

------------------------------------------------------------------------------------------------------

function creeps_line_notification()
	for nPlayerID = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayer(nPlayerID) then
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "WaveNotification", {
			number = wave,
			name = creeps_name,
			description = creeps_name,
			img = "/wave/"..creeps_name..".png",
			})
		end
	end
	rating.wave_name = creeps_name
	rating.wave_count = 0
	rating.wave_need = count_creeps + count_comandir
	CustomGameEventManager:Send_ServerToAllClients( "updateWaveCounter", {need = rating.wave_need, count = rating.wave_count} )
end

function bosses_line_notification(creeps_name)
	for nPlayerID = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayer(nPlayerID) then
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "WaveNotification", {
			number = wave,
			name = creeps_name,
			description = creeps_name,
			img = "/wave/bosses/"..creeps_name..".png",
			})
		end
	end
	rating.wave_name = creeps_name
	rating.wave_count = 0
	rating.wave_need = 1
	CustomGameEventManager:Send_ServerToAllClients( "updateWaveCounter", {need = rating.wave_need, count = rating.wave_count} )
end