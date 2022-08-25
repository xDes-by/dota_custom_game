terrorblade_reflection_lua = class({})
LinkLuaModifier( "modifier_terrorblade_reflection_lua", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_terrorblade_reflection_lua_illusion", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua_illusion", LUA_MODIFIER_MOTION_NONE )

function terrorblade_reflection_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
end

function terrorblade_reflection_lua:GetManaCost(iLevel)
	return self:GetCaster():GetIntellect()
end


function terrorblade_reflection_lua:GetAOERadius()
	return self:GetSpecialValueFor( "range" )
end

function terrorblade_reflection_lua:GetCooldown( level )
	local abil = self:GetCaster():FindAbilityByName("modifier_npc_dota_hero_terrorblade_int8") 
	if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - self.BaseClass.GetCooldown(self, level) * 0.15
	 else
		return self.BaseClass.GetCooldown(self, level)
	 end
end

function terrorblade_reflection_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()

	local radius = self:GetSpecialValueFor( "range" )
	local duration = self:GetSpecialValueFor( "illusion_duration" )

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	if not enemy:HasModifier("modifier_terrorblade_reflection_lua") then
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_terrorblade_reflection_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int7")
	if abil ~= nil then
		
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		700,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
		)
		for _,enemy in pairs(enemies) do
		
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self, damage = self:GetCaster():GetIntellect(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		
		end
			local wave_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(wave_particle, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(wave_particle, 1, Vector(self.speed, self.speed, self.speed))
			ParticleManager:SetParticleControl(wave_particle, 2, Vector(self.speed, self.speed, self.speed))
			ParticleManager:ReleaseParticleIndex(wave_particle)
			local sound_cast = "Hero_Terrorblade.ConjureImage"
			EmitSoundOn( sound_cast, self:GetCaster() )
		end
end