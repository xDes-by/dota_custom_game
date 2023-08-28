modifier_riki_smoke_screen_lua_aura_buff		= modifier_riki_smoke_screen_lua_aura_buff or class({})

function modifier_riki_smoke_screen_lua_aura_buff:OnCreated()
	self.radius		= self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_riki_smoke_screen_lua_aura_buff:IsAura() 				return true end
function modifier_riki_smoke_screen_lua_aura_buff:IsAuraActiveOnDeath()	return false end

function modifier_riki_smoke_screen_lua_aura_buff:GetAuraRadius()			return self.radius or 0 end
function modifier_riki_smoke_screen_lua_aura_buff:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_riki_smoke_screen_lua_aura_buff:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_riki_smoke_screen_lua_aura_buff:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_riki_smoke_screen_lua_aura_buff:GetModifierAura()		return "modifier_riki_smoke_screen_lua_buff" end

----------------------------------------------
-- MODIFIER_riki_smoke_screen_lua_BUFF --
----------------------------------------------

modifier_riki_smoke_screen_lua_buff		= modifier_riki_smoke_screen_lua_buff or class({})

function modifier_riki_smoke_screen_lua_buff:OnCreated()
	self.agi = self:GetParent():GetAgility() / 10
	self.interval = 0.2
	if IsServer() then 
		self:StartIntervalThink(self.interval)
	end
end

function modifier_riki_smoke_screen_lua_buff:OnIntervalThink()
	self:IncrementStackCount()
end

function modifier_riki_smoke_screen_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_riki_smoke_screen_lua_buff:GetModifierBonusStats_Agility()
	return self.agi * self:GetStackCount() * self.interval
end

-- 