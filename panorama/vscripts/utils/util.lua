if Util == nil then Util = class({}) end

function DoesHeroHaveFreeSlotInInventory(unit)
	for i = 0, 8 do -- 0-8 inventory, 9-14 stash, 15 - tp scroll, 16 - neutral slot
		if unit:GetItemInSlot(i) == nil then
			return i
		end
	end
	return false
end


function DoesHeroHasFreeSlotForNeutral(unit)
	for i = 6, 14 do -- 0-8 inventory, 9-14 stash, 15 - tp scroll, 16 - neutral slot
		if unit:GetItemInSlot(i) == nil then
			return i
		end
	end
	if unit:GetItemInSlot(16) == nil then
		return 16
	end
	return false
end


function Util:FindAllOwnedUnitsANDDIE(player)
	local summons = {}
	local pid = type(player) == "number" and player or player:GetPlayerID()
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	local units = FindUnitsInRadius(PlayerResource:GetTeam(pid), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
	for _,v in ipairs(units) do
		if type(player) == "number" and ((v.GetPlayerID ~= nil and v:GetPlayerID() or v:GetPlayerOwnerID()) == pid) or v:GetPlayerOwner() == player then
			if not v:HasModifier("modifier_dummy_unit") and v ~= hero then
				table.insert(summons, v)
			end
		end
	end
	return summons
end


function Util:FindAllOwnedUnits(player)
	local summons = {}
	local pid = type(player) == "number" and player or player:GetPlayerID()
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	local units = FindUnitsInRadius(PlayerResource:GetTeam(pid), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
	for _,v in ipairs(units) do
		if type(player) == "number" and ((v.GetPlayerID ~= nil and v:GetPlayerID() or v:GetPlayerOwnerID()) == pid) or v:GetPlayerOwner() == player then
			if not v:HasModifier("modifier_dummy_unit") and v ~= hero then
				table.insert(summons, v)
			end
		end
	end
	return summons
end


function Util:TableToString(t)
	if "table"~=type(t) then error("tableToString: argument is not a table") end
	
	function loopPrevention(t, root)
		if "string"==type(t) then return '"'.. t ..'"' end
		if "table"~=type(t) then return t end
		if t==root then return "root" end
		root = root or t
		local out = "{"
		for k,v in pairs(t) do
			local typ = type(k)
			if "string"==typ then
				out = out ..'["' .. k .. '"] = '
			elseif "number"==typ then
				out = out .. '[' .. k .. '] = '
			else
				error("tableToString: only accepts number or string keys")
			end
			out = out .. loopPrevention(v,root) .. ","
		end
		out = out .. "}"
		return out
	end

	return loopPrevention(t)
end

--Refresh skills and items
function Util:RefreshAbilityAndItem(hero, exceptions)
	if not hero or hero:IsNull() then return end
	
	if not exceptions then
		exceptions = {}
	end

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and (not exceptions[ability:GetAbilityName()]) then
			ability:RefreshCharges()
			if ability._RefreshCharges then
				ability:_RefreshCharges() -- also refresh custom charges
			end
			ability:EndCooldown()
		end
	end

	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_MAX do
		local item = hero:GetItemInSlot(i)
		if item and (not exceptions[item:GetAbilityName()]) then
			local purchaser = item:GetPurchaser()
			if not purchaser or purchaser:GetPlayerOwnerID() == hero:GetPlayerOwnerID() then
				item:EndCooldown()
			end
		end
	end
end


-- Clean up modifiers that affect teleportation
function Util:RemoveMovementModifiers(hero)
	hero:Stop()
	hero:InterruptMotionControllers(false)

	hero:RemoveModifierByName("modifier_pudge_swallow_hide")
	hero:RemoveModifierByName("modifier_pudge_meat_hook")
	hero:RemoveModifierByName("modifier_magnataur_skewer_movement")
	hero:RemoveModifierByName("modifier_phoenix_icarus_dive")
	hero:RemoveModifierByName("modifier_mirana_leap")
	hero:RemoveModifierByName("modifier_kunkka_x_marks_the_spot")
	hero:RemoveModifierByName("modifier_kunkka_x_marks_the_spot_thinker")
	hero:RemoveModifierByName("modifier_riki_tricks_of_the_trade_phase")
	hero:RemoveModifierByName("modifier_monkey_king_bounce_perch")
	hero:RemoveModifierByName("modifier_void_spirit_dissimilate_phase")
	hero:RemoveModifierByName("modifier_monkey_king_bounce_leap")
	hero:RemoveModifierByName("modifier_monkey_king_tree_dance_activity")
	hero:RemoveModifierByName("modifier_sandking_burrowstrike")
	hero:RemoveModifierByName("modifier_creature_tornado")
	hero:RemoveModifierByName("modifier_lifestealer_infest_caster")
	hero:RemoveModifierByName("modifier_phantomlancer_dopplewalk_phase")
	hero:RemoveModifierByName("modifier_invoker_tornado")

	-- Delayed effects
	if hero:HasModifier("modifier_oracle_false_promise") then
		Timers:CreateTimer(1, function()
			hero:RemoveModifierByName("modifier_oracle_false_promise")
		end)
	end
	
	if hero:FindAbilityByName("puck_ethereal_jaunt") then
		hero:FindAbilityByName("puck_ethereal_jaunt"):SetActivated(false)

		Timers:CreateTimer(3, function()
			if hero:FindAbilityByName("puck_ethereal_jaunt") then
				hero:FindAbilityByName("puck_ethereal_jaunt"):SetActivated(true)
			end
		end)
	end
end


function Util:RemoveAbilityClean(hero, ability_name)
	if ability_name == "broodmother_spin_web" then
		Util:CleanWeb(hero)
	end

	if ability_name == "witch_doctor_death_ward" then
		Util:CleanDeathWard(hero)
	end

	if ability_name == "visage_summon_familiars" then
		Util:CleanFamiliar(hero)
	end
end


-- Clean up spider web
function Util:CleanWeb(hero)
	-- Clean up spider web
	local webs = Entities:FindAllByName("npc_dota_broodmother_web")
	for _, web in pairs(webs) do
		if web:GetOwner() == hero then
			UTIL_Remove(web)
		end
	end
end


-- Clean up the death guard
function Util:CleanDeathWard(hero)
	local wards = Entities:FindAllByName("npc_dota_witch_doctor_death_ward")
	for _, ward in pairs(wards) do
		if ward:GetOwner() == hero then
			UTIL_Remove(ward)
		end
	end
end


function Util:CleanFamiliar(hero)
	local familiars = Entities:FindAllByName("npc_dota_visage_familiar")
	for _, familiar in pairs(familiars) do
		if familiar:GetOwner() == hero then
			familiar:ForceKill(false)
		end
	end
end


function Util:ListAbilities(hero)
	for i=0, 25 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			print("INDEX:", i, "Ability: ", ability:GetName(), "Hidden:", ability:IsHidden(), "Index:", ability:GetAbilityIndex())
		else
			print("INDEX", i, "IS EMPTY")
		end
	end
end


function Util:IsReincarnationWork(hero)

    local bSkeletonKingReincarnationWork = false
    if hero:HasAbility("skeleton_king_reincarnation") then
         local ability = hero:FindAbilityByName("skeleton_king_reincarnation")
         if ability:GetLevel() > 0 then
           --刚刚触发
           if ability:GetCooldownTimeRemaining() == ability:GetEffectiveCooldown(ability:GetLevel()-1) then
              bSkeletonKingReincarnationWork = true 
           end
       end
    end

    return bSkeletonKingReincarnationWork

end


function CopyItem(item)
	if not item or item:IsNull() then return end
	local newItem = CreateItem(item:GetAbilityName(), nil, nil)
	newItem:SetPurchaseTime(item:GetPurchaseTime())
	newItem:SetPurchaser(item:GetPurchaser())
	newItem:SetOwner(item:GetOwner())
	newItem:SetCurrentCharges(item:GetCurrentCharges())
	return newItem
end


function Util:CastAdditionalAbility(caster, ability, target, delay, channelData)
	if not caster or caster:IsNull() or not caster.GetPlayerID then return end
	local skill = ability
	local unit = caster
	if (not skill) or (not ability) or skill:IsNull() or ability:IsNull() then return end
	local channelTime = ability:GetChannelTime() or 0
	if channelTime > 0 then
		if not caster.dummy_casters then
			caster.dummy_casters = {}
			caster.nextFreeDummyCaster = 1
			for i = 1, 3 do
				local dummy = CreateUnitByName("npc_dummy_caster", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
				dummy:SetControllableByPlayer(caster:GetPlayerID(), true)
				dummy:AddNoDraw()
				dummy:AddNewModifier(dummy, nil, "modifier_hidden_caster_dummy", {})
				dummy:MakeIllusion()
				table.insert(caster.dummy_casters, dummy)
			end
		end
		local dummy = caster.dummy_casters[caster.nextFreeDummyCaster]
		if not dummy or dummy:IsNull() then return end
		skill = nil
		caster.nextFreeDummyCaster = caster.nextFreeDummyCaster % #caster.dummy_casters + 1
		local abilityName = ability:GetName()
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
			local ditem = dummy:GetItemInSlot(i)
			if ditem then
				ditem:Destroy()
			end
			local citem = caster:GetItemInSlot(i)
			if citem then
				Timers:CreateTimer(0.01, function()
					if not IsValidEntity(dummy) then return end
					for j = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
						if dummy:GetItemInSlot(j) == nil then
							local copy = CopyItem(citem)
							if copy then
								local newditem = dummy:AddItem(copy)
								if newditem:GetName() == abilityName then
									skill = newditem
								end
							end
							return nil
						end
					end
					return 0.05
				end)
			end
		end
		dummy.IsRealHero = function() return false end -- ensure this wont interfere duels or whatever
		dummy:SetOwner(caster)
		dummy:SetAbsOrigin(caster:GetAbsOrigin())
		dummy:SetBaseStrength(caster:GetStrength())
		dummy:SetBaseAgility(caster:GetAgility())
		dummy:SetBaseIntellect(caster:GetIntellect())
		for _, v in pairs(caster:FindAllModifiers()) do
			local buffName = v:GetName()
			local buffAbility = v:GetAbility()
			local dummyModifier = dummy:FindModifierByName(buffName) or dummy:AddNewModifier(dummy, buffAbility, buffName, {duration = v:GetRemainingTime()})
			if dummyModifier then dummyModifier:SetStackCount(v:GetStackCount()) end
		end
		Util:_copyAbilities(caster, dummy)
		
		skill = skill or dummy:FindAbilityByName(ability:GetName())
		if skill and not skill:IsNull() then
			skill:SetLevel(ability:GetLevel())
			skill.GetCaster = function() return ability:GetCaster() end
		end

		unit = dummy
	end
	if not skill then return end
	if skill:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
		if target and type(target) == "table" then
			unit:SetCursorCastTarget(target)
		end
	end
	if skill:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) then
		if target then
			if target.x and target.y and target.z then
				unit:SetCursorPosition(target)
			elseif target.GetOrigin then
				unit:SetCursorPosition(target:GetOrigin())
			end
		end
	end
	skill:OnSpellStart()
	if channelTime > 0 then
		if channelData.endTime then
			EndAdditionalAbilityChannel(caster, unit, skill, channelData.channelFailed, delay - GameRules:GetGameTime() + channelData.endTime)
		else
			caster:AddEndChannelListener(function(interrupted)
				EndAdditionalAbilityChannel(caster, unit, skill, interrupted, delay)
			end)
		end
	end
end

function EndAdditionalAbilityChannel(caster, unit, skill, interrupted, delay)
	Timers:CreateTimer(delay, function()
		FindClearSpaceForUnit(unit, caster:GetOrigin() - caster:GetForwardVector(), false)
		if not skill or skill:IsNull() then return end
		skill:EndChannel(interrupted)
		skill:OnChannelFinish(interrupted)
		unit:Stop()
		unit:InterruptChannel()
		unit:Interrupt()
		unit:SetOrigin(Vector(7000,7000,120))
	end)
end

function Util:_copyAbilities(unit, illusion)
	for slot = 0, unit:GetAbilityCount() - 1 do
		local illusionAbility = illusion:GetAbilityByIndex(slot)
		local unitAbility = unit:GetAbilityByIndex(slot)

		if unitAbility then
			local newName = unitAbility:GetAbilityName()
			if illusionAbility then
				if illusionAbility:GetAbilityName() ~= newName then
					illusion:RemoveAbility(illusionAbility:GetAbilityName())
					illusionAbility = illusion:AddNewAbility(newName)
				end
			else
				illusionAbility = illusion:AddNewAbility(newName)
			end
			illusionAbility:SetHidden(unitAbility:IsHidden())
			local ualevel = unitAbility:GetLevel()
			if ualevel > 0 and illusionAbility:GetAbilityName() ~= "meepo_divided_we_stand" then
				illusionAbility:SetLevel(ualevel)
			end
		elseif illusionAbility then
			illusion:RemoveAbility(illusionAbility:GetAbilityName())
		end
	end
end

