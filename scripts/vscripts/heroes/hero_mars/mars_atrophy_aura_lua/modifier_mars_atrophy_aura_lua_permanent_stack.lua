
modifier_mars_atrophy_aura_lua_permanent_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_atrophy_aura_lua_permanent_stack:IsHidden()
	return false
end

function modifier_mars_atrophy_aura_lua_permanent_stack:IsDebuff()
	return false
end

function modifier_mars_atrophy_aura_lua_permanent_stack:IsPurgable()
	return false
end

function modifier_mars_atrophy_aura_lua_permanent_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_mars_atrophy_aura_lua_permanent_stack:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mars_atrophy_aura_lua_permanent_stack:OnCreated( kv )
	if not IsServer() then return end
	self:SetStackCount( kv.bonus )
end

function modifier_mars_atrophy_aura_lua_permanent_stack:OnRefresh( kv )
	if not IsServer() then return end
	self:SetStackCount( self:GetStackCount() + kv.bonus )
end

function modifier_mars_atrophy_aura_lua_permanent_stack:OnRemoved()
end

function modifier_mars_atrophy_aura_lua_permanent_stack:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_atrophy_aura_lua_permanent_stack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_mars_atrophy_aura_lua_permanent_stack:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end