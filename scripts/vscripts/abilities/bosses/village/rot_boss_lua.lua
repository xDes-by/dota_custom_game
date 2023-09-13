LinkLuaModifier( "modifier_rot_boss_lua", "abilities/bosses/village/rot_boss_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rot_boss_lua_effect", "abilities/bosses/village/rot_boss_lua", LUA_MODIFIER_MOTION_NONE )

rot_boss_lua = class({})

function rot_boss_lua:GetIntrinsicModifierName()
	return "modifier_rot_boss_lua"
end

modifier_rot_boss_lua = class({})

function modifier_rot_boss_lua:IsHidden()
	return false
end

function modifier_rot_boss_lua:IsDebuff()
	return true
end

function modifier_rot_boss_lua:IsPurgable()
	return false
end

function modifier_rot_boss_lua:RemoveOnDeath()
	return false
end

function modifier_rot_boss_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.rot_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.rot_damage = self:GetAbility():GetSpecialValueFor( "damage" ) * 0.2
	self.rot_tick = 0.2

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 0, 0))
	self:AddParticle(self.pfx, false, false, -1, false, false)	

	if not IsServer() then
		return
	end
	self:StartIntervalThink( self.rot_tick )
	self:OnIntervalThink()
end

function modifier_rot_boss_lua:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx , true)
		ParticleManager:ReleaseParticleIndex(self.pfx )
		StopSoundOn( "Hero_Pudge.Rot", self:GetCaster() )
	end
end

function modifier_rot_boss_lua:OnIntervalThink()
	if not self.parent:IsAlive() then
		return
	end
	local units = FindUnitsInRadius(self.parent:GetTeam(), self.parent:GetAbsOrigin(), nil, self.rot_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,u in pairs(units) do
		ApplyDamage({
			victim = u,
			attacker = self.parent,
			damage = self.rot_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		})
		u:AddNewModifier(self.parent, self:GetAbility(), "modifier_rot_boss_lua_effect", {duration = 3})
	end
end

modifier_rot_boss_lua_effect = class({})
--Classifications template
function modifier_rot_boss_lua_effect:IsHidden()
	return false
end

function modifier_rot_boss_lua_effect:IsDebuff()
	return true
end

function modifier_rot_boss_lua_effect:IsPurgable()
	return true
end

function modifier_rot_boss_lua_effect:IsPurgeException()
	return true
end

-- Optional Classifications
function modifier_rot_boss_lua_effect:IsStunDebuff()
	return false
end

function modifier_rot_boss_lua_effect:RemoveOnDeath()
	return true
end

function modifier_rot_boss_lua_effect:DestroyOnExpire()
	return true
end

function modifier_rot_boss_lua_effect:OnCreated()
	if not IsServer() then
		return
	end
	self.CurrentDebuff = 1
	self:SetStackCount(1)
end

function modifier_rot_boss_lua_effect:OnRefresh()
	if not IsServer() then
		return
	end
	self.CurrentDebuff = self.CurrentDebuff + 0.5
	self:SetStackCount(self.CurrentDebuff)
end

function modifier_rot_boss_lua_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_rot_boss_lua_effect:GetModifierBonusStats_Strength()
	return -self:GetStackCount()
end

function modifier_rot_boss_lua_effect:GetModifierBonusStats_Agility()
	return -self:GetStackCount()
end

function modifier_rot_boss_lua_effect:GetModifierBonusStats_Intellect()
	return -self:GetStackCount()
end