LinkLuaModifier("modifier_creature_brain_freeze", "creatures/abilities/regular/creature_brain_freeze", LUA_MODIFIER_MOTION_NONE)

creature_brain_freeze = class({})

function creature_brain_freeze:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local target_loc = target:GetAbsOrigin()

		target:EmitSound("CreatureBrainFreeze.Cast")

		local cast_pfx = ParticleManager:CreateParticle("particles/creature/brain_freeze.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, target_loc)
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		if (not target:IsMagicImmune()) then
			target:AddNewModifier(self:GetCaster(), self, "modifier_creature_brain_freeze", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()) })
		end
	end
end



modifier_creature_brain_freeze = class({})

function modifier_creature_brain_freeze:IsHidden() return false end
function modifier_creature_brain_freeze:IsDebuff() return true end
function modifier_creature_brain_freeze:IsPurgable() return true end

function modifier_creature_brain_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}
	return state
end
