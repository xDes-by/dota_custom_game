innate_blitz_strike = class({})

LinkLuaModifier("modifier_innate_blitz_strike", "heroes/innates/blitz_strike", LUA_MODIFIER_MOTION_NONE)

function innate_blitz_strike:GetIntrinsicModifierName()
	return "modifier_innate_blitz_strike"
end





modifier_innate_blitz_strike = class({})

function modifier_innate_blitz_strike:IsHidden() return true end
function modifier_innate_blitz_strike:IsDebuff() return false end
function modifier_innate_blitz_strike:IsPurgable() return false end
function modifier_innate_blitz_strike:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_blitz_strike:GetMultiplier(victim)
	local ability = self:GetAbility()
	local damage_multiplier = 1

	if (ability and victim:GetTeam() == ability:GetTeam()) then
		return damage_multiplier
	end

	if ability and (not ability:IsNull()) and victim:GetHealthPercent() >= ability:GetSpecialValueFor("pct_health_threshold") then
		damage_multiplier = 0.01 * ability:GetSpecialValueFor("damage_multiplier")

		local blitz_pfx = ParticleManager:CreateParticle("particles/custom/innates/blitz_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
		ParticleManager:SetParticleControl(blitz_pfx, 0, victim:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(blitz_pfx)
	end

	return damage_multiplier
end


function modifier_innate_blitz_strike:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
	}
end

function modifier_innate_blitz_strike:GetModifierTotalDamageOutgoing_Percentage(params)
	local multiplier = self:GetMultiplier(params.target)
	if multiplier > 1 then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, params.target, params.original_damage * multiplier, nil)
	end
	return (multiplier - 1) * 100
end
