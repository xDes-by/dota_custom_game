LinkLuaModifier( "modifier_shadow_fiend_shadowraze_lua", "heroes/hero_nevermore/shadow_fiend_shadowraze_lua/modifier_shadow_fiend_shadowraze_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
shadow_fiend_shadowraze_a_lua = class({})
shadow_fiend_shadowraze_b_lua = class({})
shadow_fiend_shadowraze_c_lua = class({})

function shadow_fiend_shadowraze_a_lua:OnSpellStart()
	shadowraze.OnSpellStart( self )
end

function shadow_fiend_shadowraze_b_lua:OnSpellStart()
	shadowraze.OnSpellStart( self )        
end

function shadow_fiend_shadowraze_c_lua:OnSpellStart()
	shadowraze.OnSpellStart( self )	
end

------------------------------------------------------------------------------------

function shadow_fiend_shadowraze_a_lua:GetManaCost(iLevel)  
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_nevermore_int50") ~= nil then 
        return 0
    end        
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int8") ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function shadow_fiend_shadowraze_b_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_nevermore_int50") ~= nil then 
        return 0
    end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int8") ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function shadow_fiend_shadowraze_c_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_nevermore_int50") ~= nil then 
        return 0
    end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_int8") ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

--------------------------------------------------------------------------------

if shadowraze==nil then
	shadowraze = {}
end

-----------------------------------------------------------------------------


