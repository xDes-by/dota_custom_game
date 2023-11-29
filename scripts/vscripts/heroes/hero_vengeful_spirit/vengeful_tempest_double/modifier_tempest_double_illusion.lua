modifier_tempest_double_illusion = class({})

function modifier_tempest_double_illusion:IsHidden() return true end
function modifier_tempest_double_illusion:IsPurgable() return false end

function modifier_tempest_double_illusion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION, -- GetUnitLifetimeFraction
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_tempest_double_illusion:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi9") then
		return 70 * self:GetAbility():GetLevel()
	end
end

function modifier_tempest_double_illusion:GetModifierIgnoreMovespeedLimit()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi9") then
		return 1
	end
	return 0
end

function modifier_tempest_double_illusion:OnTooltip()
	return self.outgoing_damage
end

function modifier_tempest_double_illusion:OnTooltip2()
	return self.incoming_damage
end

function modifier_tempest_double_illusion:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

function modifier_tempest_double_illusion:OnCreated( kv )
	self.incoming_damage = self:GetAbility():GetSpecialValueFor("incoming_damage")
	self.outgoing_damage = self:GetAbility():GetSpecialValueFor("outgoing_damage")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str8") then
		self.incoming_damage = self.incoming_damage - 35
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi12") then
		self.outgoing_damage = 100
	end
end

function modifier_tempest_double_illusion:OnDestroy()
	if not IsServer() then return end
	local parent = self:GetParent()

	parent:ForceKill(false)

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

	Timers:CreateTimer("arc_dying_sequence_" .. tostring(parent:GetEntityIndex()), {
		endTime = 3,
		callback = function()
			ParticleManager:DestroyParticle(particle, true)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	})
end

function modifier_tempest_double_illusion:GetModifierTotalDamageOutgoing_Percentage()
	return -100 + self.outgoing_damage
end

function modifier_tempest_double_illusion:GetModifierIncomingDamage_Percentage()
	return self.incoming_damage - 100
end
