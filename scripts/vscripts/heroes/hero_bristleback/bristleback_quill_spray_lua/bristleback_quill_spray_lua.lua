bristleback_quill_spray_lua = class({})
LinkLuaModifier( "modifier_bristleback_quill_spray_lua", "heroes/hero_bristleback/bristleback_quill_spray_lua/modifier_bristleback_quill_spray_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_quill_spray_lua_stack", "heroes/hero_bristleback/bristleback_quill_spray_lua/modifier_bristleback_quill_spray_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_evasion", "heroes/hero_bristleback/modifier_evasion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_armor", "heroes/hero_bristleback/modifier_armor", LUA_MODIFIER_MOTION_NONE )


function bristleback_quill_spray_lua:GetManaCost(iLevel)
	return 40 + math.min(65000, self:GetCaster():GetIntellect() / 250)
end

function bristleback_quill_spray_lua:OnSpellStart()
	caster = self:GetCaster()
        stack_damage = self:GetSpecialValueFor("quill_stack_damage")
		base_damage = self:GetSpecialValueFor("quill_base_damage")
		max_damage = self:GetSpecialValueFor("max_damage")
	if caster:FindAbilityByName("npc_dota_hero_bristleback_int_last") ~= nil then
		stack_damage = self:GetSpecialValueFor("quill_stack_damage") * 3
		base_damage = self:GetSpecialValueFor("quill_base_damage") * 3
		max_damage = self:GetSpecialValueFor("max_damage") * 3
	end

	local radius = self:GetSpecialValueFor("radius")
	local stack_duration = self:GetSpecialValueFor("quill_stack_duration")

	if caster:FindAbilityByName("npc_dota_hero_bristleback_str_last") ~= nil then 
		base_damage = base_damage * 5
	end
	
	if caster:FindAbilityByName("npc_dota_hero_bristleback_int10") ~= nil then 
		max_damage = caster:GetIntellect()
	end

	damage_type = DAMAGE_TYPE_PHYSICAL
	damage_flags = DOTA_DAMAGE_FLAG_NONE

	if caster:FindAbilityByName("npc_dota_hero_bristleback_int11") ~= nil then 
		damage_type = DAMAGE_TYPE_MAGICAL
		max_damage = 500
	end
	
	if caster:FindAbilityByName("npc_dota_hero_bristleback_int7") ~= nil then 
		if RandomInt(1,100) <= 15 then
			local ability = caster:FindAbilityByName( "bristleback_viscous_nasal_goo_lua" )
			if ability ~= nil then ability:SetLevel(1)
				ability:OnSpellStart()
			end
		end
	end

	local damageTable = {
		attacker = caster,
		damage_type = damage_type,
		damage_flags = damage_flags,
		ability = self, --Optional.
	}
	
	if caster:FindAbilityByName("npc_dota_hero_bristleback_str7") ~= nil then 
		if not self:IsFullyCastable() then		---------------------------------------------костыль надо менять!!!!!!!!!!!!
			caster:AddNewModifier(caster, self, "modifier_armor", { duration = 2 })
		end
	end
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_bristleback_int50") ~= nil then
		self.special_bonus_unique_npc_dota_hero_bristleback_int50 = true
	end
	if caster:FindAbilityByName("npc_dota_hero_bristleback_str6") ~= nil then 
		if not self:IsFullyCastable() then
			self.npc_dota_hero_bristleback_str6 = true
		end
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,enemy in pairs(enemies) do
		local stack = 0
		local modifier = enemy:FindModifierByNameAndCaster( "modifier_bristleback_quill_spray_lua", caster )
		if modifier ~= nil then
			stack = modifier:GetStackCount()
		end

		damageTable.victim = enemy
		if self.special_bonus_unique_npc_dota_hero_bristleback_int50 then
			damageTable.damage = base_damage + stack*stack_damage
		else
			damageTable.damage = math.min(base_damage + stack*stack_damage, max_damage)
		end
		ApplyDamage( damageTable )

		enemy:AddNewModifier(caster, self, "modifier_bristleback_quill_spray_lua", { stack_duration = stack_duration })
		
		if self.npc_dota_hero_bristleback_str6 then
			enemy:AddNewModifier(caster, self, "modifier_evasion", {duration = 2})
		end
		self:PlayEffects2( enemy )
	end
	self:PlayEffects1()
end

function bristleback_quill_spray_lua:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
	 
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_Bristleback.QuillSpray.Cast", self:GetCaster() )
end

function bristleback_quill_spray_lua:PlayEffects2( target )
	local particle_cast = ""--"particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_Bristleback.QuillSpray.Target", self:GetCaster() )
end


-----------------------

--------------------------------------------------------------------------------
-- Helper
function bristleback_quill_spray_lua:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function bristleback_quill_spray_lua:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function bristleback_quill_spray_lua:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function bristleback_quill_spray_lua:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
	return ret
end

-----------------------