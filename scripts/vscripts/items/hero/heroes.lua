LinkLuaModifier( "modifier_base_passive", "modifiers/modifier_base", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_transformation", "modifiers/modifier_base", LUA_MODIFIER_MOTION_NONE )


function add_1(keys)
	local caster = keys.caster
	local level = caster:GetLevel()
	
	local caster_hero = caster:GetName()
	if caster_hero == "npc_dota_hero_treant" or caster_hero == "npc_dota_hero_nevermore" or caster_hero == "npc_dota_hero_windrunner" or caster_hero == "npc_dota_hero_slark" then return end
	
	local hero = Entities:FindByName( nil, "npc_dota_hero_tinker")
	if hero == nil then
	
		if caster ~= nil and level == 1 then
			local new_charges = keys.ability:GetCurrentCharges() - 1
			if new_charges <= 0 then
			keys.caster:RemoveItem(keys.ability)
										
			local playerID = caster:GetPlayerID()
			local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
			local newHeroName = "npc_dota_hero_tinker"	
			local gold = oldHero:GetGold()
			local experience = oldHero:GetCurrentXP() 
						if playerID ~= nil and playerID ~= -1 then 
							caster:ForceKill(false)
							items_table = {} 
							for i = 0, 23 do 
								local item = oldHero:GetItemInSlot( i ) 
								if item ~= nil then 
									items_table[item:GetName()] = item:GetCurrentCharges() 
									item:RemoveSelf() 
								end 
							end 
							local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
							newHero:SetGold(gold, false)
							local abil = newHero:FindAbilityByName("infinite_all"):SetLevel(1)
							newHero:AddExperience(experience, 0, false, true)
							for item,stacks in pairs(items_table) do 
								newHero:AddItemByName(item):SetCurrentCharges(stacks) 
						end 
					end
				UTIL_Remove(caster)
			end
		end
	end
end

function add_2(keys)
	local caster = keys.caster
	local abil =  keys.ability
	local level = caster:GetLevel()
	
	local caster_hero = caster:GetName()
	if caster_hero == "npc_dota_hero_tinker" or caster_hero == "npc_dota_hero_nevermore" or caster_hero == "npc_dota_hero_windrunner" or caster_hero == "npc_dota_hero_slark" then return end
	
	local hero = Entities:FindByName( nil, "npc_dota_hero_treant")
	if hero == nil then
	
	local main = Entities:FindByName( nil, "npc_main_base")
	
	local distance = (caster:GetAbsOrigin() - main:GetAbsOrigin()):Length2D()
	 	if distance < 1000 then
	
	if caster ~= nil and level == 1 then
		local new_charges = keys.ability:GetCurrentCharges() - 1
		if new_charges <= 0 then
		keys.caster:RemoveItem(keys.ability)
									
		local playerID = caster:GetPlayerID()
		local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
		local newHeroName = "npc_dota_hero_treant"	
		local gold = oldHero:GetGold()
		local experience = oldHero:GetCurrentXP() 
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)
					------------------------------------------------------------------------------	
						for i = 0, newHero:GetAbilityCount() - 1 do
						local ability = newHero:GetAbilityByIndex(i)
						if ability and not ability:IsNull() then
						local name_ability = ability:GetName()
						if not ability:IsAttributeBonus() then
						  Timers:CreateTimer({
							endTime = 0.1, 
							callback = function()
							newHero:RemoveAbilityByHandle(ability)
							end
						  })
						end
						end
						end
						
						local base = Entities:FindByName( nil, "npc_main_base")
						base:AddNewModifier(base, abil, "modifier_heavens_halberd_debuff", nil)
						base:AddNewModifier(base, abil, "modifier_invulnerable", nil)
						base:AddNewModifier(base, abil, "modifier_base_passive", nil)
						newHero:AddNewModifier(newHero, abil, "modifier_transformation", nil)
						newHero:SetModelScale(1.8)
						
						base:AddNoDraw()
					----------------------------------------------------------------------------------
						newHero:AddExperience(experience, 0, false, true)
						--newHero:AddItemByName("item_zaglushka")
						newHero:AddAbility("infinite_all2"):SetLevel(1)
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
					end 
				end
			UTIL_Remove(caster)
		end
	end
end
end
end

function add_3(keys)
	local caster = keys.caster
	local level = caster:GetLevel()
	
	local caster_hero = caster:GetName()
	if caster_hero == "npc_dota_hero_tinker" or caster_hero == "npc_dota_hero_treant" or caster_hero == "npc_dota_hero_windrunner" or caster_hero == "npc_dota_hero_slark" then return end
	
	local hero = Entities:FindByName( nil, "npc_dota_hero_nevermore")
	if hero == nil then
	
	if caster ~= nil and level == 1 then
		local new_charges = keys.ability:GetCurrentCharges() - 1
		if new_charges <= 0 then
		keys.caster:RemoveItem(keys.ability)
									
		local playerID = caster:GetPlayerID()
		local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
		local newHeroName = "npc_dota_hero_nevermore"	
		local gold = oldHero:GetGold()
		local experience = oldHero:GetCurrentXP() 
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)
		
						newHero:AddExperience(experience, 0, false, true)
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
					end 
				end
			UTIL_Remove(caster)
		end
	end
end
end



function add_4(keys)
	local caster = keys.caster
	local level = caster:GetLevel()
	
	local caster_hero = caster:GetName()
	if caster_hero == "npc_dota_hero_tinker" or caster_hero == "npc_dota_hero_treant" or caster_hero == "npc_dota_hero_nevermore" or caster_hero == "npc_dota_hero_slark" then return end
	
	local hero = Entities:FindByName( nil, "npc_dota_hero_windrunner")
	if hero == nil then
	
	if caster ~= nil and level == 1 then
		local new_charges = keys.ability:GetCurrentCharges() - 1
		if new_charges <= 0 then
		keys.caster:RemoveItem(keys.ability)
									
		local playerID = caster:GetPlayerID()
		local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
		local newHeroName = "npc_dota_hero_windrunner"	
		local gold = oldHero:GetGold()
		local experience = oldHero:GetCurrentXP() 
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)
		
						newHero:AddExperience(experience, 0, false, true)
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
					end 
				end
			UTIL_Remove(caster)
		end
	end
end
end


function add_slark(keys)
	local caster = keys.caster
	local level = caster:GetLevel()
	
	local caster_hero = caster:GetName()
	if caster_hero == "npc_dota_hero_tinker" or caster_hero == "npc_dota_hero_treant" or caster_hero == "npc_dota_hero_nevermore" or caster_hero == "npc_dota_hero_windrunner" then return end
	
	local hero = Entities:FindByName( nil, "npc_dota_hero_slark")
	if hero == nil then
	
	if caster ~= nil and level == 1 then
		local new_charges = keys.ability:GetCurrentCharges() - 1
		if new_charges <= 0 then
		keys.caster:RemoveItem(keys.ability)
									
		local playerID = caster:GetPlayerID()
		local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
		local newHeroName = "npc_dota_hero_slark"	
		local gold = oldHero:GetGold()
		local experience = oldHero:GetCurrentXP() 
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)
		
						newHero:AddExperience(experience, 0, false, true)
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
					end 
				end
			UTIL_Remove(caster)
		end
	end
end
end