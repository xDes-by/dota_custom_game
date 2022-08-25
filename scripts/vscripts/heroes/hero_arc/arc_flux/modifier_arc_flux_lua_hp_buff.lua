modifier_arc_flux_lua_hp_buff = class({})


function modifier_arc_flux_lua_hp_buff:IsHidden()
	return false
end

function modifier_arc_flux_lua_hp_buff:IsDebuff()
	return true
end

function modifier_arc_flux_lua_hp_buff:IsStunDebuff()
	return false
end

function modifier_arc_flux_lua_hp_buff:IsPurgable()
	return false
end

function modifier_arc_flux_lua_hp_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_arc_flux_lua_hp_buff:OnCreated( kv )
self.regen = 10
if not IsServer() then return end	
end

function modifier_arc_flux_lua_hp_buff:OnRefresh( kv )	
end

function modifier_arc_flux_lua_hp_buff:OnRemoved()
end

function modifier_arc_flux_lua_hp_buff:OnDestroy()
end

function modifier_arc_flux_lua_hp_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_arc_flux_lua_hp_buff:GetModifierHealthRegenPercentage()

	return self.regen

end