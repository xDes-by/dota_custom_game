modifier_arc_flux_lua_hp = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_arc_flux_lua_hp:IsHidden()
	return false
end

function modifier_arc_flux_lua_hp:IsDebuff()
	return false
end

function modifier_arc_flux_lua_hp:IsPurgable()
	return false
end

function modifier_arc_flux_lua_hp:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if not IsServer() then return end
	local caster = self:GetCaster()

end

function modifier_arc_flux_lua_hp:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )	
end

function modifier_arc_flux_lua_hp:OnRemoved()
end

function modifier_arc_flux_lua_hp:OnDestroy()

end

function modifier_arc_flux_lua_hp:IsAura()
	return true
end

function modifier_arc_flux_lua_hp:GetModifierAura()
	return "modifier_arc_flux_lua_hp_buff"
end

function modifier_arc_flux_lua_hp:GetAuraRadius()
	return self.radius
end

function modifier_arc_flux_lua_hp:GetAuraDuration()
	return 0.5
end

function modifier_arc_flux_lua_hp:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_arc_flux_lua_hp:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_arc_flux_lua_hp:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_arc_flux_lua_hp:GetAuraEntityReject( hEntity )
	if IsServer() then	
	end
	return false
end