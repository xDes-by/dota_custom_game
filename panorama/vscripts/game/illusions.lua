LinkLuaModifier("modifier_icon_hidden", "libraries/modifiers/modifier_icon_hidden", LUA_MODIFIER_MOTION_NONE)

Illusions = Illusions or {}


Illusions.di_active_exceptions = {
	"phantom_lancer_phantom_edge"
}


Illusions.copy_exceptions = {
	["arc_warden_tempest_double_lua"] = 1,
	["monkey_king_wukongs_command_lua"] = 1,
	["meepo_divided_we_stand"] = 1,
}

Illusions.super_illusion_modifier = {				-- handle as super illusion if npc has these modifiers
	"modifier_vengefulspirit_hybrid_special",
}

Illusions.remove_exceptions = {
	bane_fiends_grip = true, -- illusions need this ability for Aghanim Scepter upgrade
}


function Illusions:HandleIllusion(npc)
	if not npc or npc:IsNull() then return end
	if not npc:IsHero() then return end

	local illusion_mod = npc:FindModifierByName("modifier_illusion")
	if not illusion_mod then return end

	local original_hero = illusion_mod:GetCaster()

	if not original_hero then return end

	if original_hero:HasModifier("modifier_hero_refreshing") and not npc:IsTempestDouble() and (npc.IsMonkeyClone and not npc:IsMonkeyClone()) then
		npc:ForceKill(true)
		return
	end
	
	npc:ModifyStrength(original_hero:GetBaseStrength() - npc:GetBaseStrength())
	npc:ModifyIntellect(original_hero:GetBaseIntellect() - npc:GetBaseIntellect())
	npc:ModifyAgility(original_hero:GetBaseAgility() - npc:GetBaseAgility())
	npc:AddNewModifier(npc, nil, "modifier_icon_hidden", {})

	local super_illusion_flag = false
	for _, modifier_name in pairs(Illusions.super_illusion_modifier) do
		if npc:HasModifier(modifier_name) then
			super_illusion_flag = true
			break
		end
	end

	if super_illusion_flag then
		self:HandleSuperIllusion(npc, original_hero, false)
	else
		self:HandleDefaultIllusion(npc, original_hero)
	end
end


function Illusions:HandleDefaultIllusion(npc, original_hero)
	if not original_hero.passive_abilities then return end

	for i = 0, 12 do
		local ability = npc:GetAbilityByIndex(i)
		if ability then
			local ability_name = ability:GetAbilityName()
			if not string.find(ability_name, "special_bonus") and not self.remove_exceptions[ability_name] then
				npc:RemoveAbility(ability_name)
			end
		end
	end

	for ability_name, level in pairs(original_hero.passive_abilities) do
		local new_ability = npc:AddAbility(ability_name)
		new_ability:ClearFalseInnateModifiers()
		new_ability:SetLevel(level)
	end

	npc.passive_abilities = original_hero.passive_abilities

	for _, ability_name in pairs(self.di_active_exceptions) do
		local ability = original_hero:FindAbilityByName(ability_name)
		if ability and not ability:IsHidden() then
			local new_ability = npc:AddAbility(ability_name)
			new_ability:SetLevel(ability:GetLevel())
		end
	end
end


function Illusions:HandleSuperIllusion(npc, original_hero, process_items)
	AbilityCharges:InitHero(npc)

	for slot = 0, original_hero:GetAbilityCount() - 1 do
		Illusions:ProcessAbilitySlot(slot, npc, original_hero)
	end

	if process_items then
		for slot = 0, 5 do
			Illusions:ProcessItemSlot(slot, npc, original_hero)
		end
	end

	while npc:GetLevel() < original_hero:GetLevel() do
		npc:HeroLevelUp(false)
	end

	npc.passive_abilities = original_hero.passive_abilities
end


function Illusions:ProcessAbilitySlot(slot, npc, original_hero)
	local illusion_slot_ability = npc:GetAbilityByIndex(slot)
	local illusion_slot_ability_name
	
	if illusion_slot_ability then
		illusion_slot_ability_name = illusion_slot_ability:GetAbilityName()
		local original_ability = original_hero:FindAbilityByName(illusion_slot_ability_name)
		if not original_ability or original_ability.removal_timer then 
			illusion_slot_ability:ClearFalseInnateModifiers()
			npc:RemoveAbility(illusion_slot_ability_name)
		end
	end

	local original_ability = original_hero:GetAbilityByIndex(slot)
	if not original_ability or original_ability:IsNull() then return end
	if original_ability.placeholder then return end
	local original_name = original_ability:GetAbilityName()

	local illusion_ability = npc:FindAbilityByName(original_name)
	
	if illusion_ability then
		local illusion_ability_name = illusion_ability:GetAbilityName()
		if illusion_ability_name ~= "special_bonus_attributes" and illusion_ability_name:find("special_bonus_") then
			if original_ability:GetLevel() > 0 then
				npc:SetAbilityPoints(1)
				ExecuteOrderFromTable({
					UnitIndex = npc:entindex(),
					OrderType = DOTA_UNIT_ORDER_TRAIN_ABILITY,
					AbilityIndex = illusion_ability:entindex(),
				})
				npc:SetAbilityPoints(0)
			end
		else
			if original_ability:GetLevel() ~= illusion_ability:GetLevel() then
				illusion_ability:SetLevel(original_ability:GetLevel())
			end
		end
		AbilityCharges:OnAbilityAdded(illusion_ability)
	else
		self:AddIllusionAbility(npc, original_name, original_ability)
	end
end


function Illusions:AddIllusionAbility(npc, ability_name, original_ability)
	if self.copy_exceptions[ability_name] then return end

	--dont give ability to illusion if original retrained and hidden
	if original_ability.removal_timer then return end

	local original_level = original_ability:GetLevel()
	if original_level == 0 and ability_name == "weaver_geminate_attack" then return end --weaver_geminate_attack at level 0 can cause infinite attack bug

	ability = npc:AddAbility(ability_name)

	ability:ClearFalseInnateModifiers()
	ability:SetHidden(original_ability:IsHidden())

	if original_level > 0 then
		ability:SetLevel(original_level)
	end

	if HeroBuilder.linked_abilities[ability_name] then
		for _, linked_ability_name in ipairs(HeroBuilder.linked_abilities[ability_name]) do
			if not npc:HasAbility(linked_ability_name) then
				local linked_ability = npc:AddAbility(linked_ability_name)
				if linked_ability_name == "lone_druid_true_form_druid" or linked_ability_name == "lone_druid_true_form_battle_cry" then
					linked_ability:SetHidden(false)
				end
				if HeroBuilder.linked_abilities_level[linked_ability_name]>0 then
					linked_ability:SetLevel(HeroBuilder.linked_abilities_level[linked_ability_name])
				else
					-- Matching skills should be the same as the main skill level      
					if HeroBuilder.linked_abilities_level[linked_ability_name] > 0 then
						linked_ability:SetLevel(HeroBuilder.linked_abilities_level[linked_ability_name])
					end
				end
			end
		end
	end

	AbilityCharges:OnAbilityAdded(ability)
end


function Illusions:ProcessItemSlot(slot, npc, original_hero)
	local item = original_hero:GetItemInSlot(slot)
	local ill_item = npc:GetItemInSlot(slot)

	if ill_item and item then
		if item:GetAbilityName() == ill_item:GetAbilityName() then return end
		npc:RemoveItem(ill_item)
	end

	if item and not item:IsNull() then
		npc:AddItemByName(item:GetAbilityName())
	end
end
