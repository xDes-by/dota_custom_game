function PudgeCastAcidSpray(data)
	local ability = data.caster:FindAbilityByName("boss_2_spray")
	local point = data.caster:GetOrigin()
	data.caster:CastAbilityOnPosition(point, ability, -1 )
	data.caster:ForceKill(false)
	StartSoundEvent("Hero_LifeStealer.Assimilate.Destroy", data.caster)
end

---------------------------------------------------------------------------------

function stack_created(params)
	local parent = params.target
	local modifier_ui_handle = parent:FindModifierByName("modifier_quill_spray_datadriven_user_display")

	if modifier_ui_handle == nil then
		params.ability:ApplyDataDrivenModifier(params.caster, parent, "modifier_quill_spray_datadriven_user_display", nil)
		modifier_ui_handle = parent:FindModifierByName("modifier_quill_spray_datadriven_user_display")
	end

	local final_damage = params.base_damage + (params.stack_damage * modifier_ui_handle:GetStackCount())

	if final_damage > params.max_damage then
		final_damage = params.max_damage
	end
	
	local damage_table =
	{
		victim = parent,
		attacker = params.caster,
		damage = final_damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = params.ability,
	}

	ApplyDamage(damage_table)

	modifier_ui_handle:IncrementStackCount()
	modifier_ui_handle:SetDuration(params.stack_duration, true)
end

function stack_destroyed(params)
	local parent = params.target
	local modifier_ui_handle = parent:FindModifierByName("modifier_quill_spray_datadriven_user_display")

	if modifier_ui_handle ~= nil then
		-- If the unit still has Quill Spray stacks, just decrement the visual counter.
		if modifier_ui_handle:GetStackCount() > 1 then
			modifier_ui_handle:DecrementStackCount()
		-- If the unit has no more Quill Spray stacks, destroy the visual counter.
		elseif modifier_ui_handle:GetStackCount() == 1 then
			modifier_ui_handle:Destroy()
		end
	end
end

function determine_debuff(params)
	params.ability:ApplyDataDrivenModifier(params.caster, params.target, "modifier_quill_spray_datadriven_stack_hero", {duration = params.stack_duration})
end