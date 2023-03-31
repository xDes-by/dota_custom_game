--------------------------------------------------------------------------------
modifier_earthshaker_fissure_fly_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earthshaker_fissure_fly_lua:IsHidden()
	return true
end

function modifier_earthshaker_fissure_fly_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earthshaker_fissure_fly_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "fissure_range" ) + 100
    self.thinker = kv.isProvidedByAura~=1
end

function modifier_earthshaker_fissure_fly_lua:OnDestroy()
	if not IsServer() then return end
    if not self.thinker then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_earthshaker_fissure_fly_lua:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
    }
    return state
end
--------------------------------------------------------------------------------
-- Aura Effects
function modifier_earthshaker_fissure_fly_lua:IsAura()
	return self.thinker
end

function modifier_earthshaker_fissure_fly_lua:GetModifierAura()
	return "modifier_earthshaker_fissure_fly_lua"
end

function modifier_earthshaker_fissure_fly_lua:GetAuraRadius()
	return self.radius
end

function modifier_earthshaker_fissure_fly_lua:GetAuraDuration()
	return 0.5
end

function modifier_earthshaker_fissure_fly_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_earthshaker_fissure_fly_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_earthshaker_fissure_fly_lua:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations