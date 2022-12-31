modifier_demo_invulnerable = class({})

function modifier_demo_invulnerable:GetTexture() return "modifier_invulnerable" end
function modifier_demo_invulnerable:IsPurgeException() return false end
function modifier_demo_invulnerable:IsPurgable() return false end
function modifier_demo_invulnerable:RemoveOnDeath() return false end

function modifier_demo_invulnerable:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end 
