modifier_void_spirit_aether_remnant_lua_pull = class({})


function modifier_void_spirit_aether_remnant_lua_pull:IsHidden() return false end
function modifier_void_spirit_aether_remnant_lua_pull:IsDebuff() return true end
function modifier_void_spirit_aether_remnant_lua_pull:IsStunDebuff() return true end
function modifier_void_spirit_aether_remnant_lua_pull:IsPurgable() return true end

function modifier_void_spirit_aether_remnant_lua_pull:OnCreated( kv )
	if not IsServer() then return end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	self.target = Vector( kv.pos_x, kv.pos_y, 0 )

	local dist = (parent:GetOrigin() - self.target):Length2D()
	self.speed = kv.pull / 100 * dist / kv.duration

	-- issue a move command
	parent:MoveToPosition( self.target )
end


function modifier_void_spirit_aether_remnant_lua_pull:OnRefresh( kv )
	self:OnCreated( kv )
end


function modifier_void_spirit_aether_remnant_lua_pull:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end

function modifier_void_spirit_aether_remnant_lua_pull:OnDestroy()
	local pull_particle = self:GetParent().void_spirit_pull_effect
	if pull_particle then
		ParticleManager:DestroyParticle(pull_particle, true)
		ParticleManager:ReleaseParticleIndex(pull_particle)
	end

	local primary_pull_particle = self:GetParent().void_spirit_pull_primary
	if primary_pull_particle then
		ParticleManager:DestroyParticle(primary_pull_particle, true)
		ParticleManager:ReleaseParticleIndex(primary_pull_particle)

		if self.pull_source and not self.pull_source:IsNull() then
			self.pull_source:WatchEffect()
		end
	end
end


function modifier_void_spirit_aether_remnant_lua_pull:GetModifierMoveSpeed_Absolute()
	if IsServer() then return self.speed end
end


function modifier_void_spirit_aether_remnant_lua_pull:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_aether_remnant_lua_pull:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf"
end

function modifier_void_spirit_aether_remnant_lua_pull:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end
