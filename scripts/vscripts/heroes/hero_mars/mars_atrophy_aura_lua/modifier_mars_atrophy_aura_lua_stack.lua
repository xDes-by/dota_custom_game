
modifier_mars_atrophy_aura_lua_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_atrophy_aura_lua_stack:IsHidden()
	return true
end

function modifier_mars_atrophy_aura_lua_stack:IsDebuff()
	return false
end

function modifier_mars_atrophy_aura_lua_stack:IsPurgable()
	return false
end

function modifier_mars_atrophy_aura_lua_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_mars_atrophy_aura_lua_stack:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mars_atrophy_aura_lua_stack:OnCreated( kv )

end

function modifier_mars_atrophy_aura_lua_stack:OnRefresh( kv )
	
end

function modifier_mars_atrophy_aura_lua_stack:OnRemoved()
end

function modifier_mars_atrophy_aura_lua_stack:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveStack( self.bonus )
end