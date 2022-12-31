innate_fast_learner = class({})

LinkLuaModifier("modifier_innate_fast_learner", "heroes/innates/fast_learner", LUA_MODIFIER_MOTION_NONE)

function innate_fast_learner:GetIntrinsicModifierName()
	return "modifier_innate_fast_learner"
end

modifier_innate_fast_learner = class({})

function modifier_innate_fast_learner:IsHidden() return true end
function modifier_innate_fast_learner:IsDebuff() return false end
function modifier_innate_fast_learner:IsPurgable() return false end
function modifier_innate_fast_learner:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_fast_learner:OnRoundEndForTeam(keys)
	if IsClient() then return end

	local parent = self:GetParent()
	local ability = self:GetAbility()

	if (not parent) or parent:IsNull() or (not ability) or ability:IsNull() then return end

	local levels = ability:GetSpecialValueFor("amount")
	local frequency = ability:GetSpecialValueFor("frequency")

	if keys.round % frequency ~= 0 then return end

	Timers:CreateTimer(1, function()
		parent:HeroLevelUp(true)

		local pfx = ParticleManager:CreateParticle("particles/custom/bonus_levelup_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 15, Vector(255, 255, 255))
		ParticleManager:ReleaseParticleIndex(pfx)

		levels = levels - 1
		if levels > 0 then
			return 1
		end
	end)
end
