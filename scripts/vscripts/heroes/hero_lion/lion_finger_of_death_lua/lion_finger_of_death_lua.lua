lion_finger_of_death_lua = class({})
LinkLuaModifier( "modifier_lion_finger_of_death_lua", "heroes/hero_lion/lion_finger_of_death_lua/modifier_lion_finger_of_death_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lion_finger_of_death_intrinsic_lua", "heroes/hero_lion/lion_finger_of_death_lua/lion_finger_of_death_lua", LUA_MODIFIER_MOTION_NONE )

function lion_finger_of_death_lua:GetAOERadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_int9")	
	if abil ~= nil then 
		return self:GetSpecialValueFor( "splash_radius_scepter" )
	end
	return 0
end

function lion_finger_of_death_lua:GetIntrinsicModifierName()
	return "modifier_lion_finger_of_death_intrinsic_lua"
end


function lion_finger_of_death_lua:GetCooldown( level )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lion_str_last") ~= nil then 
		return  self.BaseClass.GetCooldown( self, level ) - 20
	end
	return self.BaseClass.GetCooldown( self, level )
end

function lion_finger_of_death_lua:GetManaCost(iLevel)
	return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function lion_finger_of_death_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local sound_cast = "Hero_Lion.FingerOfDeath"
	EmitSoundOn( sound_cast, caster )

	if target:TriggerSpellAbsorb(self) then
		self:PlayEffects( target )
		return 
	end

	local delay = self:GetSpecialValueFor("damage_delay")
	local search = self:GetSpecialValueFor("splash_radius_scepter")

	-- find targets
	local targets = {}
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lion_int9") ~= nil then 
		targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			search,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	else
		table.insert(targets,target)
	end

	for _,enemy in pairs(targets) do
		-- delay
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_lion_finger_of_death_lua", -- modifier name
			{ duration = delay } -- kv
		)

		-- effects
		self:PlayEffects( enemy )
	end
end

--------------------------------------------------------------------------------
function lion_finger_of_death_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	local sound_cast = "Hero_Lion.FingerOfDeathImpact"

	-- load data
	local caster = self:GetCaster()
	local direction = (caster:GetOrigin()-target:GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
	--local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, caster )
	local attach = "attach_attack1"
	if caster:ScriptLookupAttachment( "attach_attack2" )~=0 then attach = "attach_attack2" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, target:GetOrigin() + direction )
	ParticleManager:SetParticleControlForward( effect_cast, 3, -direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

modifier_lion_finger_of_death_intrinsic_lua = class({})

function modifier_lion_finger_of_death_intrinsic_lua:IsHidden()
	return true
end

function modifier_lion_finger_of_death_intrinsic_lua:IsPurgable()
	return false
end

function modifier_lion_finger_of_death_intrinsic_lua:RemoveOnDeath()
	return false
end

function modifier_lion_finger_of_death_intrinsic_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end
function modifier_lion_finger_of_death_intrinsic_lua:OnAttack(params)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    if params.attacker == self:GetParent() and self.caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_lion_int50") and RandomInt(1, 100) <= 10 then
		self.caster:SetCursorCastTarget( params.target )
        self.ability:OnSpellStart()
    end
end