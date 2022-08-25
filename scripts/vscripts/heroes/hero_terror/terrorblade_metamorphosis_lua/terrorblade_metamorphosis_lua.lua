terrorblade_metamorphosis_lua = class({})
LinkLuaModifier( "modifier_terrorblade_metamorphosis_lua", "heroes/hero_terror/terrorblade_metamorphosis_lua/modifier_terrorblade_metamorphosis_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_terrorblade_metamorphosis_split", "heroes/hero_terror/terrorblade_metamorphosis_lua/terrorblade_metamorphosis_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_terrorblade_metamorphosis_lua_aura", "heroes/hero_terror/terrorblade_metamorphosis_lua/modifier_terrorblade_metamorphosis_lua_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fear_thinker", "heroes/hero_terror/terrorblade_metamorphosis_lua/terrorblade_metamorphosis_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function terrorblade_metamorphosis_lua:Precache( context )
	PrecacheModel( "models/heroes/terrorblade/demon.vmdl", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf", context )
end

function terrorblade_metamorphosis_lua:GetManaCost(iLevel)
	return self:GetCaster():GetIntellect()
end



function terrorblade_metamorphosis_lua:GetCooldown(level)
	cd = self.BaseClass.GetCooldown(self, level)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_agi11") 
	if abil ~= nil then
		cd =  cd - 60
	 end
	return cd
end


-- Ability Start
function terrorblade_metamorphosis_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_int_last") ~= nil then
		duration = 99999
	end

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_terrorblade_metamorphosis_lua_aura", -- modifier name
		{ duration = duration } -- kv
	)
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_terrorblade_str7")
	if abil ~= nil then
	CreateModifierThinker(self:GetCaster(), self, "modifier_fear_thinker", {duration = 1600 / 1000}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
modifier_fear_thinker = class({})

function modifier_fear_thinker:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.fear_duration	= 2.5
	self.radius			= 1000
	self.speed			= 1000
	self.spawn_delay	= 0.6
	
	if not IsServer() then return end
	
	self.bLaunched		= false
	self.feared_units	= {}
	self.fear_modifier	= nil
	
	self:StartIntervalThink(self.spawn_delay)
end

-- Once again, wiki says nothing about a width (might be 1 for all I know, but I'll arbitrarily make it 50)
function modifier_fear_thinker:OnIntervalThink()
	if not self.bLaunched then
		self.bLaunched = true
		
		local wave_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(wave_particle, 0, self:GetParent():GetAbsOrigin())
		-- Yeah, this particle CP doesn't actually match the speed (vanilla uses 1400 as CP value, while the speed is 1600)
		ParticleManager:SetParticleControl(wave_particle, 1, Vector(self.speed, self.speed, self.speed))
		ParticleManager:SetParticleControl(wave_particle, 2, Vector(self.speed, self.speed, self.speed))
		ParticleManager:ReleaseParticleIndex(wave_particle)
		
		self:StartIntervalThink(-1)
		self:StartIntervalThink(FrameTime())
	else
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, math.min(self.speed * (self:GetElapsedTime() - self.spawn_delay), self.radius), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if not self.feared_units[enemy:entindex()] and (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= math.min(self.speed * (self:GetElapsedTime() - self.spawn_delay), self.radius) - 50 then
				enemy:EmitSound("Hero_Terrorblade.Metamorphosis.Fear")
				
				-- Vanilla fear modifier
				self.fear_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", {duration = self.fear_duration})
				
				if self.fear_modifier then
					self.fear_modifier:SetDuration(self.fear_duration * (1 - enemy:GetStatusResistance()), true)
				end
				
				self.feared_units[enemy:entindex()] = true
			end
		end
	end
end
