modifier_zuus_nimbus = class({})

function modifier_zuus_nimbus:IsHidden()
	return false
end

function modifier_zuus_nimbus:IsDebuff()
	return true
end

function modifier_zuus_nimbus:IsStunDebuff()
	return false
end

function modifier_zuus_nimbus:IsPurgable()
	return false
end

function modifier_zuus_nimbus:OnCreated( kv )
	self.radius = kv.radius
	self.interval = self:GetAbility().interval
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.thinker = kv.isProvidedByAura~=1
	self.zuus_lightning_bolt_lua = self.caster:FindAbilityByName("zuus_lightning_bolt_lua")
	if not IsServer() then return end
	if self.thinker then return end
	self:StartIntervalThink( self.interval )
end

function modifier_zuus_nimbus:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end
function modifier_zuus_nimbus:OnIntervalThink()
	print("OnIntervalThink")
	if self.zuus_lightning_bolt_lua and self.zuus_lightning_bolt_lua:GetLevel() > 0 then
		self.zuus_lightning_bolt_lua:CastLightningBolt(
			self.caster, self.zuus_lightning_bolt_lua, self.parent, self.parent:GetAbsOrigin(), self.parent
		)
	end
end

function modifier_zuus_nimbus:IsAura()
	return self.thinker
end

function modifier_zuus_nimbus:GetModifierAura()
	return "modifier_zuus_nimbus"
end

function modifier_zuus_nimbus:GetAuraRadius()
	return self.radius
end

function modifier_zuus_nimbus:GetAuraDuration()
	return 0.5
end

function modifier_zuus_nimbus:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_zuus_nimbus:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_zuus_nimbus:GetAuraSearchFlags()
	return 0
end