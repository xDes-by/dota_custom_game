LinkLuaModifier("modifier_boss_medusa_stone", "heroes/hero_medusa/medusa_stone_gaze_lua/medusa_stone_gaze_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medusa_stone_gaze_lua", "heroes/hero_medusa/medusa_stone_gaze_lua/medusa_stone_gaze_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_modifier_medusa_stone_gaze_visual_lua", "heroes/hero_medusa/medusa_stone_gaze_lua/modifier_modifier_medusa_stone_gaze_visual_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medusa_stone_gaze_curse_lua", "heroes/hero_medusa/medusa_stone_gaze_lua/modifier_medusa_stone_gaze_curse_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medusa_stone_gaze_curse_applied_once_lua", "heroes/hero_medusa/medusa_stone_gaze_lua/modifier_medusa_stone_gaze_curse_lua", LUA_MODIFIER_MOTION_NONE)
medusa_stone_gaze_lua = class({})

function medusa_stone_gaze_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function medusa_stone_gaze_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function medusa_stone_gaze_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function medusa_stone_gaze_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_medusa_stone_gaze_lua", {})
	else
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_medusa_stone_gaze_lua", self:GetCaster())
	end
end

modifier_medusa_stone_gaze_lua = class({})

function modifier_medusa_stone_gaze_lua:OnCreated( kv )
	self.range = self:GetAbility():GetSpecialValueFor( "range" )
	self:SetStackCount(0)
	
    -- self:PlayEffects()
end

function modifier_medusa_stone_gaze_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_medusa_stone_gaze_lua:IsHidden()
	return true
end

function modifier_medusa_stone_gaze_lua:IsPurgable()
	return false
end

function modifier_medusa_stone_gaze_lua:IsAuraActiveOnDeath() return false end

function modifier_medusa_stone_gaze_lua:IsAura()
    return true
end

function modifier_medusa_stone_gaze_lua:GetModifierAura()
    return "modifier_modifier_medusa_stone_gaze_visual_lua"
end

function modifier_medusa_stone_gaze_lua:GetAuraRadius()
    return self.range
end

function modifier_medusa_stone_gaze_lua:GetAuraDuration()
    return 0
end

function modifier_medusa_stone_gaze_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_medusa_stone_gaze_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_medusa_stone_gaze_lua:PlayEffects()
	-- Create Particle
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf"
	local sound_cast = "Hero_Medusa.StoneGaze.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_head",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end