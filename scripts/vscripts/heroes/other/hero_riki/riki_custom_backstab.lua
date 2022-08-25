function BlinkStrike( keys )
        local caster = keys.caster
        local target = keys.target
        local ability = keys.ability
		
			if ability == nil then 
			if caster:HasModifier("riki_custom_backstab_buff")
			then caster:RemoveModifierByName("riki_custom_backstab_buff")
			end
			end
			
			if ability ~= nil then
		
        local proc_chance = ability:GetSpecialValueFor("chance")
        local talent = caster:FindAbilityByName("special_bonus_unique_riki_custom_backstab")
        if talent and talent:GetLevel() > 0 then
            proc_chance = proc_chance + talent:GetSpecialValueFor("value")
        end
        if RollPercentage( proc_chance ) then
            -- Ability variables
            local victim_angle = target:GetAnglesAsVector()
            local victim_forward_vector = target:GetForwardVector()
            
            -- Angle and positioning variables
            local victim_angle_rad = victim_angle.y*math.pi/180
            local victim_position = target:GetAbsOrigin()
            local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
            
            
            -- Sets Riki behind the victim and facing it
            caster:SetAbsOrigin(attacker_new)
            FindClearSpaceForUnit(caster, attacker_new, true)
            caster:SetForwardVector(victim_forward_vector)
        end
    end
	end
    