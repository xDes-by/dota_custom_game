function CheckBackstab(params)
	
	local ability = params.ability
	local caster = params.caster
	
			if ability == nil then 
			if caster:HasModifier("modifier_permanent_invisibility_datadriven")
			then caster:RemoveModifierByName("modifier_permanent_invisibility_datadriven")
			end
			if caster:HasModifier("modifier_backstab_datadriven")
			then caster:RemoveModifierByName("modifier_backstab_datadriven")
			end
			if caster:HasModifier("modifier_invisibility_fade_datadriven")
			then caster:RemoveModifierByName("modifier_invisibility_fade_datadriven")
			end
			end
			
			if ability ~= nil then
			
	params.ability:ApplyDataDrivenModifier(params.caster, params.caster, "modifier_invisibility_fade_datadriven", {duration = ability:GetLevelSpecialValueFor("fade_time", ability:GetLevel() - 1)})
	
	local agility_damage_multiplier = ability:GetLevelSpecialValueFor("agility_damage", ability:GetLevel() - 1) / 100
	

	local victim_angle = params.target:GetAnglesAsVector().y
	local origin_difference = params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()


	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	

	origin_difference_radian = origin_difference_radian * 180
	local attacker_angle = origin_difference_radian / math.pi

	attacker_angle = attacker_angle + 180.0
	

	local result_angle = attacker_angle - victim_angle
	result_angle = math.abs(result_angle)
	

	if result_angle >= (180 - (ability:GetSpecialValueFor("backstab_angle") / 2)) and result_angle <= (180 + (ability:GetSpecialValueFor("backstab_angle") / 2)) then 

		EmitSoundOn(params.sound, params.target)

		local particle = ParticleManager:CreateParticle(params.particle, PATTACH_ABSORIGIN_FOLLOW, params.target) 

		ParticleManager:SetParticleControlEnt(particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true) 

		ApplyDamage({victim = params.target, attacker = params.attacker, damage = params.attacker:GetAgility() * agility_damage_multiplier, damage_type = ability:GetAbilityDamageType()})

	end
end
end

function addmod(params)
	local ability = params.ability
	local caster = params.caster
	
	if ability == nil then 
			if caster:HasModifier("modifier_permanent_invisibility_datadriven")
			then caster:RemoveModifierByName("modifier_permanent_invisibility_datadriven")
			end
			if caster:HasModifier("modifier_backstab_datadriven")
			then caster:RemoveModifierByName("modifier_backstab_datadriven")
			end
			if caster:HasModifier("modifier_invisibility_fade_datadriven")
			then caster:RemoveModifierByName("modifier_invisibility_fade_datadriven")
			end
			end
			
			if ability ~= nil then
		
	
	params.ability:ApplyDataDrivenModifier(params.caster, params.caster, "modifier_permanent_invisibility_datadriven", {})
	params.ability:ApplyDataDrivenModifier(params.caster, params.caster, "modifier_invisible", {})

	end
end