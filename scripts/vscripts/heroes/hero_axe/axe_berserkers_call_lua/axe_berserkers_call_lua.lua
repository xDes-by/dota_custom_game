--------------------------------------------------------------------------------
axe_berserkers_call_lua = class({})
LinkLuaModifier( "modifier_axe_berserkers_call_lua", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_str_lua", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_str_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_rearm", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_rearm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_debuff", "heroes/hero_axe/axe_berserkers_call_lua/modifier_axe_berserkers_call_lua_debuff", LUA_MODIFIER_MOTION_NONE )


function axe_berserkers_call_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
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

function axe_berserkers_call_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	
	if caster:FindAbilityByName("npc_dota_hero_axe_agi6")  ~= nil then 
		bonus = abil:GetSpecialValueFor( "value" )
		radius = radius + bonus
	end
	
	if caster:FindAbilityByName("npc_dota_hero_axe_str6") ~= nil then 
		caster:AddNewModifier( caster, self, "modifier_axe_berserkers_str_lua", { duration = duration })
	end
	

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier( caster, self, "modifier_axe_berserkers_call_lua_debuff", { duration = duration })
		
		-- if caster:FindAbilityByName("npc_dota_hero_axe_agi10") ~= nil then 
		-- 	enemy:AddNewModifier( caster, self, "modifier_axe_berserkers_rearm", { duration = duration })
		-- end
	end

	caster:AddNewModifier( caster, self, "modifier_axe_berserkers_call_lua", { duration = duration } )

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