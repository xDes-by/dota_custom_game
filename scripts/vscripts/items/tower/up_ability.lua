require("data/data")
LinkLuaModifier( "modifier_hpstack", "modifiers/modifier_base", LUA_MODIFIER_MOTION_NONE )
 
function add_ability_passive(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
			local target_name = target:GetUnitName()
			if target_name == "npc_main_base" then --or target_name == "npc_dota_hero_treant" then
			ability_name = Ability_tower_passive_lvl_1[RandomInt(1,#Ability_tower_passive_lvl_1)]	
				for i = 1, 20 do
				local skill = target:FindAbilityByName("slot"..i)
					if skill == nil then
							local target_skill = target:FindAbilityByName(ability_name)
								if target_skill == nil  then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level < 4 then
									target_skill:SetLevel(skill_level + 1)
									EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level >= 4 then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end	
							end
						end
					end
					if skill ~= nil then
						local skillswap = skill:GetName()
						local target_skill = target:FindAbilityByName(ability_name)
						if target_skill == nil  then
							target:AddAbility(ability_name):SetLevel(1)
							target:SwapAbilities(skillswap, ability_name, false, true)--:SetLevel(1)
							target:RemoveAbility(skillswap)--:SetLevel(1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)	
							break
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level < 4 then
							target_skill:SetLevel(skill_level + 1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level >= 4 then
							EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
					end
				end		
			end
		end	
	end
end

function add_ability_passive2(event)
	local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
			local target_name = target:GetUnitName()
			if target_name == "npc_main_base" then --or target_name == "npc_dota_hero_treant" then
			ability_name = Ability_tower_passive_lvl_2[RandomInt(1,#Ability_tower_passive_lvl_2)]	
				for i = 1, 20 do
				local skill = target:FindAbilityByName("slot"..i)
					if skill == nil then
							local target_skill = target:FindAbilityByName(ability_name)
								if target_skill == nil  then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level < 4 then
									target_skill:SetLevel(skill_level + 1)
									EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level >= 4 then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end	
							end
						end
					end
					if skill ~= nil then
						local skillswap = skill:GetName()
						local target_skill = target:FindAbilityByName(ability_name)
						if target_skill == nil  then
							target:AddAbility(ability_name):SetLevel(1)
							target:SwapAbilities(skillswap, ability_name, false, true)--:SetLevel(1)
							target:RemoveAbility(skillswap)--:SetLevel(1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)	
							break
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level < 4 then
							target_skill:SetLevel(skill_level + 1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level >= 4 then
							EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
					end
				end		
			end
		end	
	end
end


function add_ability_passive3(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
			local target_name = target:GetUnitName()
			if target_name == "npc_main_base" then --or target_name == "npc_dota_hero_treant" then
			ability_name = Ability_tower_passive_lvl_3[RandomInt(1,#Ability_tower_passive_lvl_3)]	
				for i = 1, 20 do
				local skill = target:FindAbilityByName("slot"..i)
					if skill == nil then
							local target_skill = target:FindAbilityByName(ability_name)
								if target_skill == nil  then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level < 4 then
									target_skill:SetLevel(skill_level + 1)
									EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level >= 4 then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end	
							end
						end
					end
					if skill ~= nil then
						local skillswap = skill:GetName()
						local target_skill = target:FindAbilityByName(ability_name)
						if target_skill == nil  then
							target:AddAbility(ability_name):SetLevel(1)
							target:SwapAbilities(skillswap, ability_name, false, true)--:SetLevel(1)
							target:RemoveAbility(skillswap)--:SetLevel(1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)	
							break
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level < 4 then
							target_skill:SetLevel(skill_level + 1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level >= 4 then
							EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
					end
				end		
			end
		end	
	end
end
	
function add_ability_passive4(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
			local target_name = target:GetUnitName()
			if target_name == "npc_main_base" then --or target_name == "npc_dota_hero_treant" then
			ability_name = Ability_tower_passive_lvl_4[RandomInt(1,#Ability_tower_passive_lvl_4)]	
				for i = 1, 20 do
				local skill = target:FindAbilityByName("slot"..i)
					if skill == nil then
							local target_skill = target:FindAbilityByName(ability_name)
								if target_skill == nil  then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level < 4 then
									target_skill:SetLevel(skill_level + 1)
									EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end
								if target_skill ~= nil  then
									local skill_level = target_skill:GetLevel()
									if skill_level >= 4 then
									EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
									UTIL_Remove(item)
									break 		
								end	
							end
						end
					end
					if skill ~= nil then
						local skillswap = skill:GetName()
						local target_skill = target:FindAbilityByName(ability_name)
						if target_skill == nil  then
							target:AddAbility(ability_name):SetLevel(1)
							target:SwapAbilities(skillswap, ability_name, false, true)--:SetLevel(1)
							target:RemoveAbility(skillswap)--:SetLevel(1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)	
							break
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level < 4 then
							target_skill:SetLevel(skill_level + 1)
							EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
						if target_skill ~= nil  then
							local skill_level = target_skill:GetLevel()
							if skill_level >= 4 then
							EmitSoundOnClient("soundboard.greevil_laughs", PlayerResource:GetPlayer(playerID))
							UTIL_Remove(item)
							break 		
						end
					end
				end		
			end
		end	
	end
end


function up_hp(event)
 		local caster = event.caster
		local target = event.target
		local item = event.ability 
		local hero = caster:GetOwner()
		local playerID = hero:GetPlayerID()
		
		local target_name = target:GetUnitName()
		
		if  target_name == "npc_main_base" then
			
			local health = target:GetBaseMaxHealth()
			local health2 = target:GetMaxHealth()	
			local mana2 = target:GetMaxMana()
			
			target:SetMaxHealth(health2 + 2000)	
			target:SetBaseMaxHealth(health + 2000)	
			target:SetMaxMana(mana2 + 200)	
			
			EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
			local new_charges = item:GetCurrentCharges() - 1
			event.ability:SetCurrentCharges(new_charges)
			if new_charges <= 0 then
			UTIL_Remove(item)	
		end
	elseif target_name == "npc_dota_hero_treant" then

		local currentStacks = target:GetModifierStackCount("modifier_hpstack", event.ability)
		local modifier = target:AddNewModifier(target, event.ability, "modifier_hpstack", nil)
		target:SetModifierStackCount("modifier_hpstack", target, (currentStacks + 1))
			EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
			local new_charges = item:GetCurrentCharges() - 1
			event.ability:SetCurrentCharges(new_charges)
			if new_charges <= 0 then
			UTIL_Remove(item)	
			end
	end
	
end

function up_dmg(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
					
			local target_name = target:GetUnitName()
			
			if  target_name == "npc_main_base" or target_name == "npc_dota_hero_treant"  then
			
				local mindmg = target:GetBaseDamageMin()
				local maxdmg = target:GetBaseDamageMax()	
				target:SetBaseDamageMin(mindmg + 100)
				target:SetBaseDamageMax(maxdmg + 100)
				EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
				local new_charges = item:GetCurrentCharges() - 1
				event.ability:SetCurrentCharges(new_charges)
				if new_charges <= 0 then
				UTIL_Remove(item)	
		end
	end
end

function up_armor(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
					
			local target_name = target:GetUnitName()
			
			if  target_name == "npc_main_base" or target_name == "npc_dota_hero_treant"  then
			
				local arm = target:GetPhysicalArmorBaseValue()
				target:SetPhysicalArmorBaseValue(arm + 5)	
				EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
				local new_charges = item:GetCurrentCharges() - 1
				event.ability:SetCurrentCharges(new_charges)
				if new_charges <= 0 then
				UTIL_Remove(item)	
		end
	end
end


function up_kit(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
					
			local target_name = target:GetUnitName()
			
			if  target_name == "npc_main_base" or target_name == "npc_dota_hero_treant"  then
			
				local mindmg = target:GetBaseDamageMin()
				local maxdmg = target:GetBaseDamageMax()	
				local arm = target:GetPhysicalArmorBaseValue()
				local health = target:GetBaseMaxHealth()
				local health2 = target:GetMaxHealth()		
				local mana2 = target:GetMaxMana()
				target:SetMaxMana(mana2 + 400)
				target:SetMaxHealth(health2 + 4000)	
				target:SetBaseMaxHealth(health + 4000)	
				target:SetPhysicalArmorBaseValue(arm + 10)	
				target:SetBaseDamageMin(mindmg + 200)
				target:SetBaseDamageMax(maxdmg + 200)
				EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
				local new_charges = item:GetCurrentCharges() - 1
				event.ability:SetCurrentCharges(new_charges)
				if new_charges <= 0 then
				UTIL_Remove(item)	
		end
	end
end


function up_speed(event)
			local caster = event.caster
			local target = event.target
			local item = event.ability 
			local hero = caster:GetOwner()
			local playerID = hero:GetPlayerID()
			local target_name = target:GetUnitName()
			
			if  target_name == "npc_main_base" or target_name == "npc_dota_hero_treant"  then
			
				target:AddNewModifier( target, nil, "modifier_attack_speed_towers", {} )
				
				local fleshHeapStackModifier = "modifier_attack_speed_towers"
				local currentStacks = target:GetModifierStackCount(fleshHeapStackModifier, target)
				target:SetModifierStackCount(fleshHeapStackModifier, target, (currentStacks + 1))
			
				EmitSoundOnClient("General.LevelUp.Bonus", PlayerResource:GetPlayer(playerID))
				local new_charges = item:GetCurrentCharges() - 1
				event.ability:SetCurrentCharges(new_charges)
				if new_charges <= 0 then
				UTIL_Remove(item)	
		end
	end
end

LinkLuaModifier("modifier_attack_speed_towers", "items/tower/up_ability", LUA_MODIFIER_MOTION_NONE)

modifier_attack_speed_towers = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
	{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end,
})

function modifier_attack_speed_towers:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*10
end