local damage_table = {}

damage_table[1] = 1.0

for i = 2, 30 do
	damage_table[i] = damage_table[i-1] * (1.19 - i * 0.0018)
end

for i = 31, 40 do
	damage_table[i] = damage_table[i-1] * (1.12 - (i - 30) * 0.005)
end

for i = 41, 100 do
	damage_table[i] = damage_table[i-1] * 1.07
end

for i = 101, 120 do
	damage_table[i] = damage_table[i-1] * 1.22
end

for i = 111, 150 do
	damage_table[i] = damage_table[i-1] * 1.1
end



local health_table = {}

for i = 1, 40 do
	health_table[i] = damage_table[i] * (1 + 0.05 * math.floor(0.1 * i))
end

for i = 41, 100 do
	health_table[i] = health_table[i-1] * 1.1
end

for i = 101, 110 do
	health_table[i] = health_table[i-1] * 1.22
end

for i = 111, 150 do
	health_table[i] = health_table[i-1] * 1.135
end



local bat_table = {}

for i = 1, 9 do
	bat_table[i] = 1.5
end

for i = 10, 20 do
	bat_table[i] = 1.1 - 0.03 * (i - 10)
end

for i = 21, 40 do
	bat_table[i] = bat_table[i-1] - 0.02
end

for i = 41, 150 do
	bat_table[i] = 0.4
end



GameRules.health_table = health_table
GameRules.damage_table = damage_table
GameRules.bat_table = bat_table
