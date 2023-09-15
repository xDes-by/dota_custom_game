terrorblade_reflection_lua = class({})
LinkLuaModifier( "modifier_terrorblade_reflection_lua", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_terrorblade_reflection_lua_illusion", "heroes/hero_terror/terrorblade_reflection_lua/modifier_terrorblade_reflection_lua_illusion", LUA_MODIFIER_MOTION_NONE )

function terrorblade_reflection_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
end

function terrorblade_reflection_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function terrorblade_reflection_lua:GetCooldown( level )
	local abil = self:GetCaster():FindAbilityByName("modifier_npc_dota_hero_terrorblade_int8") 
	if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - self.BaseClass.GetCooldown(self, level) * 0.15
	end
	return self.BaseClass.GetCooldown(self, level)
end

function terrorblade_reflection_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor( "illusion_duration" )

	target:AddNewModifier( caster, self, "modifier_terrorblade_reflection_lua", { duration = duration } )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int7")
	if abil ~= nil then
		ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = self:GetCaster():GetIntellect(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
	
		local wave_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(wave_particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(wave_particle, 1, Vector(self.speed, self.speed, self.speed))
		ParticleManager:SetParticleControl(wave_particle, 2, Vector(self.speed, self.speed, self.speed))
		ParticleManager:ReleaseParticleIndex(wave_particle)
		local sound_cast = "Hero_Terrorblade.ConjureImage"
		EmitSoundOn( sound_cast, self:GetCaster() )
	end
end