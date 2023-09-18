centaur_repel_lua = class({})
LinkLuaModifier( "modifier_centaur_repel_lua", "heroes/hero_centaur/centaur_repel_lua/modifier_centaur_repel_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_repel_lua_disarmor", "heroes/hero_centaur/centaur_repel_lua/modifier_centaur_repel_lua_disarmor", LUA_MODIFIER_MOTION_NONE )


function centaur_repel_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function centaur_repel_lua:OnSpellStart()
	local caster = self:GetCaster()

	local buffDuration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_centaur_repel_lua", -- modifier name
		{ duration = buffDuration } -- kv
	)
	self:PlayEffects()
end

function centaur_repel_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end