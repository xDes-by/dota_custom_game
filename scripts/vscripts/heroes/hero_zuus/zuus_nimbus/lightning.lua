function LightningJump(keys)
	local caster = keys.caster
	local owner = caster:GetOwner()
	local target = keys.target
	local ability = keys.ability
	local jump_delay = ability:GetLevelSpecialValueFor("jump_delay", (ability:GetLevel() -1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local damage_lighing = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				local abil = owner:FindAbilityByName("npc_dota_hero_zuus_agi11")	
				if abil ~= nil then 
			--	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				damage_lighing = owner:GetAgility()
				end
	

	ApplyDamage({victim = target, attacker = caster, damage = damage_lighing, damage_type = ability:GetAbilityDamageType(),damage_flags = damage_flags})
	target:RemoveModifierByName("modifier_arc_lightning_datadriven")

	Timers:CreateTimer(jump_delay,
    function()
		local current
		for i=0,ability.instance do
			if ability.target[i] ~= nil then
				if ability.target[i] == target then
					current = i
				end
			end
		end
	
		if target.hit == nil then
			target.hit = {}
		end
		target.hit[current] = true
		ability.jump_count[current] = ability.jump_count[current] - 1

		if ability.jump_count[current] > 0 then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
			local closest = radius
			local new_target
			for i,unit in ipairs(units) do
				local unit_location = unit:GetAbsOrigin()
				local vector_distance = target:GetAbsOrigin() - unit_location
				local distance = (vector_distance):Length2D()
				if distance < closest then
					if unit.hit == nil then
						new_target = unit
						closest = distance
					elseif unit.hit[current] == nil then
						new_target = unit
						closest = distance
					end
				end
			end
			if new_target ~= nil then
				-- Creates the particle between the new target and the last target
				local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
				-- Sets the new target as the current target for this instance
				ability.target[current] = new_target
				-- Applies the modifer to the new target, which runs this function on it
				ability:ApplyDataDrivenModifier(caster, new_target, "modifier_arc_lightning_datadriven", {})
			else
				-- If there are no new targets, we set the current target to nil to indicate this instance is over
				ability.target[current] = nil
			end
		else
			-- If there are no more jumps, we set the current target to nil to indicate this instance is over
			ability.target[current] = nil
		end
	end)
end

--[[Author: YOLOSPAGHETTI
	Date: March 24, 2016
	Keeps track of all instances of the spell (since more than one can be active at once)]]
function NewInstance(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	-- Keeps track of the total number of instances of the ability (increments on cast)
	if ability.instance == nil then
		ability.instance = 0
		ability.jump_count = {}
		ability.target = {}
	else
		ability.instance = ability.instance + 1
	end
	
	-- Sets the total number of jumps for this instance (to be decremented later)
	ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1))
	-- Sets the first target as the current target for this instance
	ability.target[ability.instance] = target
	
	-- Creates the particle between the caster and the first target
	local lightningBolt = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
end
