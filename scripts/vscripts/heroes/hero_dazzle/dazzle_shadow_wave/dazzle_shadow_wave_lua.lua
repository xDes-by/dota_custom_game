dazzle_shadow_wave_lua = class({})
LinkLuaModifier( "modifier_dazzle_shadow_wave_lua", "heroes/hero_dazzle/dazzle_shadow_wave/dazzle_shadow_wave_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_grave_lua", "heroes/hero_dazzle/dazzle_shadow_wave/dazzle_shadow_wave_lua", LUA_MODIFIER_MOTION_NONE )

function dazzle_shadow_wave_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_int7") ~= nil	then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
    return 100+math.min(65000, self:GetCaster():GetIntellect()/100)
end


function dazzle_shadow_wave_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = caster

	self.radius = self:GetSpecialValueFor( "damage_radius" )
	self.bounce_radius = self:GetSpecialValueFor( "bounce_radius" )
	jumps = self:GetSpecialValueFor( "max_targets" )
	self.damage = self:GetSpecialValueFor( "damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str10")
	if abil ~= nil	then 
	self.damage = self:GetCaster():GetStrength()
	end
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_int10")
	if abil ~= nil	then 
	self.damage = self.damage + self:GetCaster():GetAttackDamage()
	end
	
	damage_type = DAMAGE_TYPE_PHYSICAL
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_int8")
	if abil ~= nil	then 
	damage_type = DAMAGE_TYPE_MAGICAL
	end
	
	self.damageTable = {
		attacker = caster,
		damage = self.damage,
		damage_type = damage_type,
		ability = self,
	}

	self.healedUnits = {}
	table.insert( self.healedUnits, caster )

	self:Jump( jumps, caster, target )

	local sound_cast = "Hero_Dazzle.Shadow_Wave"
	EmitSoundOn( sound_cast, caster )
end


function dazzle_shadow_wave_lua:Jump( jumps, source, target )
	source:Heal( self.damage, self )
	
	jumps = self:GetSpecialValueFor( "max_targets" )

	local enemies = FindUnitsInRadius(
		source:GetTeamNumber(),	-- int, your team number
		source:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	if #enemies > 0 then
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_int11")
		if abil ~= nil	then 
		local abil2 = self:GetCaster():FindAbilityByName("dazzle_poison_touch_lua")
		if abil2 ~= nil and abil2:GetLevel() > 0 then
		 if enemies[1] ~= nil then
		source:CastAbilityOnTarget(enemies[1], abil2, -1)
		end
		end
		end
	
	for i =1, jumps do
		enemy = enemies[ RandomInt( 1, #enemies ) ]
		if not enemy:HasModifier("modifier_truesight") then
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			self:PlayEffects2( enemy )
			enemy:AddNewModifier(source, nil, "modifier_truesight", {duration = 0.1})
		end
	end
	

	local jump = jumps - 1
	if jump <0 then
		return
	end
end
	-- next target
	local nextTarget = nil
	if target and target~=source then
		nextTarget = target
	else
		-- Find ally nearby
		local allies = FindUnitsInRadius(
			source:GetTeamNumber(),	-- int, your team number
			source:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.bounce_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)
		
		for _,ally in pairs(allies) do
		
		
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dazzle_str9")
				if abil ~= nil	then 
				ally:AddNewModifier(source, ability, "modifier_grave_lua", {duration = 2})
				end	
				
				
			local pass = false
			for _,unit in pairs(self.healedUnits) do
				if ally==unit then
				pass = true
				
				end
			end

			if not pass then
				nextTarget = ally
				break
			end
		end
	end

	if nextTarget then
		table.insert( self.healedUnits, nextTarget )
		self:Jump( jump, nextTarget )
	end

	-- Play effects
	self:PlayEffects1( source, nextTarget )

end

--------------------------------------------------------------------------------
function dazzle_shadow_wave_lua:PlayEffects1( source, target )
--local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf"
local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"	

	if not target then
		target = source
	end


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, source )

	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		source,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		source:GetOrigin(), 
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), 
		true 
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function dazzle_shadow_wave_lua:PlayEffects2( target )

caster = self:GetCaster()
	
local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"

	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	 
	 	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(), 
		true
	)

	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), 
		true 
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


--------------------------------------------------------
modifier_grave_lua = class({})

function modifier_grave_lua:IsHidden()
	return false
end

function modifier_grave_lua:IsDebuff()
	return false
end

function modifier_grave_lua:IsPurgable()
	return false
end

function modifier_grave_lua:OnCreated( kv )
		local sound_cast = "Hero_Dazzle.Shallow_Grave"
		local abil = self:GetCaster():FindAbilityByName("dazzle_shallow_grave_lua")
		if abil ~= nil and abil:GetLevel() > 0 then
		self.hp = abil:GetSpecialValueFor("hp")
		EmitSoundOn( sound_cast, self:GetParent() )
end
end
function modifier_grave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_grave_lua:GetMinHealth()
	return 1
end

function modifier_grave_lua:GetModifierHealthRegenPercentage()

	return self.hp

end
function modifier_grave_lua:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf"
end

function modifier_grave_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end