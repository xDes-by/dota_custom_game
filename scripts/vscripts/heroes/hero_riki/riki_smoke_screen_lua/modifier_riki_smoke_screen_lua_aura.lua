modifier_riki_smoke_screen_lua_aura	= modifier_riki_smoke_screen_lua_aura or class({})

function modifier_riki_smoke_screen_lua_aura:OnCreated()
	self.radius		= self:GetAbility():GetSpecialValueFor("radius")
	
	self.smoke_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_smokebomb.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.smoke_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.smoke_particle, 1, Vector(self.radius, self.radius, self.radius))
	self:AddParticle(self.smoke_particle, false, false, -1, false, false)
end

function modifier_riki_smoke_screen_lua_aura:IsAura() 				return true end
function modifier_riki_smoke_screen_lua_aura:IsAuraActiveOnDeath()	return false end

function modifier_riki_smoke_screen_lua_aura:GetAuraRadius()			return self.radius or 0 end
function modifier_riki_smoke_screen_lua_aura:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_riki_smoke_screen_lua_aura:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_riki_smoke_screen_lua_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_riki_smoke_screen_lua_aura:GetModifierAura()			return "modifier_riki_smoke_screen_lua" end