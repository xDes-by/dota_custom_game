--------------------------------------------------------------------------------
axe_berserkers_call_lua = class({})
LinkLuaModifier( "modifier_axe_berserkers_call_lua", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_str_lua", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_str_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_speed_lua", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_speed_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_debuff", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_call_lua_debuff", LUA_MODIFIER_MOTION_NONE )


function axe_berserkers_call_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return caster:GetIntellect()
    end
end



function axe_berserkers_call_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	StopSoundOn( sound_cast, self:GetCaster() )
end
function axe_berserkers_call_lua:OnAbilityPhaseStart()
	-- play effects 
	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	EmitSoundOn( sound_cast, self:GetCaster() )
	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function axe_berserkers_call_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	
	local abil = caster:FindAbilityByName("npc_dota_hero_axe_agi6")				-- радиус +1700
	if abil ~= nil then 
	bonus = abil:GetSpecialValueFor( "value" )
	radius = radius + bonus
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_axe_str6")             --- урон на время кола от силы
	if abil ~= nil then 
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_axe_berserkers_str_lua", -- modifier name
		{ duration = duration } -- kv
	)
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_axe_agi10")			--- бонус атакспид после агра
	if abil ~= nil then 
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_axe_berserkers_speed_lua", -- modifier name
		{ duration = duration } -- kv
	)
	end

	-- find units caught
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- call
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_axe_berserkers_call_lua_debuff", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- self buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_axe_berserkers_call_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	if #enemies>0 then
		local sound_cast = "Hero_Axe.Berserkers_Call"
		EmitSoundOn( sound_cast, self:GetCaster() )
	end
	self:PlayEffects()
end

--------------------------------------------------------------------------------
function axe_berserkers_call_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end