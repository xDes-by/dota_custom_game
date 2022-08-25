function web_start_charge( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster.web_maximum_charges = ability:GetCurrentAbilityCharges()
	caster.web_maximum_webs = ability:GetLevelSpecialValueFor("count", (ability:GetLevel() - 1))

	if caster.web_current_webs == nil then caster.web_current_webs = 0 end
	if caster.web_table == nil then caster.web_table = {} end

	if keys.ability:GetLevel() ~= 1 then return end
	
	local modifierName = "modifier_web_stack_counter_datadriven"
	local charge_replenish_time = 0
	
	caster:SetModifierStackCount( modifierName, ability, 0 )
	caster.web_charges = caster.web_maximum_charges
	caster.start_charge = false
	caster.web_cooldown = 0.0
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, ability, caster.web_maximum_charges )
	
	Timers:CreateTimer( function()
			if caster.start_charge and caster.web_charges < caster.web_maximum_charges then
				local next_charge = caster.web_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= caster.web_maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, ability, next_charge )			
				caster.web_charges = next_charge
			end
			
			if caster.web_charges ~= caster.web_maximum_charges then
				caster.start_charge = true
				ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
				return charge_replenish_time
			else
				return 0.5
			end
	end)
end


function spin_web( keys )
	local caster = keys.caster
	if caster.web_charges > 0 then

		local target = keys.target_points[1]
		local ability = keys.ability
		local player = caster:GetPlayerID()

		local dummy_modifier = keys.dummy_modifier
		local dummy_ability = keys.dummy_ability

		local maximum_charges = ability:GetCurrentAbilityCharges()
		local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_restore_time", ( ability:GetLevel() - 1 ) )

		local dummy = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeam())
		ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {})
		dummy:SetControllableByPlayer(player, true)
		
		if dummy_ability ~= nil then
			dummy:AddAbility(dummy_ability)
			dummy_ability = dummy:FindAbilityByName(dummy_ability)
			dummy_ability:SetLevel(1)
		end

		table.insert(caster.web_table, dummy)
		caster.web_current_webs = caster.web_current_webs + 1

		if caster.web_current_webs > caster.web_maximum_webs then
			caster.web_table[1]:RemoveSelf()
			table.remove(caster.web_table, 1)
			caster.web_current_webs = caster.web_current_webs - 1
		end
		
		local next_charge = caster.web_charges - 1
		if caster.web_charges == maximum_charges then end

		caster.web_charges = next_charge
		
		if caster.web_charges == 0 then
		
		else
			ability:EndCooldown()
		end
	else
		keys.ability:RefundManaCost()
	end
end


function spin_web_destroy( keys )
	local caster = keys.caster
	local caster_owner = caster:GetOwner()

	for i = 1, #caster_owner.web_table do
		if caster_owner.web_table[i] == caster then
			caster_owner.web_table[i]:RemoveSelf()
			table.remove(caster_owner.web_table, i)
			caster_owner.web_current_webs = caster_owner.web_current_webs - 1
			return
		end
	end
end


function check_units( keys )
	local caster = keys.caster
	local ability = keys.ability
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)	  
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(enemy, enemy, "modifier_slow", {duration = 0.3})
		end
		
	local allyes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)	  
		for _,ally in pairs(allyes) do
			if ally:GetUnitName() == "npc_dota_hero_broodmother" or ally:GetUnitName() == "brood_spiders" then
				ability:ApplyDataDrivenModifier(ally, ally, "modifier_fast", {duration = 0.3})
			end
		end	
end