function shadowraze.OnSpellStart( this )
	local caster = this:GetCaster()
	local distance = this:GetSpecialValueFor("shadowraze_range")
	local front = this:GetCaster():GetForwardVector():Normalized()
	local target_pos = this:GetCaster():GetOrigin() + front * distance
	local target_radius = this:GetSpecialValueFor("shadowraze_radius")
	local base_damage = this:GetSpecialValueFor("shadowraze_damage")
	local stack_damage = this:GetSpecialValueFor("stack_bonus_damage")
	local stack_duration = this:GetSpecialValueFor("duration")
	
	local modifier = caster:FindModifierByNameAndCaster( "modifier_shadow_fiend_necromastery_lua", caster )
	
	if caster:FindAbilityByName("npc_dota_hero_nevermore_int6") ~= nil then 
		if modifier ~=nil then
			base_damage = base_damage + modifier:GetStackCount() * 2
		end
	end
	if caster:FindAbilityByName("npc_dota_hero_nevermore_int_last") ~= nil then 
		if modifier ~=nil then
			base_damage = base_damage + modifier:GetStackCount() * 3
		end
	end
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
	if caster:FindAbilityByName("npc_dota_hero_nevermore_int10") ~= nil then 
		if this:GetName() == "shadow_fiend_shadowraze_a_lua" then
		local distance1 = 450
		local target_pos1 = this:GetCaster():GetOrigin() + front * distance1
		local distance2 = 700
		local target_pos2 = this:GetCaster():GetOrigin() + front * distance2
		
			local enemies = FindUnitsInRadius(
			this:GetCaster():GetTeamNumber(),
			target_pos1,
			nil,
			target_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- for each affected enemies
		for _,enemy in pairs(enemies) do
			-- Get Stack
			local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
			local stack = 0
			if modifier~=nil then
				stack = modifier:GetStackCount()
			end

			-- Apply damage
			local damageTable = {
				victim = enemy,
				attacker = this:GetCaster(),
				damage = base_damage + stack * stack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damageTable )

			if modifier==nil then
				enemy:AddNewModifier(
					this:GetCaster(),
					this,
					"modifier_shadow_fiend_shadowraze_lua",
					{duration = stack_duration}
				)
			else
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Effects
		shadowraze.PlayEffects( this, target_pos1, target_radius )	
		
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

		local enemies = FindUnitsInRadius(
			this:GetCaster():GetTeamNumber(),
			target_pos2,
			nil,
			target_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- for each affected enemies
		for _,enemy in pairs(enemies) do
			-- Get Stack
			local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
			local stack = 0
			if modifier~=nil then
				stack = modifier:GetStackCount()
			end

			-- Apply damage
			local damageTable = {
				victim = enemy,
				attacker = this:GetCaster(),
				damage = base_damage + stack*stack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damageTable )

			if modifier==nil then
				enemy:AddNewModifier(
					this:GetCaster(),
					this,
					"modifier_shadow_fiend_shadowraze_lua",
					{duration = stack_duration}
				)
			else
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Effects
		shadowraze.PlayEffects( this, target_pos2, target_radius )	
		end
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------		
		if this:GetName() == "shadow_fiend_shadowraze_b_lua" then
		local distance1 = 200
		local target_pos1 = this:GetCaster():GetOrigin() + front * distance1
		local distance2 = 700
		local target_pos2 = this:GetCaster():GetOrigin() + front * distance2
		
			local enemies = FindUnitsInRadius(
			this:GetCaster():GetTeamNumber(),
			target_pos1,
			nil,
			target_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- for each affected enemies
		for _,enemy in pairs(enemies) do
			-- Get Stack
			local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
			local stack = 0
			if modifier~=nil then
				stack = modifier:GetStackCount()
			end

			-- Apply damage
			local damageTable = {
				victim = enemy,
				attacker = this:GetCaster(),
				damage = base_damage + stack*stack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damageTable )

			if modifier==nil then
				enemy:AddNewModifier(
					this:GetCaster(),
					this,
					"modifier_shadow_fiend_shadowraze_lua",
					{duration = stack_duration}
				)
			else
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Effects
		shadowraze.PlayEffects( this, target_pos1, target_radius )	
		
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

		local enemies = FindUnitsInRadius(
			this:GetCaster():GetTeamNumber(),
			target_pos2,
			nil,
			target_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- for each affected enemies
		for _,enemy in pairs(enemies) do
			-- Get Stack
			local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
			local stack = 0
			if modifier~=nil then
				stack = modifier:GetStackCount()
			end

			-- Apply damage
			local damageTable = {
				victim = enemy,
				attacker = this:GetCaster(),
				damage = base_damage + stack*stack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damageTable )

			if modifier==nil then
				enemy:AddNewModifier(
					this:GetCaster(),
					this,
					"modifier_shadow_fiend_shadowraze_lua",
					{duration = stack_duration}
				)
			else
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Effects
		shadowraze.PlayEffects( this, target_pos2, target_radius )	
		end
-----------------------------------------------------------------------------------------------------------------------------------------------------		
-----------------------------------------------------------------------------------------------------------------------------------------------------
if this:GetName() == "shadow_fiend_shadowraze_c_lua" then
		local distance1 = 200
		local target_pos1 = this:GetCaster():GetOrigin() + front * distance1
		local distance2 = 450
		local target_pos2 = this:GetCaster():GetOrigin() + front * distance2
		
			local enemies = FindUnitsInRadius(
			this:GetCaster():GetTeamNumber(),
			target_pos1,
			nil,
			target_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- for each affected enemies
		for _,enemy in pairs(enemies) do
			-- Get Stack
			local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
			local stack = 0
			if modifier~=nil then
				stack = modifier:GetStackCount()
			end

			-- Apply damage
			local damageTable = {
				victim = enemy,
				attacker = this:GetCaster(),
				damage = base_damage + stack*stack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damageTable )

			if modifier==nil then
				enemy:AddNewModifier(
					this:GetCaster(),
					this,
					"modifier_shadow_fiend_shadowraze_lua",
					{duration = stack_duration}
				)
			else
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Effects
		shadowraze.PlayEffects( this, target_pos1, target_radius )	
		
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

		local enemies = FindUnitsInRadius(
			this:GetCaster():GetTeamNumber(),
			target_pos2,
			nil,
			target_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- for each affected enemies
		for _,enemy in pairs(enemies) do
			-- Get Stack
			local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
			local stack = 0
			if modifier~=nil then
				stack = modifier:GetStackCount()
			end

			-- Apply damage
			local damageTable = {
				victim = enemy,
				attacker = this:GetCaster(),
				damage = base_damage + stack*stack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damageTable )

			if modifier==nil then
				enemy:AddNewModifier(
					this:GetCaster(),
					this,
					"modifier_shadow_fiend_shadowraze_lua",
					{duration = stack_duration}
				)
			else
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Effects
		shadowraze.PlayEffects( this, target_pos2, target_radius )	
		end		
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------	
-----------------------------------------------------------------------------------------------------------------------------------------------------	
	
	local enemies = FindUnitsInRadius(
		this:GetCaster():GetTeamNumber(),
		target_pos,
		nil,
		target_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- for each affected enemies
	for _,enemy in pairs(enemies) do
		-- Get Stack
		local modifier = enemy:FindModifierByNameAndCaster("modifier_shadow_fiend_shadowraze_lua", this:GetCaster())
		local stack = 0
		if modifier~=nil then
			stack = modifier:GetStackCount()
		end

		-- Apply damage
		local damageTable = {
			victim = enemy,
			attacker = this:GetCaster(),
			damage = base_damage + stack*stack_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = this,
		}
		ApplyDamage( damageTable )

		if modifier==nil then
			enemy:AddNewModifier(
				this:GetCaster(),
				this,
				"modifier_shadow_fiend_shadowraze_lua",
				{duration = stack_duration}
			)
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()
		end
	end

	-- Effects
	shadowraze.PlayEffects( this, target_pos, target_radius )
end

function shadowraze.PlayEffects( this, position, radius )
	-- get resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_cast = "Hero_Nevermore.Shadowraze"

	-- create particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	--local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(this, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
	-- create sound
	EmitSoundOnLocationWithCaster( position, sound_cast, this:GetCaster() )
end



-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
