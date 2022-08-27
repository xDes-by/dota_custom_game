crystal_nova_lua = class({})
LinkLuaModifier( "modifier_crystal_nova_lua_thinker", "heroes/hero_crystal/crystal_nova_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_nova_lua", "heroes/hero_crystal/crystal_nova_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_manacost_nova_lua", "heroes/hero_crystal/crystal_nova_lua", LUA_MODIFIER_MOTION_NONE )

function crystal_nova_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect())
    end
end

function crystal_nova_lua:GetIntrinsicModifierName()
	return "modifier_manacost_nova_lua"
end

modifier_manacost_nova_lua = class({})

function modifier_manacost_nova_lua:IsHidden()
	return true
end

function modifier_manacost_nova_lua:IsDebuff()
	return false
end

function modifier_manacost_nova_lua:IsPurgable()
	return false
end

function modifier_manacost_nova_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
	}
	return funcs
end

function modifier_manacost_nova_lua:GetModifierPercentageManacost() 
    if self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int10") ~= nil then
        return 50
    end
end


function crystal_nova_lua:OnSpellStart()
	local caster = self:GetCaster()
	if _G.novatarget ~= nil then
	 	point = _G.novatarget:GetOrigin()
	else
		point = self:GetCursorPosition()
	end	
	local duration = self:GetSpecialValueFor("duration")
	
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_crystal_nova_lua_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	_G.novatarget = nil
end

modifier_crystal_nova_lua_thinker = class({})



--------------------------------------------------------------------------------

function modifier_crystal_nova_lua_thinker:OnCreated( kv )
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.burn_interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )
	local interval = self.burn_interval
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int11")	
		if abil ~= nil then 
		self.damage = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_agi9") 
		if abil ~= nil then
		self.damage = self:GetCaster():GetAttackDamage()
	end	


	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int7")
	if abil ~= nil then 
		self.damageTable = {
			--victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		}	
	else
		self.damageTable = {
			--victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE
		}
	end
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_crystal_nova_lua_thinker:OnDestroy()
	if IsServer() then

		UTIL_Remove(self)
	end
end

--------------------------------------------------------------------------------
function modifier_crystal_nova_lua_thinker:OnIntervalThink()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		self:GetCaster():Heal(self.damage * 0.1, self:GetAbility())
	end
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_crystal_nova_lua_thinker:PlayEffects()
	 --Get Resources
	local particle_cast =  "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	self.sound_cast =  "Hero_Crystal.CrystalNova"

	 --Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 450, 2, 450 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	--buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	--Create Sound
	EmitSoundOn( self.sound_cast, self:GetParent() )
end
