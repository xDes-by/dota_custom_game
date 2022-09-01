LinkLuaModifier( "modifier_rot_boss_lua", "abilities/bosses/village/rot_boss_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rot_boss_lua_effect", "abilities/bosses/village/rot_boss_lua", LUA_MODIFIER_MOTION_NONE )

rot_boss_lua = class({})

function rot_boss_lua:GetIntrinsicModifierName()
	return "modifier_rot_boss_lua"
end

-------------------------------------------------------------------------------

modifier_rot_boss_lua = class({})

function modifier_rot_boss_lua:IsHidden()
	return true
end

function modifier_rot_boss_lua:IsPurgable()
	return false
end

function modifier_rot_boss_lua:IsAura()
	return true
end

function modifier_rot_boss_lua:GetModifierAura()
	return "modifier_rot_boss_lua_effect"
end

function modifier_rot_boss_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_rot_boss_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_rot_boss_lua:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

----------------------------------------------------------------------------
modifier_rot_boss_lua_effect = class({})

function modifier_rot_boss_lua_effect:IsHidden()
	return false
end

function modifier_rot_boss_lua_effect:IsDebuff()
	return true
end

function modifier_rot_boss_lua_effect:IsPurgable()
	return false
end

function modifier_rot_boss_lua_effect:OnCreated( kv )
	self.rot_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.rot_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.rot_tick = 0.5

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 0, 0))
	self:AddParticle(self.pfx, false, false, -1, false, false)	

	self:StartIntervalThink( self.rot_tick )
	self:OnIntervalThink()
end

function modifier_rot_boss_lua_effect:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx , true)
		ParticleManager:ReleaseParticleIndex(self.pfx )
		StopSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
	end
end

function modifier_rot_boss_lua_effect:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsAlive() and self:GetParent() ~= self:GetCaster() then
			local damage = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.rot_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}
			ApplyDamage( damage )
		end
	end
end